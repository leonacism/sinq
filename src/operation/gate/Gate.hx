package operation.gate;
import operation.Operation;

/**
 * @author leonaci
 */
interface Gate
{
	var numQubits(get, null):Int;
	
	/** provides an operation corresponding to this gate.*/
	function on(qubits:Array<Qubit>):Operation;
}