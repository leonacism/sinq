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
	static public function run(circuit:Circuit):Array<Bool> {
		Session.setBackend(BackendKind.Cpu);
		
		var qubits:Array<Qubit> = circuit.qubits;
		var numQubits:Int = qubits.length;
		var stateSize:Int = 1 << numQubits;
		
		var initialStates:Map<Qid, Bool> = [for (i in 0...numQubits) qubits[i].id => true];
		var digitMap:Map<Qid, Int> = [for (i in 0...numQubits) qubits[i].id => numQubits-i-1];
		
		var rawStates:NdArray = NdArray.identity(stateSize, NdArrayDataType.COMPLEX);
		for (moment in circuit.moments) for(op in moment.operations) {
			rawStates = resolveByRepresentation(op, rawStates, numQubits, digitMap);
		}
		var measurement = measure(rawStates, initialStates, qubits, digitMap);
		return measurement;
	}
	
	// O(2^{3*n})
	static private function resolveByRepresentation(op:Operation, states:NdArray, numQubits:Int, digitMap:Map<Qid, Int>):NdArray {
		var size = 1 << numQubits;
		var numTargetQubits = op.qubits.length;
		var numNontargetQubits = numQubits - numTargetQubits;
		
		var targetDigitMap:Map<Qid, Int> = [for (i in 0...numTargetQubits) op.qubits[i].id => numTargetQubits-i-1];
		var i=numNontargetQubits;
		var nontargetDigitMap:Map<Qid, Int> = [for (id in digitMap.keys()) if (!targetDigitMap.exists(id)) id => --i];
		
		var output:NdArray = NdArray.identity(size, NdArrayDataType.COMPLEX);
		
		var operation:NdArray = op.represent();
		for(i in 0...size) {
			var b = 0, m = 0;
			var t = i;
			for (id in digitMap.keys()) {
				var r = 1 << digitMap[id];
				var d = Std.int(t / r);
				if(d % 2 == 1) targetDigitMap.exists(id)? m += 1 << targetDigitMap[id] : b += 1 << nontargetDigitMap[id];
				t %= r;
			}
			
			var s = 0;
			for (id in targetDigitMap.keys()) if (targetDigitMap[id] == 0) {
				s = 1 << digitMap[id];
				break;
			}
			
			var e = b + (1 << numTargetQubits) * s;
			
			output['$i'] = NdArray.dot(operation, states['$b:$e:$s'])['$m'];
		}
		return output;
	}
	
	static private function measure(states:NdArray, initialStates:Map<Qid,Bool>, qubits:Array<Qubit>, digitMap:Map<Qid, Int>):Array<Bool> {
		var j:Int = 0;
		for (id in initialStates.keys()) if (initialStates[id]) j += 1 << digitMap[id];
		
		var dist = [for (l in 0...states.shape[0]) l => {
			var value:Complex = states[[l, j]];
			value.norm2();
		}];
		//trace(dist+'');
		
		var result:Int = choice(dist);
		var measurement:Array<Bool> = [for (i in 0...qubits.length)
			switch(Std.int(result / (1 << digitMap[qubits[i].id])) % 2) {
				case 1: true;
				case 0: false;
				case _: throw '!?';
			}
		];
		
		return measurement;
	}
	
	static private function choice(dist:Map<Int, Float>):Int {
		var sum = 0.0;
		for (p in dist) sum += p;
		if (sum != 1.0) for (i in dist.keys()) dist[i] /= sum;
		
		var r = Math.random();
		for(i in dist.keys()) if((r-=dist[i])<0) return i;
		return throw '!?';
	}
}