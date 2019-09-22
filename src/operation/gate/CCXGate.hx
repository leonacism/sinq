package operation.gate;
import operation.gate.feature.EigenGate;
import operation.gate.feature.ThreeQubitGate;
import operation.gate.feature.UnitaryGate;
import util.Complex;
import util.NdArray;

/**
 * ...
 * @author leonaci
 */
class CCXGate implements EigenGate extends ThreeQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new CCXGate(this.exponent + exponent);
		return gate;
	}
	
	public function represent():NdArray {
		var zero = Complex.zero;
		var one = Complex.one;
		var j = Complex.j;
		var a = Complex.j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		return NdArray.blockDiag([
			NdArray.diag([one, one, one, one]),
			NdArray.array([
				[ one, zero,       zero,       zero],
				[zero,  one,       zero,       zero],
				[zero, zero,      a * c, -j * a * s],
				[zero, zero, -j * a * s,      a * c],
			]),
		]);
	}
}