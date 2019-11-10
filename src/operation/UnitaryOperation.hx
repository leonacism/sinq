package operation;
import numhx.NdArray;
import operation.gate.Gate;
import operation.gate.channel.Measurement;
import operation.gate.feature.UnitaryGate;


/**
 * ...
 * @author leonaci
 */
class UnitaryOperation implements Operation
{
	private var gate:UnitaryGate;

	public var qubits(default, null):Array<Qubit>;
	public var operationKind(get, null):OperationKind;
	inline function get_operationKind():OperationKind return OperationKind.Unitary;
	
	public function new(gate:UnitaryGate, qubits:Array<Qubit>) 
	{
		if(gate.numQubits != qubits.length) throw 'error : incorrect num of qubits.';
		this.gate = gate;
		this.qubits = qubits;
	}
	
	public function apply(target:NdArray):NdArray {
		return gate.apply(target);
	}
	
	public function represent():NdArray {
		return gate.represent();
	}
	
	public function decompose():Array<Operation> {
		return gate.decompose(qubits);
	}
	
	public function keys():Iterator<Qid> {
		return [for (q in qubits) q.id].iterator();
	}
}