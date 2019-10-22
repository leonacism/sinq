package circuit.strategy;
import operation.Moment;
import operation.Operation;

/**
 * ...
 * @author leonaci
 */
class InsertStrategyEarliest implements InsertStrategy
{
	public function new() {}
	
	public function insert(moments:Array<Moment>, operations:Array<Operation>):Void {
		for (op in operations) {
			var touched = false;
			
			var i = moments.length;
			while (i > 0) {
				var m:Moment = moments[i - 1];
				for (id in op.keys()) touched = touched || m.affected.indexOf(id) != -1;
				if (touched) break;
				i--;
			}
			
			i == moments.length? moments.push(new Moment([op])) : moments[i].addOperation(op);
		}
	}
}