package numhx.backend.webgl.gl;
import numhx.backend.webgl.gl.GLConstants.Precision;

/**
 * @author leonaci
 */
enum GLShaderKind {
	Vertex(src:String, precision:Precision);
	Fragment(src:String, precision:Precision);
}