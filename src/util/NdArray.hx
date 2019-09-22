package util;

/**
 * ...
 * @author leonaci
 */
abstract NdArray(Array<Array<Complex>>) {
	public var size(get, never):Int;
	inline function get_size():Int return this.length;
	
	static public function identity(size:Int):NdArray {
		var data:NdArray = NdArray.array([for (i in 0...size) [for (j in 0...size) i==j? Complex.one : Complex.zero]]);
		return data;
	}
	
	@:arrayAccess
	public inline function get(k:Int):Array<Complex> {
		return this[k];
	}
	
	@:arrayAccess
	public inline function set(k:Int, v:Array<Complex>):Array<Complex> {
		this[k] = v;
		return v;
	}
	
	static public function array(value:Array<Array<Complex>>):NdArray {
		return cast value;
	}
	
	static public function diag(values:Array<Complex>):NdArray {
		var size = values.length;
		var zero = Complex.zero;
		var data:NdArray = NdArray.array([for (i in 0...size) [for (j in 0...size) i==j? values[i] : zero]]);
		return data;
	}
	
	static public function blockDiag(values:Array<NdArray>):NdArray {
		var size = 0;
		for (block in values) size += block.size;
		var zero = Complex.zero;
		var stride = 0;
		
		var data:NdArray = NdArray.array([for (block in values) {
			stride += block.size;
			for (i in 0...block.size) [for (j in 0...size) (stride - block.size <= j && j < stride)? block[i][j - stride + block.size] : zero];
		}]);
		return data;
	}
	
	public function clone():NdArray {
		var data:NdArray = NdArray.array([for (i in 0...size) [for (j in 0...size) this[i][j].clone()]]);
		return data;
	}
	
	public function toString():String {
		var str = '[' + this.map(a -> '[' + a.map(b->b.toString()).join(', ') + ']').join(',\n') + ']';
		return str;
	}
}