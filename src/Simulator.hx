package;
import circuit.Circuit;
import operation.Operation;
import util.Complex;
import util.NdArray;

/**
 * ...
 * @author leonaci
 */
class Simulator
{
	static public function run(circuit:Circuit):Array<Bool> {
		var qubits:Array<Qubit> = circuit.qubits;
		var numQubits:Int = qubits.length;
		var stateSize:Int = pow2(numQubits);
		
		var initialStates:Map<Qid, Bool> = [for (i in 0...numQubits) qubits[i].id => true];
		var digitMap:Map<Qid, Int> = [for (i in 0...numQubits) qubits[i].id => numQubits-i-1];
		
		var rawStates:NdArray = NdArray.identity(stateSize);
		for (moment in circuit.moments) for(op in moment.operations) {
			rawStates = resolveByRepresentation(op, rawStates, digitMap);
		}
		var measurement = measure(rawStates, initialStates, qubits, digitMap);
		return measurement;
	}
	
	// O(2^{3*n})
	static private function resolveByRepresentation(op:Operation, states:NdArray, digitMap:Map<Qid, Int>):NdArray {
		var size = states.size;
		var numQubits = log2(size);
		var numTargetQubits = op.qubits.length;
		var numNontargetQubits = numQubits - numTargetQubits;
		
		var targetDigitMap:Map<Qid, Int> = [for (i in 0...numTargetQubits) op.qubits[i].id => numTargetQubits-i-1];
		var i=numNontargetQubits;
		var nontargetDigitMap:Map<Qid, Int> = [for (id in digitMap.keys()) if (!targetDigitMap.exists(id)) id => --i];
		
		var output:NdArray = NdArray.identity(size);
		
		var operation:NdArray = op.represent();
		for (k in 0...pow2(numNontargetQubits)) for (m in 0...pow2(numTargetQubits)) for (j in 0...size) {
			var i:Int = compose(k, m, digitMap, targetDigitMap, nontargetDigitMap);
			
			var sum = Complex.zero;
			for (n in 0...pow2(numTargetQubits)) {
				var l:Int = compose(k, n, digitMap, targetDigitMap, nontargetDigitMap);
				sum += operation[m][n] * states[l][j];
			}
			
			output[i][j] = sum;
		}
		
		return output;
	}
	
	static private inline function compose(k:Int, m:Int, digitMap:Map<Qid, Int>, targetDigitMap:Map<Qid, Int>, nontargetDigitMap:Map<Qid, Int>):Int {
		var i = 0;
		for (id in digitMap.keys()) {
			var d = Std.int(targetDigitMap.exists(id)? m / pow2(targetDigitMap[id]) : k / pow2(nontargetDigitMap[id]));
			if (d % 2 == 1) i += pow2(digitMap[id]);
		}
		return i;
	}
	
	static private function measure(states:NdArray, initialStates:Map<Qid,Bool>, qubits:Array<Qubit>, digitMap:Map<Qid, Int>):Array<Bool> {
		var j:Int = 0;
		for (id in initialStates.keys()) if (initialStates[id]) j += pow2(digitMap[id]);
		
		var dist = [for (l in 0...states.size) l => states[l][j].norm2()];
		//trace(dist+'');
		
		var result:Int = choice(dist);
		var measurement:Array<Bool> = [for (i in 0...qubits.length)
			switch(Std.int(result / pow2(digitMap[qubits[i].id])) % 2) {
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
	
	static private inline function pow2(n:Int):Int return Std.int(Math.pow(2, n));
	static private inline function log2(n:Int):Int return Std.int(Math.log(n) / Math.log(2));
}