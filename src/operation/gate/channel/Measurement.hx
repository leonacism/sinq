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
	public var measurementKey(default, null):MeasurementKey;
	
	public var numQubits(get, null):Int;
	private function get_numQubits():Int return numQubits;

	public function new(key:String)
	{
		this.measurementKey = key;
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
	
	public function on(qubits:Array<Qubit>):GateOperation {
		numQubits = qubits.length;
		return new GateOperation(this, qubits);
	}
}