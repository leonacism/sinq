package operation;
import operation.gate.Gate;
import operation.gate.feature.UnitaryGate;
import util.NdArray;

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
		return if(Std.is(gate, UnitaryGate)) OperationKind.Unitary;
			
		else throw 'error: unexpected operation kind!';
	}
	
	public function new(gate:Gate, qubits:Array<Qubit>) 
	{
		this.gate = gate;
		this.qubits = qubits;
	}
	
	public function represent():NdArray {
		if (operationKind != OperationKind.Unitary) throw 'error : this operation is not unitary.';
		var gate:UnitaryGate = cast this.gate;
		return gate.represent();
	}
	
	public function keys():Iterator<Qid> {
		return [for (q in qubits) q.id].iterator();
	}
}