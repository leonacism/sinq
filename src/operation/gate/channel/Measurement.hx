package operation.gate.channel;
import numhx.NdArray;
import operation.gate.feature.Channel;

/**
 * ...
 * @author leonaci
 */
abstract MeasurementKey(String) from String {
}
 
class Measurement implements Channel
{
	public var key(default, null):MeasurementKey;
	
	public var numQubits(get, null):Int;
	inline function get_numQubits():Int return numQubits;

	public function new(key:String)
	{
		this.key = key;
	}

	public function applyChannel(i:Int, target:NdArray):NdArray {
		var size = 1 << numQubits;

		for (j in 0...size) if(i != j) target['$j'] = 0;

		return target;
	}
	
	public function channel():Array<NdArray> {
		var size = 1 << numQubits;
		
		var result = [];
		
		for (i in 0...size) {
			var delta = NdArray.zeros(size * size).reshape([size, size]);
			
			delta['$i,$i'] = 1;
			
			result.push(delta);
		}
		
		return result;
	}
	
	public function on(qubits:Array<Qubit>):Operation {
		numQubits = qubits.length;
		return new MeasurementOperation(this, qubits);
	}
}