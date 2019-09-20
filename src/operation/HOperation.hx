package operation;
import util.Complex;
import util.NdArray;

/**
 * ...
 * @author leonaci
 */
class HOperation implements Operation
{
	public var qubits(default, null):Array<Qubit>;

	public function new(qubits:Array<Qubit>)
	{
		this.qubits = qubits;
	}
	
	public function represent():NdArray {
		var c = Math.sqrt(0.5);
		return [
			[Complex.mulConst(c, Complex.one), Complex.mulConst(c, Complex.one)],
			[Complex.mulConst(c, Complex.one) , Complex.mulConst(-c, Complex.one)],
		];
	}
}