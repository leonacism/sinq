package operation.gate;
import io.Complex;
import operation.gate.feature.EigenGate;
import operation.gate.feature.SingleQubitGate;
import operation.gate.feature.UnitaryGate;


/**
 * ...
 * @author leonaci
 */
class HGate implements EigenGate extends SingleQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new HGate(this.exponent + exponent);
		return gate;
	}
	
	public function represent():NdArray {
		var j = Complex.j;
		var a = j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		var n = 1 / Math.sqrt(2);
		return NdArray.array([
			[ a * (c - j * s * n),      -j * a * s * n ],
			[     -j * a * s * n ,  a * (c + j * s * n)],
		]);
	}
}