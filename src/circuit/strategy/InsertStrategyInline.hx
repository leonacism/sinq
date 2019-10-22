package circuit.strategy;
import operation.Moment;
import operation.Operation;

/**
 * ...
 * @author leonaci
 */
class InsertStrategyInline implements InsertStrategy
{
	public function new() {}
	
	public function insert(moments:Array<Moment>, operations:Array<Operation>):Void {
		var begin = 0;
		
		if (moments.length == 0) {
			moments.push(new Moment([operations[0]]));
			begin = 1;
		}
		
		for (i in begin...operations.length) {
			var op = operations[i];
			var lastMoment = moments[moments.length - 1];
			var touched = false;
			
			for (id in op.keys()) touched = touched || lastMoment.affected.indexOf(id) != -1;
			touched? moments.push(new Moment([op])) : lastMoment.addOperation(op);
		}
	}
}