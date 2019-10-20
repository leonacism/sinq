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
		var gate:UnitaryGate = new HGate(this.exponent * exponent);
		return gate;
	}
	
	public function apply(target:NdArray):NdArray {
		return switch(exponent) {
			case 1:
			{
				var zSlice:Slice = '0';
				var oSlice:Slice = '1';
				var z = target[zSlice];
				var o = target[oSlice];
				
				target[oSlice] -= target[zSlice];
				target[oSlice] *= -0.5;
				target[zSlice] -= target[oSlice];
				target *= Math.sqrt(2);
				
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
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		var q = qubit[0];
		return [
			new YGate(    0.25).on([q]),
			new XGate(exponent).on([q]),
			new YGate(   -0.25).on([q]),
		];
	}
}