package util;

/**
 * ...
 * @author leonaci
 */
class Complex
{
	static public var zero(get, null):Complex;
	static function get_zero():Complex return new Complex(0, 0);
	
	static public var one(get, null):Complex;
	static function get_one():Complex return new Complex(1, 0);
	
	static public var j(get, null):Complex;
	static function get_j():Complex return new Complex(0, 1);
	
	public var re:Float;
	public var im:Float;
	
	private inline function new(re:Float, im:Float):Void {
		this.re = re;
		this.im = im;
	}
	
	static public function add(c1:Complex, c2:Complex):Complex {
		return Complex.fromComponents(c1.re + c2.re, c1.im + c2.im);
	}
	
	static public function mul(c1:Complex, c2:Complex):Complex {
		return Complex.fromComponents(c1.re * c2.re - c1.im * c2.im, c1.re * c2.im + c1.im * c2.re);
	}
	
	static public function mulConst(a:Float, c:Complex):Complex {
		return Complex.fromComponents(a * c.re, a * c.im);
	}
	
	public function clone():Complex {
		return new Complex(this.re, this.im);
	}
	
	static public function fromComponents(re:Float, im:Float):Complex {
		return new Complex(re, im);
	}
	
	static public function fromPolar(radius:Float, angle:Float):Complex {
		return new Complex(radius * Math.cos(angle), radius * Math.sin(angle));
	}
	
	public function norm2():Float {
		return this.re * this.re + this.im * this.im;
	}
	
	public function toString():String {
		return '${this.re} + j*${this.im}';
	}
}