package operation.gate;
import operation.GateOperation;

/**
 * @author leonaci
 */
interface Gate 
{
	var numQubits(get, null):Int;
	private function get_numQubits():Int;
	
	/** provides an operation corresponding to this gate.*/
	function on(qubits:Array<Qubit>):GateOperation;
}