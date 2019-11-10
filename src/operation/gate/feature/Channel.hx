package operation.gate.feature;
import numhx.NdArray;

/**
 * @author leonaci
 */
interface Channel extends Gate
{
	function applyChannel(i:Int, target:NdArray):NdArray;
	function channel():Array<NdArray>;
}