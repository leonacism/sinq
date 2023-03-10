package circuit.strategy;
import operation.Moment;
import operation.Operation;

/**
 * ...
 * @author leonaci
 */
class InsertStrategyNew implements InsertStrategy
{
	public function new() {}
	
	public function insert(moments:Array<Moment>, operations:Array<Operation>):Void {
		for (op in operations) {
			var newMoment = new Moment([op]);
			moments.push(newMoment);
		}
	}
}