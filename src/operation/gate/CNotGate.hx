package operation.gate;
import io.Complex;
import operation.gate.feature.EigenGate;
import operation.gate.feature.TwoQubitGate;
import operation.gate.feature.UnitaryGate;


/**
 * ...
 * @author leonaci
 */
class CNotGate implements EigenGate extends TwoQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new CNotGate(this.exponent + exponent);
		return gate;
	}
	
	public function represent():NdArray {
		var zero = Complex.zero;
		var one = Complex.one;
		var j = Complex.j;
		var a = Complex.j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		return NdArray.array([
			[ one, zero,       zero,       zero],
			[zero,  one,       zero,       zero],
			[zero, zero,      a * c, -j * a * s],
			[zero, zero, -j * a * s,      a * c],
		]);
	}
}