package operation.gate;
import operation.gate.feature.EigenGate;
import operation.gate.feature.TwoQubitGate;
import operation.gate.feature.UnitaryGate;
import util.Complex;
import util.NdArray;

/**
 * ...
 * @author leonaci
 */
class CZGate implements EigenGate extends TwoQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new CZGate(this.exponent + exponent);
		return gate;
	}
	
	public function represent():NdArray {
		var one = Complex.one;
		var a = Complex.j ^ (2*exponent);
		return NdArray.diag([one, one, one, a]);
	}
}