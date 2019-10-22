package operation.gate;
import numhx.io.Complex;
import numhx.NdArray;
import numhx.Slice;
import operation.gate.feature.EigenGate;
import operation.gate.feature.SingleQubitGate;
import operation.gate.feature.UnitaryGate;



/**
 * ...
 * @author leonaci
 */
class ZGate implements EigenGate extends SingleQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new ZGate(this.exponent * exponent);
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
				var oSlice:Slice = '1';
				
				target[oSlice] *= Complex.j ^ (2*exponent);
				
				target;
			}
		}
	}
	
	public function represent():NdArray {
		var a = Complex.j ^ (2*exponent);
		return NdArray.diag([1, a]);
	}
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		return null;
	}
}