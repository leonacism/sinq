package circuit.strategy;
import operation.Moment;
import operation.Operation;

/**
 * ...
 * @author leonaci
 */
interface InsertStrategy
{
	function insert(moments:Array<Moment>, operations:Array<Operation>):Void;
}