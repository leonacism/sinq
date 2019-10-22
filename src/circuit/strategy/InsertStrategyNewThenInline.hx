package circuit.strategy;
import operation.Moment;
import operation.Operation;

/**
 * ...
 * @author leonaci
 */
class InsertStrategyNewThenInline implements InsertStrategy
{
	public function new() {}
	
	public function insert(moments:Array<Moment>, operations:Array<Operation>):Void {
		moments.push(new Moment([operations[0]]));
		
		for (i in 1...operations.length) {
			var op = operations[i];
			var lastMoment = moments[moments.length - 1];
			var touched = false;
			
			for (id in op.keys()) touched = touched || lastMoment.affected.indexOf(id) != -1;
			touched? moments.push(new Moment([op])) : lastMoment.addOperation(op);
		}
	}
}