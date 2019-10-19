package operation.gate.feature;

/**
 * ...
 * @author leonaci
 */
interface UnitaryGate extends Gate
{
	/** provides fast application of the unitary transformation.**/
	function apply(target:NdArray):NdArray;
	
	/** provides an unitary matrix representation corresponding the gate.**/
	function represent():NdArray;
}