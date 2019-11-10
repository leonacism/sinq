package operation;
import numhx.NdArray;

/**
 * ...
 * @author leonaci
 */
interface Operation
{
	var qubits(default, null):Array<Qubit>;
	var operationKind(get, null):OperationKind;
	function keys():Iterator<Qid>;
}