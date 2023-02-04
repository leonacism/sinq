package numhx.backend.webgl.gl;
import haxe.ds.Map;
import js.lib.Float32Array;
import js.lib.Int32Array;
import js.html.webgl.ActiveInfo;
import js.html.webgl.GL;
import js.html.webgl.Program;
import js.html.webgl.Shader;
import numhx.backend.webgl.gl.GLConstants.Precision;
import numhx.backend.webgl.gl.GLConstants.PrimitiveType;
import numhx.backend.webgl.gl.GLConstants.ShaderKind;

/**
 * ...
 * @author leonaci
 */
class GLShader {
	private var gl:GL;
	private var program:Program;
	
	public var attributes(default, null):Map<String, GLAttributeData>;
	public var uniforms(default, null):GLUniformObject;

	public function new(gl:GL, shader1:GLShaderKind, shader2:GLShaderKind) {
		this.gl = gl;
		
		var vertexSrc = '', fragmentSrc = '';
		switch [shader1, shader2] {
			case [GLShaderKind.Vertex(vertex, vertexPrecision), GLShaderKind.Fragment(fragment, fragmentPrecision)]
				|[GLShaderKind.Fragment(fragment, fragmentPrecision), GLShaderKind.Vertex(vertex, vertexPrecision)]:
				vertexSrc = setPrecision(vertex, vertexPrecision);
				fragmentSrc = setPrecision(fragment, fragmentPrecision);
				
			case [_, _]:
				throw 'The input shaders must be a pair of vertex and fragment shader.';
		}
		
		program = compileProgram(vertexSrc, fragmentSrc);
		
		attributes = extractAttributes(program);
		uniforms = createUniformObject(extractUniforms(program));
	}
	
	public function setPrecision(src:String, precision:Precision):String {
		var reg:EReg = ~/precision\s+(lowp|mediump|highp)\s+float;/;
		return if(reg.match(src)) {
			reg.replace(src, 'precision ${precision} float;');
		}
		else {
			'precision ${precision} float;${src}';
		}
	}
	
	public function bind():GLShader {
		gl.useProgram(program);
		return this;
	}
	
	public function dispose():Void {
		gl.deleteProgram(program);
		
		gl = null;
		program = null;
		
		attributes = null;
		uniforms = null;
	}
	
	private function compileProgram(vertexSrc:String, fragmentSrc:String):Program {
		var vertexShader   = compileShader(vertexSrc  , ShaderKind.VertexShader  );
		var fragmentShader = compileShader(fragmentSrc, ShaderKind.FragmentShader);
		
		var program = gl.createProgram();
		
		gl.attachShader(program,   vertexShader);
		gl.attachShader(program, fragmentShader);
		
		gl.linkProgram(program);
		
		if (!gl.getProgramParameter(program, GL.LINK_STATUS)) {
			trace('Could not initialize shader : ${gl.getError()}');
			
			if (gl.getProgramInfoLog(program) != '') {
				trace('${gl.getProgramInfoLog(program)}');
			}
			
			gl.deleteProgram(program);
			program = null;
		}
		
		gl.deleteShader(vertexShader);
		gl.deleteShader(fragmentShader);
		
		return program;
	}
	
	private function compileShader(src:String, kind:ShaderKind):Shader {
		var shader = gl.createShader(kind);
		
		gl.shaderSource(shader, src);
		gl.compileShader(shader);
		
		if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {
			trace(gl.getShaderInfoLog(shader));
			return null;
		}
		
		return shader;
	}
	
	private function extractAttributes(program:Program):Map<String, GLAttributeData> {
		var attributes = new Map();
		
		var totalAttributes:Int = gl.getProgramParameter(program, GL.ACTIVE_ATTRIBUTES);
		
		for (i in 0...totalAttributes) {
			var attribData:ActiveInfo = gl.getActiveAttrib(program, i);
			var size = mapSize(cast attribData.type);
			
			gl.bindAttribLocation(program, i, attribData.name);
			
			attributes[attribData.name] = {
				size: size,
				location: gl.getAttribLocation(program, attribData.name),
			};
		}
		
		return attributes;
	}
	
