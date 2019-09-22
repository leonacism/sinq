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
		var a = Complex.j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		return [
			[ one, zero,               zero,               zero],
			[zero,  one,               zero,               zero],
			[zero, zero,              a * c, -Complex.j * a * s],
			[zero, zero, -Complex.j * a * s,              a * c],
		];
	}
}