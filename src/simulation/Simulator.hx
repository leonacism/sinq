package simulation;
import numhx.Random;
import circuit.Circuit;
import haxe.ds.Map;
import numhx.NdArray;
import numhx.NdArrayDataType;
import numhx.NdArraySession;
import numhx.backend.BackendKind;
import numhx.util.MathUtil;
import operation.Operation;
import operation.OperationKind;
import operation.gate.channel.Measurement;
import simulation.SimulationResultCollection;



/**
 * ...
 * @author leonaci
 */
class Simulator
{
	static public function run(circuit:Circuit, ?repetition:Int = 1, ?backend:BackendKind = BackendKind.Cpu):SimulationResultCollection {
		NdArraySession.setBackend(backend);
		
		var s:UInt = Random.randint(-2147483648, 2147483647);

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
							for (i in 0...repetition) lastWave.execMeasurement(op, indices, data, numQubits, false, s+i);
						}
					case _:
				}
			}
		}
		else {
			for (i in 0...repetition) {
				var result:StepResult = step(circuit, 0, true, s+i);
				collection.append(result.data);
			}
		}
		
		return collection;
	}
	
	static public function simulate(circuit:Circuit, ?repetition:Int=1, ?backend:BackendKind=BackendKind.Cpu, ?s:UInt=0):SimulationResultCollection {
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
							lastWave.execMeasurement(op, indices, data, numQubits, false, s+i);
							
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
				var results:Array<StepResult> = stepByMoment(circuit, 0, true, s+i);
				
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
	
	static public function step(circuit:Circuit, initialState:Int, performMeasurement:Bool, ?s:UInt):StepResult {
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
					if(performMeasurement) wave.execMeasurement(op, indices, data, numQubits, true, s);
				}
			}
		}
		
		return new StepResult(wave, data);
	}
	
	static public function stepByMoment(circuit:Circuit, initialState:Int, performMeasurement:Bool, ?s:UInt):Array<StepResult> {
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
					if(performMeasurement) wave.execMeasurement(op, indices, data, numQubits, true, s);
				}
			}
			
			var intermediateWave = new Wave(wave.rawState.copy());
			stepResults.push(new StepResult(intermediateWave, data));
		}
		
		return stepResults;
	}
}