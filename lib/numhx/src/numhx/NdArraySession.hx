package numhx;
import numhx.NdArray;
import numhx.backend.BackendKind;
import numhx.buffer.NdArrayBufferManager;

/**
 * ...
 * @author leonaci
 */
class NdArraySession
{
	@:allow(numhx.NdArray) static private var manager(get, null):NdArrayBufferManager;
	static function get_manager():NdArrayBufferManager {
		if (manager == null) throw 'error: no backend is set up yet.';
		return manager;
	}
	
	static public function setBackend(backendKind:BackendKind) 
	{
		var backend = switch(backendKind) {
			case BackendKind.Cpu: new numhx.backend.cpu.CpuBackend();
			case BackendKind.WebGL:
			{
				#if js
				new numhx.backend.webgl.WebGLBackend();
				#else
				throw 'WebGL backend is only supported for js target.';
				#end
			}
		}
		
		manager = new NdArrayBufferManager(backend);
	}
}