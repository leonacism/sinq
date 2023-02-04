package numhx.backend.webgl.gl;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasElement;
import js.html.webgl.ContextAttributes;
import js.html.webgl.GL;
/**
 * ...
 * @author leonaci
 */
class GLContext {
	static public function getContext(width:Int, height:Int, ?contextOptions:ContextAttributes):GL {
		var canvas:CanvasElement = cast js.Browser.document.createElement('canvas', '');
		Browser.document.body.appendChild(canvas);
		canvas.width = width;
		canvas.height = height;
		function resize() {
			var aspectWidth = Browser.window.innerWidth / width;
			var aspectHeight = Browser.window.innerHeight / height;
			var aspect = (aspectWidth > aspectHeight) ? aspectHeight : aspectWidth;
			canvas.style.position = 'absolute';
			canvas.style.margin = 'auto';
			canvas.style.width = '${width * aspect}px';
			canvas.style.height = '${height * aspect}px';
			canvas.style.top = '0px';
			canvas.style.left = '0px';
			canvas.style.bottom = '0px';
			canvas.style.right = '0px';
		}
		Browser.window.onresize = resize;
		resize();

		var gl:GL = canvas.getContextWebGL(contextOptions);
		
		if (gl == null) {
			throw 'This browser does not support webGL. Try using the canvas renderer';
		}
		
		return gl;
	}
}