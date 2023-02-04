package numhx.backend.webgl.gl;
import js.html.webgl.GL;

/**
 * @author leonaci
 */
enum abstract ShaderKind(Int) to Int {
	var FragmentShader = GL.FRAGMENT_SHADER;
	var VertexShader = GL.VERTEX_SHADER;
}

enum abstract PrimitiveType(Int) to Int {
	var Float     = GL.FLOAT;
	var FloatVec2 = GL.FLOAT_VEC2;
	var FloatVec3 = GL.FLOAT_VEC3;
	var FloatVec4 = GL.FLOAT_VEC4;
	
	var Int       = GL.INT;
	var IntVec2   = GL.INT_VEC2;
	var IntVec3   = GL.INT_VEC3;
	var IntVec4   = GL.INT_VEC4;
	
	var Bool      = GL.BOOL;
	var BoolVec2  = GL.BOOL_VEC2;
	var BoolVec3  = GL.BOOL_VEC3;
	var BoolVec4  = GL.BOOL_VEC4;
	
	var FloatMat2 = GL.FLOAT_MAT2;
	var FloatMat3 = GL.FLOAT_MAT3;
	var FloatMat4 = GL.FLOAT_MAT4;
	
	var Sampler2D = GL.SAMPLER_2D;
}

enum abstract TextureFormat(Int) to Int {
	var Alpha = GL.ALPHA;
	var Rgb = GL.RGB;
	var Rgba = GL.RGBA;
	var Luminance = GL.LUMINANCE;
	var LuminanceAlpha = GL.LUMINANCE_ALPHA;
}

enum abstract TextureDataType(Int) to Int {
	var Byte = GL.BYTE;
	var Short = GL.SHORT;
	var UnsignedByte = GL.UNSIGNED_BYTE;
	var UnsignedShort = GL.UNSIGNED_SHORT;
	var Int = GL.INT;
	var UnsignedInt = GL.UNSIGNED_INT;
	var Float = GL.FLOAT;
}

enum abstract TargetBufferKind(Int) to Int {
	var ArrayBuffer = GL.ARRAY_BUFFER;
	var ElementArrayBuffer = GL.ELEMENT_ARRAY_BUFFER;
}

enum abstract DrawKind(Int) to Int {
	var StreamDraw = GL.STREAM_DRAW;
	var StaticDraw = GL.STATIC_DRAW;
	var DynamicDraw = GL.DYNAMIC_DRAW;
}

enum abstract GeomKind(Int) to Int {
	var Points = GL.POINTS;
	var Lines = GL.LINES;
	var LineLoop = GL.LINE_LOOP;
	var LineStrip = GL.LINE_STRIP;
	var Triangles = GL.TRIANGLES;
	var TriangleStrip = GL.TRIANGLE_STRIP;
	var TriangleFan = GL.TRIANGLE_FAN;
}

enum abstract InterpolationKind(Int) to Int {
	var Nearest = GL.NEAREST;
	var Linear = GL.LINEAR;
	var NearestMipmapNearest = GL.NEAREST_MIPMAP_NEAREST;
	var NearestMipmapLinear = GL.NEAREST_MIPMAP_LINEAR;
	var LinearMipmapNearest = GL.LINEAR_MIPMAP_NEAREST;
	var LinearMipmapLinear = GL.LINEAR_MIPMAP_LINEAR;
}

enum abstract WrapKind(Int) to Int {
	var Repeat = GL.REPEAT;
	var ClampToEdge = GL.CLAMP_TO_EDGE;
	var MirroredRepeat = GL.MIRRORED_REPEAT;
}

enum abstract BlendMode(Int) to Int {
	var Zero = GL.ZERO;
	var One = GL.ONE;
	var SrcColor = GL.SRC_COLOR;
	var DstColor = GL.DST_COLOR;
	var OneMinusSrcColor = GL.ONE_MINUS_SRC_COLOR;
	var OneMinusDstColor = GL.ONE_MINUS_DST_COLOR;
	var SrcAlpha = GL.SRC_ALPHA;
	var DstAlpha = GL.DST_ALPHA;
	var OneMinusSrcAlpha = GL.ONE_MINUS_SRC_ALPHA;
	var OneMinusDstAlpha = GL.ONE_MINUS_DST_ALPHA;
	var ConstantColor = GL.CONSTANT_COLOR;
	var OneMinusConstantColor = GL.ONE_MINUS_CONSTANT_COLOR;
	var ConstantAlpha = GL.CONSTANT_ALPHA;
	var OneMinusConstantAlpha = GL.ONE_MINUS_CONSTANT_ALPHA;
	var SrcAlphaSaturate = GL.SRC_ALPHA_SATURATE;
}

enum abstract Precision(String) to String {
	var Low = 'lowp';
	var Medium = 'mediump';
	var High = 'highp';
}