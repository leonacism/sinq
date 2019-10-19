package operation.gate;
import operation.gate.feature.ThreeQubitGate;
import operation.gate.feature.UnitaryGate;



/**
 * ...
 * @author leonaci
 */
class CSwapGate implements UnitaryGate extends ThreeQubitGate
{
	public function new() {
	}
	
	public function apply(target:NdArray):NdArray {
		var ozoSlice:Slice = '5';
		var zooSlice:Slice = '6';
		
		var ozo = target[ozoSlice].copy();
		
		target[ozoSlice] = target[zooSlice];
		target[zooSlice] = ozo;
		
		return target;
	}
	
	public function represent():NdArray {
		return NdArray.blockDiag([
			NdArray.diag([1, 1, 1, 1]),
			NdArray.array([
				[ 1, 0, 0, 0],
				[ 0, 0, 1, 0],
				[ 0, 1, 0, 0],
				[ 0, 0, 0, 1],
			]),
		], NdArrayDataType.COMPLEX);
	}
}