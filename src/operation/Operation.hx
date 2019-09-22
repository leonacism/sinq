package operation;
import util.NdArray;

/**
 * ...
 * @author leonaci
 */
interface Operation
{
	var qubits(default, null):Array<Qubit>;
	var operationKind(get, null):OperationKind;
	function represent():NdArray;
	function keys():Iterator<Qid>;
}