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
class XGate implements EigenGate extends SingleQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new XGate(this.exponent + exponent);
		return gate;
	}
	
	public function represent():NdArray {
		var a = Complex.j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		return [
			[             a * c, -Complex.j * a * s],
			[-Complex.j * a * s,              a * c],
		];
	}
}