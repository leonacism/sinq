package operation;

/**
 * ...
 * @author leonaci
 */
class Moment
{
	public var operations(default, null):Array<Operation>;
	public var qubits(default, null):Array<Qubit>;
	public var affected(default, null):Array<Int>;
	
	public function new(?operations:Array<Operation>)
	{
		this.operations = [];
		qubits = [];
		affected = [];
		
		if (operations != null) for (op in operations) addOperation(op);
	}
	
	public function addOperation(op:Operation):Void {
		var duplicated = false;
		for (id in op.keys()) duplicated = duplicated || affected.indexOf(id) != -1;
		if (duplicated) throw 'error : The qubit to operate on is duplicated.';
		
		operations.push(op);
		for (q in op.qubits) {
			affected.push(q.id);
			qubits.push(q);
		}
	}
}