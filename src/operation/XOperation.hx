package operation;
import util.Complex;
import util.NdArray;

/**
 * ...
 * @author leonaci
 */
class XOperation implements Operation
{
	public var qubits(default, null):Array<Qubit>;

	public function new(qubits:Array<Qubit>)
	{
		this.qubits = qubits;
	}
	
	public function represent():NdArray {
		return [
			[Complex.zero, Complex.one ],
			[Complex.one , Complex.zero],
		];
	}
	
	public function keys():Iterator<Int> {
		return [for (q in qubits) q.id].iterator();
	}
}