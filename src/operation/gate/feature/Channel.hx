package operation.gate.feature;
import numhx.NdArray;

/**
 * @author leonaci
 */
interface Channel extends Gate
{
	function channel():Array<NdArray>;
}