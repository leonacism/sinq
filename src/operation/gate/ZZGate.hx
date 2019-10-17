package operation.gate;
import operation.gate.feature.EigenGate;
import operation.gate.feature.SingleQubitGate;
import operation.gate.feature.UnitaryGate;



/**
 * ...
 * @author leonaci
 */
class ZZGate implements EigenGate extends SingleQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new ZZGate(this.exponent + exponent);
		return gate;
	}
	
	public function represent():NdArray {
		var one = Complex.one;
		var a = Complex.j ^ (2*exponent);
		return NdArray.diag([one, a, a, one]);
	}
}