package numhx;

import mtprng.MT;

/**
 * ...
 * @author leonaci
 */
class Random
{
	static private var seed_:Null<UInt>;

	static public  function seed(s:UInt) {
		seed_ = s;
	}

	static public function choice(probs:Array<Float>):Int {
		var r = random();
		for(i in 0...probs.length) if((r-=probs[i])<0) return i;
		return throw '!?';
	}

	static public function randint(a:Int, b:Int):Int {
		if(a>b) throw 'error: invalid interval.';
		return a + new MT(seed_).random(b-a);
	}
	
	static public function random():Float {
		return new MT(seed_).randomFloat();
	}
}