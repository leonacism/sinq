package simulation;
import operation.gate.channel.Measurement.MeasurementKey;

/**
 * @author leonaci
 */
typedef MeasurementData = {
	name:MeasurementKey,
	qubits:Array<Qubit>,
	data:Int,
	?intermediates:Array<Wave>,
}