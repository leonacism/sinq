package operation;

/**
 * ...
 * @author leonaci
 */
interface Operation
{
	var qubits(default, null):Array<Qubit>;
	var operationKind(get, null):OperationKind;
	function apply(target:NdArray):NdArray;
	function represent():NdArray;
	function decompose():Array<Operation>;
	function keys():Iterator<Qid>;
}