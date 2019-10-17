package operation.gate;
import operation.gate.feature.EigenGate;
import operation.gate.feature.TwoQubitGate;
import operation.gate.feature.UnitaryGate;



/**
 * ...
 * @author leonaci
 */
class YYGate implements EigenGate extends TwoQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new YYGate(this.exponent + exponent);
		return gate;
	}
	
	public function represent():NdArray {
		var a = Complex.j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		return NdArray.array([
			[    a * c,       zero,       zero, j * a * s],
			[     zero,      a * c, -j * a * s,      zero],
			[     zero, -j * a * s,      a * c,      zero],
			[j * a * s,       zero,       zero,     a * c],
		]);
	}
}