package operation;
import util.NdArray;

/**
 * ...
 * @author leonaci
 */
interface Operation
{
	var qubits(default, null):Array<Qubit>;
	function represent():NdArray;
	function keys():Iterator<Int>;
}