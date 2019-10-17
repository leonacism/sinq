package;
import backend.Backend;
import backend.BackendKind;
import backend.cpu.CpuBackend;
import buffer.NdArrayBufferManager;
import buffer.NdArrayBufferView;

/**
 * ...
 * @author leonaci
 */
class Session
{
	@:allow(NdArray) static private var manager(get, null):NdArrayBufferManager;
	static function get_manager():NdArrayBufferManager {
		if (manager == null) throw 'error: no backend is set up yet.';
		return manager;
	}
	
	static public function setBackend(backendKind:BackendKind) 
	{
		var backend = switch(backendKind) {
			case BackendKind.Cpu: new CpuBackend();
		}
		
		manager = new NdArrayBufferManager(backend);
	}
}