	private function extractUniforms(program:Program):Map<String, GLUniformData> {
		var uniforms = new Map();
		
		var totalUniforms:Int = gl.getProgramParameter(program, GL.ACTIVE_UNIFORMS);
		
		for (i in 0...totalUniforms) {
			var uniformData:ActiveInfo = gl.getActiveUniform(program, i);
			var name = ~/\[.*?\]/.replace(uniformData.name, '');
			var type:PrimitiveType = cast uniformData.type;
			
			uniforms[name] = {
				type: type,
				size: uniformData.size,
				location: gl.getUniformLocation(program, name),
				value: createDefaultValue(cast uniformData.type, uniformData.size),
			};
		}
		
		return uniforms;
	}
	
	@:access(numhx.backend.webgl.gl.GLUniformObject)
	private function createUniformObject(uniformData:Map<String, GLUniformData>):GLUniformObject {
		var uniform = new GLUniformObject(gl);
		for (key in uniformData.keys()) {
			var nameTokens = key.split('.');
			var name = nameTokens.pop();
			
			for (token in nameTokens) {
				var old =
					if (uniform.children[token] != null) uniform.children[token];
					else uniform.children[token] = new GLUniformObject(gl);
				
				uniform = old;
			}
			
			uniform.data[name] = uniformData[key];
		}
		return uniform;
	}
	
	private function mapSize(type:PrimitiveType):Int {
		return switch(type) {
			case PrimitiveType.Float:     1;
			case PrimitiveType.FloatVec2: 2;
			case PrimitiveType.FloatVec3: 3;
			case PrimitiveType.FloatVec4: 4;
			
			case PrimitiveType.Int:       1;
			case PrimitiveType.IntVec2:   2;
			case PrimitiveType.IntVec3:   3;
			case PrimitiveType.IntVec4:   4;
			
			case PrimitiveType.Bool:      1;
			case PrimitiveType.BoolVec2:  2;
			case PrimitiveType.BoolVec3:  3;
			case PrimitiveType.BoolVec4:  4;
			
			case PrimitiveType.FloatMat2: 4;
			case PrimitiveType.FloatMat3: 9;
			case PrimitiveType.FloatMat4: 16;
			
			case PrimitiveType.Sampler2D: 1;
			
			case _: throw 'this type is not supported.';
		}
	}
	
	private function createDefaultValue(type:PrimitiveType, size:Int):Any {
		return switch(type) {
			case PrimitiveType.Float:     0;
			case PrimitiveType.FloatVec2: new Float32Array(2 * size);
			case PrimitiveType.FloatVec3: new Float32Array(3 * size);
			case PrimitiveType.FloatVec4: new Float32Array(4 * size);
			
			case PrimitiveType.Int:       0;
			case PrimitiveType.IntVec2:   new Int32Array(2 * size);
			case PrimitiveType.IntVec3:   new Int32Array(3 * size);
			case PrimitiveType.IntVec4:   new Int32Array(4 * size);
			
			case PrimitiveType.Bool:      false;
			case PrimitiveType.BoolVec2:  [for(i in 0...2 * size) false];
			case PrimitiveType.BoolVec3:  [for(i in 0...3 * size) false];
			case PrimitiveType.BoolVec4:  [for(i in 0...4 * size) false];
			
			case PrimitiveType.FloatMat2: new Float32Array([1, 0,
															0, 1]);
			case PrimitiveType.FloatMat3: new Float32Array([1, 0, 0,
															0, 1, 0,
															0, 0, 1]);
			case PrimitiveType.FloatMat4: new Float32Array([1, 0, 0, 0,
															0, 1, 0, 0,
															0, 0, 1, 0,
															0, 0, 0, 1]);
			
			case PrimitiveType.Sampler2D: 0;
			
			case _: throw 'this type is not supported.';
		}
	}
}