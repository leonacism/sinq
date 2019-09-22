package;
import haxe.crypto.Sha1;

/**
 * ...
 * @author leonaci
 */
abstract Qid(String) to String {
	public inline function new(value:Int) this = Std.string(value);
}