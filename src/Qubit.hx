package;

/**
 * ...
 * @author leonaci
 */
class Qubit
{
	static private var UID:Int = 0;
	
	public var id:Int;
	
	public function new() 
	{
		id = UID++;
	}
	
}