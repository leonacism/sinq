package;
import operation.Operation;

/**
 * ...
 * @author leonaci
 */
class Circuit
{
	public var numQubits(default, null):Int;
	public var qubits(default, null):Array<Qubit>;
	public var operations(default, null):Array<Operation>;
	
	public function new() {
		numQubits = 0;
		qubits = [];
		operations = [];
	}
	
	public function addOperation(operation:Operation):Void {
		operations.push(operation);
		for (qubit in operation.qubits) if (this.qubits.indexOf(qubit) == -1) {
			this.qubits.push(qubit);
			numQubits++;
		}
	}
}