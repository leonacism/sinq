package operation.gate;
import operation.gate.feature.ThreeQubitGate;
import operation.gate.feature.UnitaryGate;



/**
 * ...
 * @author leonaci
 */
class CSwapGate implements UnitaryGate extends ThreeQubitGate
{
	public function new() {
	}
	
	public function apply(target:NdArray):NdArray {
		var ozoSlice:Slice = '5';
		var zooSlice:Slice = '6';
		
		var ozo = target[ozoSlice].copy();
		
		target[ozoSlice] = target[zooSlice];
		target[zooSlice] = ozo;
		
		return target;
	}
	
	public function represent():NdArray {
		return NdArray.blockDiag([
			NdArray.diag([1, 1, 1, 1]),
			NdArray.array([
				[ 1, 0, 0, 0],
				[ 0, 0, 1, 0],
				[ 0, 1, 0, 0],
				[ 0, 0, 0, 1],
			]),
		], NdArrayDataType.COMPLEX);
	}
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		var c = qubit[0];
		var a = qubit[1];
		var b = qubit[2];
		
		var cnot = new CNotGate();
		var x = new XGate();
		var y = new YGate();
		var t = new ZGate(0.25);
		var s = new ZGate(0.5);
		
		return [
			cnot          .on([b,a]),
			y   .pow(-0.5).on([b  ]),
			t             .on([c  ]),
			t             .on([a  ]),
			t             .on([b  ]),
			cnot          .on([c,a]),
			cnot          .on([a,b]),
			t   .pow(-1  ).on([a  ]),
			t             .on([b  ]),
			cnot          .on([c,a]),
			cnot          .on([a,b]),
			t   .pow(-1  ).on([b  ]),
			cnot          .on([c,a]),
			cnot          .on([a,b]),
			t   .pow(-1  ).on([b  ]),
			x   .pow( 0.5).on([a  ]),
			cnot          .on([c,a]),
			cnot          .on([a,b]),
			s             .on([b  ]),
			x   .pow( 0.5).on([a  ]),
			x   .pow(-0.5).on([b  ]),
		];
	}
}