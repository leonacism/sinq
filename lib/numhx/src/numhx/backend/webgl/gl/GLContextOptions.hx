package numhx.backend.webgl.gl;

/**
 * @author leonaci
 */
typedef GLContextOptions = {
	var ?alpha:Bool;
	var ?antialias:Bool;
	var ?depth:Bool;
	var ?failIfMajorPerformanceCaveat:Bool;
	var ?powerPreference:String;
	var ?premultipliedAlpha:Bool;
	var ?preserveDrawingBuffer:Bool;
	var ?stencil:Bool;
}