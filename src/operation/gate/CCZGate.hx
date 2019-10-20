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
		var gate:UnitaryGate = new CCZGate(this.exponent * exponent);
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
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		var a = qubit[0];
		var b = qubit[1];
		var c = qubit[2];
		
		var p  = new ZGate( 0.25 * exponent);
		var pi = new ZGate(-0.25 * exponent);
		var cnot = new CNotGate();
		
		return [
			p   .on([a  ]),
			p   .on([b  ]),
			p   .on([c  ]),
			cnot.on([a,b]),
			cnot.on([b,c]),
			pi  .on([b  ]),
			p   .on([c  ]),
			cnot.on([a,b]),
			cnot.on([b,c]),
			pi  .on([c  ]),
			cnot.on([a,b]),
			cnot.on([b,c]),
			pi  .on([c  ]),
			cnot.on([a,b]),
			cnot.on([b,c]),
		];
	}
}