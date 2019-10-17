package operation.gate.feature;

/**
 * ...
 * @author leonaci
 */
interface UnitaryGate extends Gate
{
	/** provides an unitary matrix representation corresponding the gate.**/
	function represent():NdArray;
}