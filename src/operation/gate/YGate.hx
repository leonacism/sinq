package operation.gate;
import io.Complex;
import operation.gate.feature.EigenGate;
import operation.gate.feature.SingleQubitGate;
import operation.gate.feature.UnitaryGate;



/**
 * ...
 * @author leonaci
 */
class YGate implements EigenGate extends SingleQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new YGate(this.exponent * exponent);
		return gate;
	}
	
	public function apply(target:NdArray):NdArray {
		return switch(exponent) {
			case 1:
			{
				var zSlice:Slice = '0';
				var oSlice:Slice = '1';
				
				var z = target[zSlice].copy();
				
				target[zSlice] = -target[oSlice];
				target[oSlice] =  z;
				target *= Complex.j;
				
				target;
			}
			case 0:
			{
				target;
			}
			case _:
			{
				null;
			}
		}
	}
	
	public function represent():NdArray {
		var a = Complex.j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		return NdArray.array([
			[a * c, -a * s],
			[a * s,  a * c],
		]);
	}
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		return null;
	}
}