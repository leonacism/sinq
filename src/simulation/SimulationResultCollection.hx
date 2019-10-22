package simulation;
import haxe.ds.Map;
import operation.gate.channel.Measurement.MeasurementKey;

/**
 * ...
 * @author leonaci
 */

class SimulationResultCollection
{
	public var measurements(default, null):Array<MeasurementData>;
	public var numQubits(default, null):Int;

	public function new(?measurements:Array<MeasurementData>, numQubits:Int) {
		this.measurements = measurements;
		this.numQubits = numQubits;
	}
	
	public function append(measurements:Array<MeasurementData>):Void {
		for(m in measurements) this.measurements.push(m);
	}

	public inline function filter(key:MeasurementKey):Array<MeasurementData> {
		return measurements.filter(measurement -> key == measurement.name);
	}

	public function keys():Iterator<MeasurementKey> {
		var keyArray = [];
		for(m in measurements) if(keyArray.indexOf(m.name) == -1) keyArray.push(m.name);
		return keyArray.iterator();
	}
	
	static public inline function fromBinary(binary:Int, numQubits:Int):Array<Bool> {
		if(binary >= 1<<numQubits) throw 'error: the binary code exceeds qubit size.';
		return [for (d in 0...numQubits) Std.int(binary / (1 << numQubits - d - 1)) % 2 == 1];
	}
}