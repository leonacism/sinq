package backend.cpu;
import backend.Backend;
import backend.cpu.CpuNdArrayOperation;
import backend.cpu.operation.CpuAbsOperation;
import backend.cpu.operation.CpuAcosOperation;
import backend.cpu.operation.CpuAddOperation;
import backend.cpu.operation.CpuAddScalarOperation;
import backend.cpu.operation.CpuAsinOperation;
import backend.cpu.operation.CpuAssignOperation;
import backend.cpu.operation.CpuAssignScalarOperation;
import backend.cpu.operation.CpuAtanOperation;
import backend.cpu.operation.CpuCeilOperation;
import backend.cpu.operation.CpuCosOperation;
import backend.cpu.operation.CpuDivOperation;
import backend.cpu.operation.CpuDivScalarOperation;
import backend.cpu.operation.CpuDotOperation;
import backend.cpu.operation.CpuExpOperation;
import backend.cpu.operation.CpuFloorOperation;
import backend.cpu.operation.CpuLogOperation;
import backend.cpu.operation.CpuMaxOperation;
import backend.cpu.operation.CpuMaxScalarOperation;
import backend.cpu.operation.CpuMinOperation;
import backend.cpu.operation.CpuMinScalarOperation;
import backend.cpu.operation.CpuMulOperation;
import backend.cpu.operation.CpuMulScalarOperation;
import backend.cpu.operation.CpuPowOperation;
import backend.cpu.operation.CpuPowScalarOperation;
import backend.cpu.operation.CpuRoundOperation;
import backend.cpu.operation.CpuSinOperation;
import backend.cpu.operation.CpuSqrtOperation;
import backend.cpu.operation.CpuSubOperation;
import backend.cpu.operation.CpuSubScalarOperation;
import backend.cpu.operation.CpuSubScalarOperation;
import backend.cpu.operation.CpuTanOperation;
import buffer.NdArrayBuffer;
import buffer.NdArrayBufferView.NdArrayBufferViewData;

/**
 * ...
 * @author leonaci
 */
class CpuBackend implements Backend
{

	public function new() 
	{
	}
	
	public function run(ops:Array<NdArrayOperation>):Void {
		for (op in ops) op.run();
	}
	
	public function createBuffer():NdArrayBuffer {
		return new CpuNdArrayBuffer();
	}
	
	public function assign(a:NdArrayBufferViewData, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAssignOperation(this, a, dummyDst, dst);
	}
	
	public function assignScalar(a:Dynamic, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAssignScalarOperation(this, a, dummyDst, dst);
	}
	
	public function add(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAddOperation(this, a, b, dst);
	}
	
	public function addScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAddScalarOperation(this, a, b, dst);
	}
	
	public function sub(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuSubOperation(this, a, b, dst);
	}
	
	public function subScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuSubScalarOperation(this, a, b, dst);
	}
	
	public function mul(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMulOperation(this, a, b, dst);
	}
	
	public function mulScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMulScalarOperation(this, a, b, dst);
	}
	
	public function div(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuDivOperation(this, a, b, dst);
	}
	
	public function divScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuDivScalarOperation(this, a, b, dst);
	}
	
	public function dot(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuDotOperation(this, a, b, dst);
	}
	
	// function
	
	public function abs(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAbsOperation(this, a, dst);
	}
	
	public function min(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMinOperation(this, a, b, dst);
	}
	
	public function minScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMinScalarOperation(this, a, b, dst);
	}
	
	public function max(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMaxOperation(this, a, b, dst);
	}
	
	public function maxScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuMaxScalarOperation(this, a, b, dst);
	}
	
	public function sin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuSinOperation(this, a, dst);
	}

	public function cos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuCosOperation(this, a, dst);
	}
	
	public function tan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuTanOperation(this, a, dst);
	}
	
	public function asin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAsinOperation(this, a, dst);
	}
	
	public function acos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAcosOperation(this, a, dst);
	}
	
	public function atan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuAtanOperation(this, a, dst);
	}
	
	public function exp(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuExpOperation(this, a, dst);
	}
	
	public function log(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuLogOperation(this, a, dst);
	}
	
	public function pow(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuPowOperation(this, a, b, dst);
	}
	
	public function powScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuPowScalarOperation(this, a, b, dst);
	}
	
	public function sqrt(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuSqrtOperation(this, a, dst);
	}
	
	public function round(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuRoundOperation(this, a, dst);
	}
	
	public function floor(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuFloorOperation(this, a, dst);
	}
	
	public function ceil(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new CpuCeilOperation(this, a, dst);
	}
}