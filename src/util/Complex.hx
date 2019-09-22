package util;

/**
 * ...
 * @author leonaci
 */
private typedef ComplexComponent = {
	public var re:Float;
	public var im:Float;
}

@:forward(re, im)
abstract Complex(ComplexComponent) {
	static public var zero(get, never):Complex;
	static function get_zero():Complex return Complex.from(0);
	
	static public var one(get, null):Complex;
	static function get_one():Complex return Complex.from(1);
	
	static public var j(get, null):Complex;
	static function get_j():Complex return Complex.fromComponents(0, 1);
	
	private inline function new(re:Float, im:Float):Void {
		this = {
			re : re,
			im : im,
		}
	}
	
	@:op(A+B)
	static public function add(c1:Complex, c2:Complex):Complex {
		return Complex.fromComponents(c1.re + c2.re, c1.im + c2.im);
	}
	
	@:op(A-B)
	static public function sub(c1:Complex, c2:Complex):Complex {
		return Complex.fromComponents(c1.re - c2.re, c1.im - c2.im);
	}
	
	@:op(A*B)
	static public function mul(c1:Complex, c2:Complex):Complex {
		return Complex.fromComponents(c1.re * c2.re - c1.im * c2.im, c1.re * c2.im + c1.im * c2.re);
	}
	
	@:op(A*B)
	static public function mulConst(a:Float, c:Complex):Complex {
		return Complex.fromComponents(a * c.re, a * c.im);
	}
	
	@:op(A^B)
	static public function pow(c:Complex, a:Float):Complex {
		return Complex.fromPolar(Math.pow(c.re * c.re + c.im * c.im, 0.5 * a), Math.atan2(c.im, c.re) * a);
	}
	
	@:op(-A)
	static public function neg(c:Complex):Complex {
		return Complex.fromComponents(-c.re, -c.im);
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
	
	@:from static public function from(a:Float):Complex {
		return new Complex(a, 0);
	}
	
	public function norm2():Float {
		return this.re * this.re + this.im * this.im;
	}
	
	public function toString():String {
		return switch[this.re, this.im] {
			case [a, b] if(Math.abs(a) < 1e-10 && Math.abs(b) < 1e-10): '0';
			case [a, _] if(Math.abs(a) < 1e-10): 'j*${this.im}';
			case [_, b] if(Math.abs(b) < 1e-10): '${this.re}';
			case [_, _]: '${this.re} + j*${this.im}';
		}
	}
}