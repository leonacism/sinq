package operation.gate.feature;

/**
 * ...
 * @author leonaci
 */
class ThreeQubitGate implements Gate {
	public var numQubits(get, null):Int;
	inline function get_numQubits():Int return 3;

	public function on(qubits:Array<Qubit>):Operation throw 'error: not implemented.';
}