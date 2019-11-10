package operation.gate.feature;

/**
 * ...
 * @author leonaci
 */
class TwoQubitGate implements Gate {
	public var numQubits(get, null):Int;
	inline function get_numQubits():Int return 1;

	public function on(qubits:Array<Qubit>):Operation throw 'error: not implemented.';
}