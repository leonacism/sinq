package operation.gate.feature;
import operation.GateOperation;

/**
 * ...
 * @author leonaci
 */
class BaseGate implements Gate {
	public var numQubits(get, null):Int;
	private function get_numQubits():Int return throw 'error : not implemented.';
	
	public function on(qubits:Array<Qubit>):GateOperation {
		if (qubits.length != numQubits) throw 'error : incorrect num of qubits.';
		return new GateOperation(this, qubits);
	}
}