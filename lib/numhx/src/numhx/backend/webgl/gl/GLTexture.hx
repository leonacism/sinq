package numhx.backend.webgl.gl;
import js.lib.Float32Array;
import js.html.ImageElement;
import js.html.webgl.GL;
import js.html.webgl.Texture;
import numhx.backend.webgl.gl.GLConstants.TextureDataType;
import numhx.backend.webgl.gl.GLConstants.TextureFormat;

/**
 * ...
 * @author leonaci
 */
class GLTexture {
	static private var FLOATING_POINT_AVAILABLE = false;
	
	private var gl:GL;
	
	private var width:Int;
	private var height:Int;
	
	private var format:TextureFormat;
	private var type:TextureDataType;
	
	private var texture:Texture;
	private var mipmap:Bool;
	private var premultiplyAlpha:Bool;
	
	
	public function new(gl:GL, ?width:Int=-1, ?height:Int=-1, ?format:TextureFormat=TextureFormat.Rgba, ?type:TextureDataType=TextureDataType.UnsignedByte) {
		this.gl = gl;
		
		this.width = width;
		this.height = height;
		
		this.format = format;
		this.type = type;
		
		texture = gl.createTexture();
		mipmap = false;
		premultiplyAlpha = false;
	}
	
	public function uploadSource(source:ImageElement):Void {
		bind();
		
		gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, premultiplyAlpha? 1 : 0);
		
		var newWidth = source.width, newHeight = source.height;
		if (newWidth != width || newHeight != height) {
			gl.texImage2D(GL.TEXTURE_2D, 0, format, format, type, source);
		}
		else {
			gl.texSubImage2D(GL.TEXTURE_2D, 0, 0, 0, format, type, source);
		}
		
		width = newWidth;
		height = newHeight;
	}
	
	public function uploadData(data:Float32Array, width:Int, height:Int) {
		bind();
		
		if (!FLOATING_POINT_AVAILABLE) {
			var ext = gl.getExtension('OES_texture_float');
			if (ext != null) {
				FLOATING_POINT_AVAILABLE = true;
			}
			else {
				throw 'floating point textures not available.';
			}
			
			type = TextureDataType.Float;
		}
		
		gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, premultiplyAlpha? 1 : 0);
		
		if (width != this.width || height != this.height) {
			gl.texImage2D(GL.TEXTURE_2D, 0, format, width, height, 0, format, type, data);
		}
		else {
			gl.texSubImage2D(GL.TEXTURE_2D, 0, 0, 0, width, height, format, type, data);
		}
		
		this.width = width;
		this.height = height;
	}
	
	public function bind(?location:Int):Void {
		if (location != null) gl.activeTexture(GL.TEXTURE0 + location);
		
		gl.bindTexture(GL.TEXTURE_2D, texture);
	}
	
	public function unbind():Void {
		gl.bindTexture(GL.TEXTURE_2D, null);
	}
	
	public function minFilter(linear:Bool):Void {
		bind();
		
		if (mipmap) {
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, linear? GL.LINEAR_MIPMAP_LINEAR : GL.NEAREST_MIPMAP_NEAREST);
		}
		else {
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, linear? GL.LINEAR : GL.NEAREST);
		}
	}
	
	public function magFilter(linear:Bool):Void {
		bind();
		
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, linear? GL.LINEAR : GL.NEAREST);
	}
	
	public function enableMipmap():Void {
		bind();
		mipmap = true;
		gl.generateMipmap(GL.TEXTURE_2D);
	}
	
	public function enableLinearScaling():Void {
		minFilter(true);
		magFilter(true);
	}
	
	public function enableNearestScaling():Void {
		minFilter(false);
		magFilter(false);
	}
	
	public function enableWrapClamp():Void {
		bind();
		
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
	}
	
	public function enableWrapRepeat():Void {
		bind();
		
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
	}
	
	public function enableWrapMirrorRepeat():Void {
		bind();
		
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.MIRRORED_REPEAT);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.MIRRORED_REPEAT);
	}
	
	public function dispose() {
		gl.deleteTexture(texture);
		
		gl = null;
		texture = null;
	}
	
	static public function fromSource(gl:GL, source:ImageElement, ?premultiplyAlpha:Bool=false):GLTexture {
		var texture = new GLTexture(gl);
		texture.premultiplyAlpha = premultiplyAlpha;
		texture.uploadSource(source);
		
		return texture;
	}
	
	static public function fromData(gl:GL, data:Float32Array, width:Int, height:Int):GLTexture {
		var texture = new GLTexture(gl);
		texture.uploadData(data, width, height);
		
		return texture;
	}
}