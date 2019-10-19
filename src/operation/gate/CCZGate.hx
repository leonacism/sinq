package operation.gate;
import io.Complex;
import operation.gate.feature.EigenGate;
import operation.gate.feature.ThreeQubitGate;
import operation.gate.feature.UnitaryGate;



/**
 * ...
 * @author leonaci
 */
class CCZGate implements EigenGate extends ThreeQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new CCZGate(this.exponent + exponent);
		return gate;
	}
	
	public function apply(target:NdArray):NdArray {
		return switch(exponent) {
			case 0:
			{
				target;
			}
			case _:
			{
				var oooSlice:Slice = '7';
				target[oooSlice] *= Complex.j ^ (2*exponent);
				target;
			}
		}
	}
	
	public function represent():NdArray {
		var a = Complex.j ^ (2*exponent);
		return NdArray.diag([1, 1, 1, 1, 1, 1, 1, a]);
	}
}