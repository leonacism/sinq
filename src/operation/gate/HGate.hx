package operation.gate;
import operation.gate.feature.EigenGate;
import operation.gate.feature.SingleQubitGate;
import operation.gate.feature.UnitaryGate;
import util.Complex;
import util.NdArray;

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
		var g = Complex.j ^ exponent;
		var j = Complex.j;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		var n = 1 / Math.sqrt(2);
		return [
			[ g * (c - j * s * n),      -j * g * s * n ],
			[     -j * g * s * n ,  g * (c + j * s * n)],
		];
	}
}