package operation.gate;
import numhx.io.Complex;
import numhx.NdArray;
import numhx.Slice;
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
		var gate:UnitaryGate = new CNotGate(this.exponent * exponent);
		return gate;
	}
	
	public function apply(target:NdArray):NdArray {
		return switch(exponent) {
			case 1:
			{
				var zoSlice:Slice = '2';
				var ooSlice:Slice = '3';
				
				var oo = target[ooSlice].copy();
				
				target[ooSlice] = target[zoSlice];
				target[zoSlice] = oo;
				
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
		var a = Complex.j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		return NdArray.array([
			[ 1, 0,          0,          0],
			[ 0, 1,          0,          0],
			[ 0, 0,      a * c, -j * a * s],
			[ 0, 0, -j * a * s,      a * c],
		]);
	}
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		var c = qubit[0];
		var t = qubit[1];
		
		return [
			new  YGate(    -0.5).on([  t]),
			new CZGate(exponent).on([c,t]),
			new  YGate(     0.5).on([  t]),
		];
	}
}