package operation.gate;
import io.Complex;
import operation.gate.feature.EigenGate;
import operation.gate.feature.TwoQubitGate;
import operation.gate.feature.UnitaryGate;



/**
 * ...
 * @author leonaci
 */
class ISwapGate implements EigenGate extends TwoQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new ISwapGate(this.exponent * exponent);
		return gate;
	}
	
	public function apply(target:NdArray):NdArray {
		return switch(exponent) {
			case 1:
			{
				var ozSlice:Slice = '1';
				var zoSlice:Slice = '2';
				
				var oz:NdArray = target[ozSlice].copy();
				var zo:NdArray = target[zoSlice].copy();
				
				target[zoSlice] = oz;
				target[ozSlice] = zo;
				target[zoSlice] *= Complex.j;
				target[ozSlice] *= Complex.j;
				
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
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		var n = 1 / Math.sqrt(2);
		return NdArray.array([
			[ 1,     0,     0, 0],
			[ 0,     c, j * s, 0],
			[ 0, j * s,     c, 0],
			[ 0,     0,     0, 1],
		]);
	}
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		var a = qubit[0];
		var b = qubit[1];
		
		var cnot = new CNotGate();
		var h = new HGate();
		var z = new ZGate();
		var s = new ZGate(0.5*exponent);
		
		return [
			cnot        .on([a,b]),
			h           .on([a  ]),
			cnot        .on([b,a]),
			s           .on([a  ]),
			cnot        .on([b,a]),
			s   .pow(-1).on([a  ]),
			h           .on([a  ]),
			cnot        .on([a,b]),
		];
	}
}