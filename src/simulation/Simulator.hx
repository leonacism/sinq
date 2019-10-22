package simulation;
import backend.BackendKind;
import circuit.Circuit;
import haxe.ds.Map;
import io.Complex;
import operation.GateOperation;
import operation.Operation;
import operation.OperationKind;
import operation.gate.channel.Measurement;
import operation.gate.channel.Measurement.MeasurementKey;
import simulation.SimulationResultCollection;
import util.MathUtil;



/**
 * ...
 * @author leonaci
 */
class Simulator
{
	static public function run(circuit:Circuit, ?repetition:Int = 1, ?backend:BackendKind = BackendKind.Cpu):SimulationResultCollection {
		NdArraySession.setBackend(backend);
		
		var numQubits:Int = circuit.qubits.length;
		var qubits:Array<Qubit> = circuit.qubits;
		var digitMap:Map<Qid, Int> = [for (i in 0...numQubits) qubits[i].id => i];
		
		var data:Array<MeasurementData> = [];
		var collection:SimulationResultCollection = new SimulationResultCollection(data, numQubits);

		if (checkTerminal(circuit)) {
			var result = step(circuit, 0, false);

			for (op in circuit.moments[circuit.moments.length - 1].operations) {
				var indices:Array<Int> = [for (q in op.qubits) digitMap[q.id]];
				switch (op.operationKind) {
					case OperationKind.Measurement:
						{
							var lastWave = result.wave;
							for (i in 0...repetition) lastWave.execMeasurement(op, indices, data, numQubits, false);
						}
					case _:
				}
			}
		}
		else {
			for (i in 0...repetition) {
				var result:StepResult = step(circuit, 0, true);
				collection.append(result.data);
			}
		}
		
		return collection;
	}
	
	static public function simulate(circuit:Circuit, ?repetition:Int=1, ?backend:BackendKind=BackendKind.Cpu):SimulationResultCollection {
		NdArraySession.setBackend(backend);
		
		var numQubits:Int = circuit.qubits.length;
		var qubits:Array<Qubit> = circuit.qubits;
		var digitMap:Map<Qid, Int> = [for (i in 0...numQubits) qubits[i].id => i];
		
		var data:Array<MeasurementData> = [];
		var collection:SimulationResultCollection = new SimulationResultCollection(data, numQubits);
		
		if (checkTerminal(circuit)) {
			var results = stepByMoment(circuit, 0, false);
			
			var intermediateWaves:Array<Wave> = [];
			for (result in results) intermediateWaves.push(result.wave);
			
			for (op in circuit.moments[circuit.moments.length - 1].operations) {
				var indices:Array<Int> = [for (q in op.qubits) digitMap[q.id]];
				switch(op.operationKind) {
					case OperationKind.Measurement:
					{
						var lastWave = intermediateWaves[intermediateWaves.length-1];
						for(i in 0...repetition) {
							lastWave.execMeasurement(op, indices, data, numQubits, false);
							
							var lastData = data[data.length - 1];
							lastData.intermediates = intermediateWaves;
						}
					}
					case _:
				}
			}
		}
		else {
			for (i in 0...repetition) {
				var results:Array<StepResult> = stepByMoment(circuit, 0, true);
				
				var intermediateWaves:Array<Wave> = [];
				for (result in results) {
					intermediateWaves.push(result.wave);
					
					for(m in result.data) m.intermediates = intermediateWaves.copy();
					collection.append(result.data);
				}
			}
		}
		
		return collection;
	}
	
	static private function checkTerminal(circuit:Circuit):Bool {
		for (i in 0...circuit.moments.length - 1) {
			var operations = circuit.moments[i].operations;
			for (op in operations) switch(op.operationKind) {
				case OperationKind.Measurement:
				{
					return false;
				}
				case _:
			}
		}
		
		return true;
	}
	
	static public function step(circuit:Circuit, initialState:Int, performMeasurement:Bool):StepResult {
		var numQubits:Int = circuit.qubits.length;
		var qubits:Array<Qubit> = circuit.qubits;
		var digitMap:Map<Qid, Int> = [for (i in 0...numQubits) qubits[i].id => i];
		
		var ops = Lambda.flatten([for (moment in circuit.moments) moment.operations]);
		
		var wave = Wave.toWaveFunction(initialState, digitMap, numQubits);
		var data:Array<MeasurementData> = [];
		
		for (op in ops) {
			var indices:Array<Int> = [for (q in op.qubits) digitMap[q.id]];
			switch(op.operationKind) {
				case OperationKind.Unitary:
				{
					wave.execUnitaryOp(op, indices, numQubits);
				}
				case OperationKind.Measurement:
				{
					if(performMeasurement) wave.execMeasurement(op, indices, data, numQubits, true);
				}
			}
		}
		
		return new StepResult(wave, data);
	}
	
	static public function stepByMoment(circuit:Circuit, initialState:Int, performMeasurement:Bool):Array<StepResult> {
		var stepResults = [];
		
		var numQubits:Int = circuit.qubits.length;
		var qubits:Array<Qubit> = circuit.qubits;
		var digitMap:Map<Qid, Int> = [for (i in 0...numQubits) qubits[i].id => i];
		
		var ops = Lambda.flatten([for (moment in circuit.moments) moment.operations]);
		
		var wave = Wave.toWaveFunction(initialState, digitMap, numQubits);
		
		for (op in ops) {
			var data:Array<MeasurementData> = [];
			
			var indices:Array<Int> = [for (q in op.qubits) digitMap[q.id]];
			switch(op.operationKind) {
				case OperationKind.Unitary:
				{
					wave.execUnitaryOp(op, indices, numQubits);
				}
				case OperationKind.Measurement:
				{
					if(performMeasurement) wave.execMeasurement(op, indices, data, numQubits, true);
				}
			}
			
			var intermediateWave = new Wave(wave.rawState.copy());
			stepResults.push(new StepResult(intermediateWave, data));
		}
		
		return stepResults;
	}
}