package ;

/**
 * ...
 * @author leonaci
 */
class Random
{

	static public function choice(probs:Array<Float>):Int {
		var r = Math.random();
		for(i in 0...probs.length) if((r-=probs[i])<0) return i;
		return throw '!?';
	}
	
}