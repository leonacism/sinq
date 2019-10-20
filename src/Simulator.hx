package;
import backend.BackendKind;
import circuit.Circuit;
import io.Complex;
import operation.Operation;



/**
 * ...
 * @author leonaci
 */
class Simulator
{
	static public function run(circuit:Circuit, ?backend:BackendKind=BackendKind.Cpu):Array<Bool> {
		NdArraySession.setBackend(backend);
		
		var qubits:Array<Qubit> = circuit.qubits;
		var numQubits:Int = qubits.length;
		var digitMap:Map<Qid, Int> = [for (i in 0...numQubits) qubits[i].id => i];
		
		var initialStates:Map<Qid, Bool> = [for (i in 0...numQubits) qubits[i].id => true];
		var stateSize:Int = 1 << numQubits;
		
		var ops = Lambda.flatten([for (moment in circuit.moments) moment.operations]);
		var rawStates:NdArray = NdArray.identity(stateSize, NdArrayDataType.COMPLEX);
		
		applyUnitary(ops, rawStates, numQubits, digitMap);
		
		trace(rawStates);
		
		var measurement = measure(rawStates, initialStates, qubits, digitMap);
		return measurement;
	}
	
	static private function applyUnitary(ops:Array<Operation>, states:NdArray, numQubits:Int, digitMap:Map<Qid, Int>):Void {
		for (op in ops) {
			for (func in [resolveByDecomposition, resolveByApplication, resolveByRepresentation]) {
				var result = func(op, states, numQubits, digitMap);
				if (result == null) continue;
				states['...'] = result;
				break;
			}
		}
	}
	
	static private function resolveByApplication(op:Operation, states:NdArray, numQubits:Int, digitMap:Map<Qid, Int>):NdArray {
		var size = 1 << numQubits;
		var numTargetQubits = op.qubits.length;
		var numOtherQubits = numQubits - numTargetQubits;
		
		var targetDigitMap:Map<Qid, Int> = [for (i in 0...numTargetQubits) op.qubits[i].id => i];
		
		var indices:Array<Int> = [for (i in 0...numTargetQubits) digitMap[op.qubits[i].id]];
		for(id in digitMap.keys()) if(!targetDigitMap.exists(id)) indices.unshift(digitMap[id]);
		indices.push(indices.length);
		
		var shape = [for (i in 0...numQubits) 2];
		shape.push(size);
		
		states = states.reshape(shape);
		states = states.transpose(indices);
		
		states = states.reshape([1 << numOtherQubits, 1 << numTargetQubits, size]);
		
		for (i in 0...1 << numOtherQubits) {
			var result = op.apply(states['$i']);
			if (result == null) return null;
			states['$i'] = result;
		}
		trace(states);
		states = states.reshape(shape);
		states = states.transpose([for (i in 0...indices.length) indices.indexOf(i)]);
		states = states.reshape([size, size]);
		
		return states;
	}

	static private function resolveByRepresentation(op:Operation, states:NdArray, numQubits:Int, digitMap:Map<Qid, Int>):NdArray {
		var size = 1 << numQubits;
		var numTargetQubits = op.qubits.length;
		var numOtherQubits = numQubits - numTargetQubits;
		
		var targetDigitMap:Map<Qid, Int> = [for (i in 0...numTargetQubits) op.qubits[i].id => i];
		
		var indices:Array<Int> = [for (i in 0...numTargetQubits) digitMap[op.qubits[i].id]];
		for(id in digitMap.keys()) if(!targetDigitMap.exists(id)) indices.unshift(digitMap[id]);
		indices.push(indices.length);
		
		var shape = [for (i in 0...numQubits) 2];
		shape.push(size);
		
		states = states.reshape(shape);
		states = states.transpose(indices);
		
		states = states.reshape([1 << numOtherQubits, 1 << numTargetQubits, size]);
		
		var operation:NdArray = op.represent();
		for(i in 0...1<<numOtherQubits) states['$i'] = NdArray.dot(operation, states['$i']);
		
		states = states.reshape(shape);
		states = states.transpose([for (i in 0...indices.length) indices.indexOf(i)]);
		states = states.reshape([size, size]);
		return states;
	}
	
	static private function resolveByDecomposition(op:Operation, states:NdArray, numQubits:Int, digitMap:Map<Qid, Int>):NdArray {
		var ops = op.decompose();
		if (ops == null) return null;
		applyUnitary(ops, states, numQubits, digitMap);
		return states;
	}
	
	static private function measure(states:NdArray, initialStates:Map<Qid,Bool>, qubits:Array<Qubit>, digitMap:Map<Qid, Int>):Array<Bool> {
		var j:Int = 0;
		for (id in initialStates.keys()) if (initialStates[id]) j += 1 << digitMap[id];
		
		var dist = [for (i in 0...states.shape[0]) (states[[i, j]]:Complex).norm2()];
		//trace(dist+'');
		
		var selected:Int = choice(dist);
		var measurement:Array<Bool> = [for (i in 0...qubits.length)
			switch(Std.int(selected / (1 << digitMap[qubits[qubits.length-i-1].id])) % 2) {
				case 1: true;
				case 0: false;
				case _: throw '!?';
			}
		];
		
		return measurement;
	}
	
	static private function choice(dist:Array<Float>):Int {
		var sum = 0.0;
		for (p in dist) sum += p;
		if (sum != 1.0) for (i in 0...dist.length) dist[i] /= sum;
		
		var r = Math.random();
		for(i in 0...dist.length) if((r-=dist[i])<0) return i;
		return throw '!?';
	}
}