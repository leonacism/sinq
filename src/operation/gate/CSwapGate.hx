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
	
	public function represent():NdArray {
		var zero = Complex.zero;
		var one = Complex.one;
		
		return NdArray.blockDiag([
			NdArray.diag([one, one, one, one]),
			NdArray.array([
				[ one, zero, zero, zero],
				[zero, zero,  one, zero],
				[zero,  one, zero, zero],
				[zero, zero, zero,  one],
			]),
		]);
	}
}