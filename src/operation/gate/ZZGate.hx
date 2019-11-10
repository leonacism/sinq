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
class ZZGate implements EigenGate extends TwoQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new ZZGate(this.exponent * exponent);
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
				var ozSlice:Slice = '1';
				var zoSlice:Slice = '2';
				
				target[ozSlice] *= Complex.j ^ (2 * exponent);
				target[zoSlice] *= Complex.j ^ (2 * exponent);
				
				target;
			}
		}
	}
	
	public function represent():NdArray {
		var a = Complex.j ^ (2*exponent);
		return NdArray.diag([1, a, a, 1]);
	}
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		return null;
	}
	
	override public function on(qubits:Array<Qubit>):Operation {
		return new UnitaryOperation(this, qubits);
	}
}