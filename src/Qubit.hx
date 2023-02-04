package;

/**
 * ...
 * @author leonaci
 */
class Qubit
{
	static private var UID:Int = 0;
	
	public var id:Qid;
	
	private function new() 
	{
		id = new Qid(UID++);
	}
	
	static public function alloc():Qubit
	{
		return new Qubit();
	}
}