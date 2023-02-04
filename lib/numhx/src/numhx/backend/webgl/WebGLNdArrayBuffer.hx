package numhx.backend.webgl;
import js.html.webgl.GL;
import js.lib.ArrayBufferView;
import js.lib.Float32Array;
import js.lib.Int32Array;
import js.lib.Uint8Array;
import numhx.backend.webgl.gl.GLFrameBuffer;
import numhx.buffer.NdArrayBuffer;
import numhx.io.Complex;

/**
 * ...
 * @author leonaci
 */
class WebGLNdArrayBuffer implements NdArrayBuffer
{
	private var gl:GL;
	
	private var textureSize:Int;
	private var buffer:GLFrameBuffer;
	
	private var data:ArrayBufferView;
	
	public var offset(default, null):Int;
	public var length(default, null):Int;
	public var itemsize(default, null):Int;
	public var dtype(default, null):NdArrayDataType;
	public var dirty:Bool;

	public function new(gl:GL) {
		this.gl = gl;
		offset = 0;
		dirty = false;
	}
	
	public function allocate(length:Int, dtype:NdArrayDataType):Void {
		this.length = length;
		this.dtype = dtype;
		
		itemsize = switch(dtype) {
			case NdArrayDataType.FLOAT: 4;
			case NdArrayDataType.INT: 4;
			case NdArrayDataType.COMPLEX: 8;
			case NdArrayDataType.BOOL: 1;
		}
		
		// allocate a buffer whose size is the smallest power of 2 that is not less than `length`.
		textureSize = 1;
		while (textureSize * textureSize * 4 < itemsize * length) textureSize *= 2;
		
		this.data = switch(dtype) {
			case NdArrayDataType.FLOAT: new Float32Array(textureSize * textureSize);
			case NdArrayDataType.INT: new Int32Array(textureSize * textureSize);
			case NdArrayDataType.COMPLEX: new Float32Array(textureSize * textureSize);
			case NdArrayDataType.BOOL: new Uint8Array(textureSize * textureSize * 4);
		}
		
		buffer = GLFrameBuffer.createFloat32(gl, textureSize, textureSize, null);
		//buffer.enableStencil();
		//gl.bindRenderbuffer(GL.RENDERBUFFER, null);
	}
	
	public function get(i:Int):Dynamic {
		buffer.bind();
		gl.readPixels(0, 0, textureSize, textureSize, GL.RGBA, GL.FLOAT, data);
		buffer.unbind();
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: cast(data, Float32Array)[offset + i];
			case NdArrayDataType.INT: cast(data, Int32Array)[offset + i];
			case NdArrayDataType.COMPLEX: Complex.fromComponents(cast(data, Float32Array)[offset + 2 * i], cast(data, Float32Array)[offset + 2 * i + 1]);
			case NdArrayDataType.BOOL: cast(data, Uint8Array)[offset + i] == 1;
		}
	}
	
	public function set(i:Int, v:Dynamic):Dynamic {
		switch(dtype) {
			case NdArrayDataType.FLOAT: cast(data, Float32Array)[offset + i] = v;
			case NdArrayDataType.INT: cast(data, Int32Array)[offset + i] = v;
			case NdArrayDataType.COMPLEX:
			{
				cast(data, Float32Array)[offset + 2 * i    ] = v.re;
				cast(data, Float32Array)[offset + 2 * i + 1] = v.im;
			}
			case NdArrayDataType.BOOL: cast(data, Uint8Array)[offset + i] = v? 1 : 0;
		}
		
		buffer.texture.bind();
		gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, textureSize, textureSize, 0, GL.RGBA, GL.FLOAT, data);
		buffer.texture.unbind();
		
		return v;
	}
	
	public function getValue():Array<Dynamic> {
		buffer.bind();
		gl.readPixels(0, 0, textureSize, textureSize, GL.RGBA, GL.FLOAT, data);
		buffer.unbind();
		
		return switch(dtype) {
			case NdArrayDataType.FLOAT: [for (i in 0...this.length) cast(data, Float32Array)[offset + i]];
			case NdArrayDataType.INT: [for (i in 0...this.length) cast(data, Int32Array)[offset + i]];
			case NdArrayDataType.COMPLEX:
			{
				[for (i in 0...this.length) Complex.fromComponents(cast(data, Float32Array)[offset + 2 * i], cast(data, Float32Array)[offset + 2 * i + 1])];
			}
			case NdArrayDataType.BOOL: [for (i in 0...this.length) cast(data, Uint8Array)[offset + i] == 1];
		}
	}
	
	public function setValue(v:Array<Dynamic>):Void {
		if (v.length != this.length) throw 'error: the size of values is mismatched.';
		
		switch(dtype) {
			case NdArrayDataType.FLOAT: for (i in 0...this.length) cast(data, Float32Array)[offset + i] = v[i];
			case NdArrayDataType.INT: for (i in 0...this.length) cast(data, Int32Array)[offset + i] = v[i];
			case NdArrayDataType.COMPLEX:
			{
				for (i in 0...this.length) {
					cast(data, Float32Array)[offset + 2 * i    ] = v[i].re;
					cast(data, Float32Array)[offset + 2 * i + 1] = v[i].im;
				}
			}
			case NdArrayDataType.BOOL: for (i in 0...this.length) cast(data, Uint8Array)[offset + i] = v[i]? 1 : 0;
		}
		
		buffer.texture.bind();
		gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, textureSize, textureSize, 0, GL.RGBA, GL.FLOAT, data);
		buffer.texture.unbind();
	}
	
	public function subarray( ?begin : Int, ?end : Int ) : NdArrayBuffer {
		var data = new WebGLNdArrayBuffer(gl);
		
		data.buffer = buffer;
		
		if( begin == null ) begin = 0;
		if( end == null ) end = this.length - begin;
		
		data.offset = offset + begin;
		data.length = end - begin;
		data.itemsize = itemsize;
		data.dtype = dtype;
		
		return data;
	}
	
	public function fill(?begin:Array<Int>, ?end:Array<Int>, ?slice:Array<Int>, v:Dynamic):Void {
	}
}