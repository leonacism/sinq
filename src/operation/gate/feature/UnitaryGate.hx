package operation.gate.feature;
import numhx.NdArray;

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
	
	/** provides a decomposition of more elementally operations*/
	function decompose(qubit:Array<Qubit>):Array<Operation>;
}