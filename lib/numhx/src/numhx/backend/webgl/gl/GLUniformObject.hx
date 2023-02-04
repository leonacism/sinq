package numhx.backend.webgl.gl;
import haxe.ds.Map;
import js.html.webgl.GL;
import numhx.backend.webgl.gl.GLConstants.PrimitiveType;

/**
 * ...
 * @author leonaci
 */
class GLUniformObject {
	private var gl:GL;
	
	private var data:Map<String, GLUniformData>;
	private var children:Map<String, GLUniformObject>;

	public function new(gl:GL) {
		this.gl = gl;
		children = new Map();
		data = new Map();
	}
	
	public inline function get(key:String):Any {
		if(!data.exists(key)) return null;
		return data[key].value;
	}
	
	public function set(key:String, value:Any):Void {
		if(!data.exists(key)) return;
		data[key].value = value;
		uniform(data[key]);
	}
	
	private inline function uniform(data:GLUniformData):Void {
		return
			if(data.size==1) switch(data.type) {
				case PrimitiveType.Float     : gl.uniform1f(data.location, data.value);
				case PrimitiveType.FloatVec2 : gl.uniform2f(data.location, data.value[0], data.value[1]);
				case PrimitiveType.FloatVec3 : gl.uniform3f(data.location, data.value[0], data.value[1], data.value[2]);
				case PrimitiveType.FloatVec4 : gl.uniform4f(data.location, data.value[0], data.value[1], data.value[2], data.value[3]);
				
				case PrimitiveType.Int       : gl.uniform1i(data.location, data.value);
				case PrimitiveType.IntVec2   : gl.uniform2i(data.location, data.value[0], data.value[1]);
				case PrimitiveType.IntVec3   : gl.uniform3i(data.location, data.value[0], data.value[1], data.value[2]);
				case PrimitiveType.IntVec4   : gl.uniform4i(data.location, data.value[0], data.value[1], data.value[2], data.value[3]);
				
				case PrimitiveType.Bool      : gl.uniform1i(data.location, data.value? 1 : 0);
				case PrimitiveType.BoolVec2  : gl.uniform2i(data.location, data.value[0]? 1 : 0, data.value[1]? 1 : 0);
				case PrimitiveType.BoolVec3  : gl.uniform3i(data.location, data.value[0]? 1 : 0, data.value[1]? 1 : 0, data.value[2]? 1 : 0);
				case PrimitiveType.BoolVec4  : gl.uniform4i(data.location, data.value[0]? 1 : 0, data.value[1]? 1 : 0, data.value[2]? 1 : 0, data.value[3]? 1 : 0);
				
				case PrimitiveType.FloatMat2 : gl.uniformMatrix2fv(data.location, false, data.value);
				case PrimitiveType.FloatMat3 : gl.uniformMatrix3fv(data.location, false, data.value);
				case PrimitiveType.FloatMat4 : gl.uniformMatrix4fv(data.location, false, data.value);
				
				case PrimitiveType.Sampler2D : gl.uniform1i(data.location, data.value);
				
				case _: throw 'unsupported type error.';
			}
			else switch(data.type) {
				case PrimitiveType.Float     : gl.uniform1fv(data.location, data.value);
				case PrimitiveType.FloatVec2 : gl.uniform2fv(data.location, data.value);
				case PrimitiveType.FloatVec3 : gl.uniform3fv(data.location, data.value);
				case PrimitiveType.FloatVec4 : gl.uniform4fv(data.location, data.value);
				
				case PrimitiveType.Int       : gl.uniform1iv(data.location, data.value);
				case PrimitiveType.IntVec2   : gl.uniform2iv(data.location, data.value);
				case PrimitiveType.IntVec3   : gl.uniform3iv(data.location, data.value);
				case PrimitiveType.IntVec4   : gl.uniform4iv(data.location, data.value);
				
				case PrimitiveType.Bool      : gl.uniform1iv(data.location, data.value);
				case PrimitiveType.BoolVec2  : gl.uniform2iv(data.location, data.value);
				case PrimitiveType.BoolVec3  : gl.uniform3iv(data.location, data.value);
				case PrimitiveType.BoolVec4  : gl.uniform4iv(data.location, data.value);
				
				case PrimitiveType.Sampler2D : gl.uniform1iv(data.location, data.value);
				
				case _: throw 'unsupported type error.';
			}
	}
}