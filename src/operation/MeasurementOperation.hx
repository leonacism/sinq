package operation;

import numhx.NdArray;
import operation.gate.Gate;
import operation.gate.channel.Measurement;
import operation.gate.feature.UnitaryGate;

/**
 * ...
 * @author leonaci
 */
class MeasurementOperation implements Operation
{
	private var meas:Measurement;

	public var qubits(default, null):Array<Qubit>;
	public var operationKind(get, null):OperationKind;
	inline function get_operationKind():OperationKind return OperationKind.Measurement;
	
	public var measurementKey(get, never):MeasurementKey;
	inline function get_measurementKey():MeasurementKey return meas.key;

	public function new(meas:Measurement, qubits:Array<Qubit>) 
	{
		this.meas = meas;
		this.qubits = qubits;
	}

	public function applyChannel(i:Int, target:NdArray):NdArray {
		return meas.applyChannel(i, target);
	}
	
	public function channel(i:Int):NdArray {
		return meas.channel()[i];
	}
	
	public function keys():Iterator<Qid> {
		return [for (q in qubits) q.id].iterator();
	}
}