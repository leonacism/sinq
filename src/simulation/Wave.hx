package simulation;
import numhx.util.MathUtil;
import numhx.NdArrayDataType;
import operation.Operation;
import operation.gate.channel.Measurement;
import numhx.NdArray;

/**
 * ...
 * @author leonaci
 */
class Wave
{
	public var rawState(default, null):NdArray;
	
	public function new(rawState:NdArray) 
	{
		this.rawState = rawState;
	}
	
	public function execUnitaryOp(op:Operation, indices:Array<Int>, numQubits:Int):Void {
		var funcs = switch(op.qubits.length) {
			case n if (n <= 4):
			{
				[resolveByApplication, resolveByDecomposition, resolveByRepresentation];
			}
			case _:
			{
				[resolveByDecomposition, resolveByApplication, resolveByRepresentation];
			}
		}
		
		for (func in funcs) {
			var success = func(this, op, indices, numQubits);
			if (success) break;
		}
	}
	
	static private function resolveByApplication(wave:Wave, op:Operation, indices:Array<Int>, numQubits:Int):Bool {
		var size = 1 << numQubits;
		var numTargetQubits = op.qubits.length;
		var numOtherQubits = numQubits - numTargetQubits;
		
		var transposeIndices = [for(i in 0...numQubits) if(indices.indexOf(i) == -1) i].concat(indices);
		
		var states:NdArray = wave.rawState;
		
		states = states.reshape([for (i in 0...numQubits) 2]);
		states = states.transpose(transposeIndices);
		states = states.reshape([1 << numOtherQubits, 1 << numTargetQubits]);
		
		for (i in 0...1 << numOtherQubits) {
			var result = op.apply(states['$i']);
			if (result == null) return false;
			states['$i'] = result;
		}
		
		states = states.reshape([for (i in 0...numQubits) 2]);
		states = states.transpose([for (i in 0...transposeIndices.length) transposeIndices.indexOf(i)]);
		states = states.reshape([size]);
		
		wave.rawState['...'] = states;
		
		return true;
	}

	static private function resolveByRepresentation(wave:Wave, op:Operation, indices:Array<Int>, numQubits:Int):Bool {
		var size = 1 << numQubits;
		var numTargetQubits = op.qubits.length;
		var numOtherQubits = numQubits - numTargetQubits;
		
		var transposeIndices = [for(i in 0...numQubits) if(indices.indexOf(i) == -1) i].concat(indices);
		
		var states:NdArray = wave.rawState;
		
		states = states.reshape([for (i in 0...numQubits) 2]);
		states = states.transpose(transposeIndices);
		states = states.reshape([1 << numOtherQubits, 1 << numTargetQubits]);
		
		var operation:NdArray = op.represent();
		if (operation == null) return false;
		for (i in 0...1 << numOtherQubits) {
			var result = NdArray.dot(operation, states['$i']);
			states['$i'] = result;
		}
		
		states = states.reshape([for (i in 0...numQubits) 2]);
		states = states.transpose([for (i in 0...transposeIndices.length) transposeIndices.indexOf(i)]);
		states = states.reshape([size]);
		
		wave.rawState['...'] = states;
		
		return true;
	}
	
	static private function resolveByDecomposition(wave:Wave, op:Operation, indices:Array<Int>, numQubits:Int):Bool {
		var ops = op.decompose();
		if (ops == null) return false;
		
		var digitMap = [for (i in 0...op.qubits.length) op.qubits[i].id => indices[i]];
		
		for (op in ops) {
			var indices:Array<Int> = [for (q in op.qubits) digitMap[q.id]];
			wave.execUnitaryOp(op, indices, numQubits);
		}
		
		return true;
	}
	
	public function execMeasurement(op:Operation, indices:Array<Int>, measurements:Array<MeasurementData>, numQubits:Int, measured:Bool):Void {
		var probs = getProbs();
		var selected:Int = Random.choice(probs);
		
		var gate:Measurement = (cast op).gate;
		
		var name = gate.measurementKey;
		
		var bit = 0;
		for (i in 0...indices.length) {
			if(Std.int(selected / (1<<numQubits-indices[i]-1)) % 2 == 1) bit += 1<<indices.length-i-1;
		}
		
		measurements.push({
			name: name,
			qubits: op.qubits,
			data: bit,
		});
		
		if (!measured) return;
		
		///
		
		var size = 1 << numQubits;
		var numTargetQubits = op.qubits.length;
		var numOtherQubits = numQubits - numTargetQubits;
		
		var transposeIndices = [for(i in 0...numQubits) if(indices.indexOf(i) == -1) i].concat(indices);
		
		var states:NdArray = rawState.copy();
		
		states = states.reshape([for (i in 0...numQubits) 2]);
		states = states.transpose(transposeIndices);
		states = states.reshape([1 << numOtherQubits, 1 << numTargetQubits]);
		
		var proj:NdArray = op.channel()[bit];
		for (i in 0...1 << numOtherQubits) {
			var result = NdArray.dot(proj, states['$i']);
			states['$i'] = result;
		}
		
		states = states.reshape([for (i in 0...numQubits) 2]);
		states = states.transpose([for (i in 0...transposeIndices.length) transposeIndices.indexOf(i)]);
		states = states.reshape([size]);
		
		var sum = 0.0;
		for (i in 0...1 << numQubits) {
			var a = states[[i]];
			sum += a * a;
		}
		sum = Math.sqrt(sum);
		
		states /= sum;
		
		rawState['...'] = states;
	}
	
	public function getProbs():Array<Float> {
		var probs = [for (i in 0...rawState.shape[0]) {
			var a:Float = MathUtil.abs(rawState[[i]]);
			a * a;
		}];
		
		var sum = 0.0;
		for (p in probs) sum += p;
		if (sum != 1.0) for (i in 0...probs.length) probs[i] /= sum;
		
		return probs;
	}
	
	static public function toWaveFunction(initialState:Int, digitMap:Map<Qid, Int>, numQubits:Int):Wave {
		var stateSize:Int = 1 << numQubits;
		
		var rawState:NdArray = NdArray.zeros(stateSize, NdArrayDataType.COMPLEX);
		rawState['$initialState'] = 1;
		
		return new Wave(rawState);
	}
}