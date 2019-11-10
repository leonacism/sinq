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
class SwapGate implements EigenGate extends TwoQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new SwapGate(this.exponent * exponent);
		return gate;
	}
	
	public function apply(target:NdArray):NdArray {
		return switch(exponent) {
			case 1:
			{
				var ozSlice:Slice = '1';
				var zoSlice:Slice = '2';
				
				var oz = target[ozSlice].copy();
				var zo = target[zoSlice].copy();
				
				target[zoSlice] = oz;
				target[ozSlice] = zo;
				
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
			[ 1,          0,          0, 0],
			[ 0,      a * c, -j * a * s, 0],
			[ 0, -j * a * s,      a * c, 0],
			[ 0,          0,          0, 1],
		]);
	}
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		var a = qubit[0];
		var b = qubit[1];
		
		var cnot = new CNotGate();
		
		return [
			cnot.on([a, b]),
			cnot.pow(exponent).on([b, a]),
			cnot.on([a, b]),
		];
	}

	override public function on(qubits:Array<Qubit>):Operation {
		return new UnitaryOperation(this, qubits);
	}
}