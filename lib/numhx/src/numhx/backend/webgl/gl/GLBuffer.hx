package numhx.backend.webgl.gl;
import js.lib.ArrayBuffer;
import js.lib.Float32Array;
import js.html.webgl.Buffer;
import js.html.webgl.GL;
import numhx.backend.webgl.gl.GLConstants.DrawKind;
import numhx.backend.webgl.gl.GLConstants.TargetBufferKind;

/**
 * ...
 * @author leonaci
 */
class GLBuffer {
	private var gl:GL;
	
	public var buffer(default,null):Buffer;
	public var data(default, null):ArrayBuffer;
	
	private var bufferKind:TargetBufferKind;
	private var drawKind:DrawKind;
	
	private function new(gl:GL, bufferKind:TargetBufferKind, ?data:ArrayBuffer, ?drawKind:DrawKind=DrawKind.StaticDraw) {
		this.gl = gl;
		
		buffer = gl.createBuffer();
		
		this.bufferKind = bufferKind;
		this.drawKind = drawKind;
		
		this.data = new Float32Array(0).buffer;
		if(data!=null) upload(data);
	}
	
	public function upload(data:ArrayBuffer, ?offset:Int=0, ?dontBind:Bool=false):Void {
		if (!dontBind) bind();
		
		if (this.data.byteLength >= data.byteLength) {
			gl.bufferSubData(bufferKind, offset, data);
		}
		else {
			gl.bufferData(bufferKind, data, drawKind);
		}
		
		this.data = data;
	}
	
	public function bind():Void {
		gl.bindBuffer(bufferKind, buffer);
	}
	
	public function dispose():Void {
		gl.deleteBuffer(buffer);
		
		gl = null;
		
		buffer = null;
		data = null;
	}
	
	static public function create(gl:GL, type:TargetBufferKind, ?data:ArrayBuffer, ?drawKind:DrawKind):GLBuffer {
		return new GLBuffer(gl, type, data, drawKind);
	}
	
	static public function createVertexBuffer(gl:GL, ?data:ArrayBuffer, ?drawKind:DrawKind):GLBuffer {
		return create(gl, TargetBufferKind.ArrayBuffer, data, drawKind);
	}
	
	static public function createIndexBuffer(gl:GL, ?data:ArrayBuffer, ?drawKind:DrawKind):GLBuffer {
		return create(gl, TargetBufferKind.ElementArrayBuffer, data, drawKind);
	}
}