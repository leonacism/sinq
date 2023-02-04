package numhx.backend.webgl.gl;
import js.lib.Float32Array;
import js.html.webgl.Framebuffer;
import js.html.webgl.GL;
import js.html.webgl.Renderbuffer;

/**
 * ...
 * @author leonaci
 */
class GLFrameBuffer {
	private var gl:GL;
	
	private var width:Int;
	private var height:Int;
	
	private var framebuffer:Framebuffer;
	public var texture(default, null):GLTexture;
	private var stencil:Renderbuffer;
	
	private function new(gl:GL, ?width:Int = 100, ?height:Int = 100) {
		this.gl = gl;
		
		this.width = width;
		this.height = height;
		
		framebuffer = gl.createFramebuffer();
		texture = null;
		stencil = null;
	}
	
	@:access(numhx.backend.webgl.gl.GLTexture)
	public inline function enableTexture(?texture:GLTexture):Void {
		this.texture = texture!=null? texture : new GLTexture(gl);
		
		texture.bind();
		bind();
		
		gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture.texture, 0);
	}
	
	public inline function enableStencil():Void {
		if (stencil != null) return;
		
		stencil = gl.createRenderbuffer();
		
		gl.bindRenderbuffer(GL.RENDERBUFFER, stencil);
		
		gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER, stencil);
		gl.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_STENCIL, width, height);
	}
	
	public inline function clear(r:Float, g:Float, b:Float, a:Float):Void {
		bind();
		
		gl.clearColor(r, g, b, a);
		gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	}
	
	public inline function bind():Void {
		gl.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
	}
	
	public inline function unbind():Void {
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
	}
	
	public inline function resize(width:Int, height:Int):Void {
		this.width = width;
		this.height = height;
		
		if (texture != null) {
			texture.uploadData(null, width, height);
		}
		
		if (stencil != null) {
			gl.bindRenderbuffer(GL.RENDERBUFFER, stencil);
			gl.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_STENCIL, width, height);
		}
	}
	
	public function dipose():Void {
		if (texture != null) {
			texture.dispose();
		}
		
		gl.deleteFramebuffer(framebuffer);
		
		gl = null;
		
		framebuffer = null;
		stencil = null;
		texture = null;
	}
	
	static public function createPlain(gl:GL, ?width:Int, ?height:Int):GLFrameBuffer {
		var fbo = new GLFrameBuffer(gl, width, height);
		fbo.framebuffer = null;
		
		return fbo;
	}
	
	static public function createRGBA(gl:GL, width:Int, height:Int):GLFrameBuffer {
		var texture = GLTexture.fromData(gl, null, width, height);
		texture.enableNearestScaling();
		texture.enableWrapClamp();
		
		var fbo = new GLFrameBuffer(gl, width, height);
		fbo.enableTexture(texture);
		fbo.unbind();
		
		return fbo;
	}
	
	static public function createFloat32(gl:GL, width:Int, height:Int, data:Float32Array):GLFrameBuffer {
		var texture = GLTexture.fromData(gl, data, width, height);
		texture.enableNearestScaling();
		texture.enableWrapClamp();
		
		var fbo = new GLFrameBuffer(gl, width, height);
		fbo.enableTexture(texture);
		fbo.unbind();
		
		return fbo;
	}
}