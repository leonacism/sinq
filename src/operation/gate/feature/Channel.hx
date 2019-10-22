package operation.gate.feature;

/**
 * @author leonaci
 */
interface Channel extends Gate
{
	function channel():Array<NdArray>;
}