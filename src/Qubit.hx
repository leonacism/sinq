package;
import haxe.crypto.Sha1;

/**
 * ...
 * @author leonaci
 */
class Qubit
{
	static private var UID:Int = 0;
	
	public var id:Qid;
	
	public function new() 
	{
		id = new Qid(UID++);
	}
	
}