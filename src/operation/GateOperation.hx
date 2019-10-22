package operation;
import operation.gate.Gate;
import operation.gate.channel.Measurement;
import operation.gate.feature.UnitaryGate;


/**
 * ...
 * @author leonaci
 */
class GateOperation implements Operation
{
	public var gate(default, null):Gate;
	public var qubits(default, null):Array<Qubit>;
	public var operationKind(get, null):OperationKind;
	private function get_operationKind():OperationKind {
		return
			if(Std.is(gate, UnitaryGate)) OperationKind.Unitary;
			else if (Std.is(gate, Measurement)) OperationKind.Measurement;
			else throw 'error: unexpected operation kind!';
	}
	
	public function new(gate:Gate, qubits:Array<Qubit>) 
	{
		this.gate = gate;
		this.qubits = qubits;
	}
	
	public function apply(target:NdArray):NdArray {
		if (operationKind != OperationKind.Unitary) throw 'error : this operation is not unitary.';
		var gate:UnitaryGate = cast this.gate;
		return gate.apply(target);
	}
	
	public function represent():NdArray {
		if (operationKind != OperationKind.Unitary) throw 'error : this operation is not unitary.';
		var gate:UnitaryGate = cast this.gate;
		return gate.represent();
	}
	
	public function decompose():Array<Operation> {
		if (operationKind != OperationKind.Unitary) throw 'error : this operation is not unitary.';
		var gate:UnitaryGate = cast this.gate;
		return gate.decompose(qubits);
	}
	
	public function channel():Array<NdArray> {
		if (operationKind != OperationKind.Measurement) throw 'error : this operation is not measurement.';
		var gate:Measurement = cast this.gate;
		return gate.channel();
	}
	
	public function keys():Iterator<Qid> {
		return [for (q in qubits) q.id].iterator();
	}
}