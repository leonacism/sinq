package util;

/**
 * ...
 * @author leonaci
 */
abstract NdArray(Array<Array<Complex>>) from Array<Array<Complex>> to Array<Array<Complex>> {
	public var size(get, never):Int;
	inline function get_size():Int return this.length;
	
	static public function identity(size:Int):NdArray {
		var data:NdArray = [for (i in 0...size) [for (j in 0...size) i==j? Complex.one : Complex.zero]];
		return data;
	}
	
	public function clone():NdArray {
		var data:NdArray = [for (i in 0...size) [for (j in 0...size) this[i][j].clone()]];
		return data;
	}
}