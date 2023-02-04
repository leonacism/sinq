package numhx.backend.webgl.gl;
import js.html.webgl.UniformLocation;
import numhx.backend.webgl.gl.GLConstants.PrimitiveType;

/**
 * @author leonaci
 */
typedef GLUniformData = {
	var size:Int;
	var location:UniformLocation;
	var type:PrimitiveType;
	var value:Dynamic;
}