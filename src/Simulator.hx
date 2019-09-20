package;
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
		var initialStates:Array<Bool> = [for (i in 0...circuit.numQubits) true];
		//var rawState:Array<Complex> = getRawState(initialStates);
		var indexMap:Map<Int, Int> = [for (i in 0...circuit.numQubits) circuit.qubits[i].id => i];
		var stateSize:Int = Std.int(Math.pow(2, initialStates.length));
		var rawStates:NdArray = NdArray.identity(stateSize);
		for (op in circuit.operations) {
			rawStates = resolveByRepresentation(op, rawStates, indexMap);
		}
		var measurement = measure(rawStates, initialStates);
		return measurement;
	}
	
	/*
	static private function getRawState(initialStates:Array<Bool>):Array<Complex> {
		var data:Array<Complex> = [for (i in 0...Std.int(Math.pow(2, initialStates.length))) Complex.zero];
		
		var index:Int = 0;
		for (i in 0...initialStates.length) if (initialStates[i]) index += Std.int(Math.pow(2, i));
		data[index] = Complex.one;
		
		return data;
	}
	*/
	
	// O(2^{3*n})
	static private function resolveByRepresentation(op:Operation, states:NdArray, indexMap:Map<Int, Int>):NdArray {
		var size = states.size;
		var indices:Array<Int> = getIndices(op, indexMap);
		var output:NdArray = NdArray.identity(size);
		
		var operation:NdArray = op.represent();
		
		for (k in 0...pow2(log2(size) - indices.length)) for (m in 0...pow2(indices.length)) for (j in 0...size) {
			var i:Int = compose(k, m, indices, log2(size));
		
			var sum = Complex.zero;
			for (n in 0...pow2(indices.length)) {
				var l:Int = compose(k, n, indices, log2(size));
				sum = Complex.add(sum, Complex.mul(operation[m][n], states[l][j]));
			}
			
			output[i][j] = sum;
		}
		
		return output;
	}
	
	static private inline function compose(k:Int, m:Int, indices:Array<Int>, length:Int):Int {
		var i = 0, a = 0, b = 0;
		for (c in 0...length) {
			var d = Std.int(indices.indexOf(c)==-1? k/pow2(a++) : m/pow2(b++));
			if (d % 2 == 1) i += pow2(c);
		}
		return i;
	}
	
	static private inline function pow2(n:Int):Int return Std.int(Math.pow(2, n));
	static private inline function log2(n:Int):Int return Std.int(Math.log(n) / Math.log(2));
	
	static private function getIndices(op:Operation, indexMap:Map<Int, Int>):Array<Int> {
		return [for (qubit in op.qubits) indexMap[qubit.id]];
	}
	
	static private function measure(states:NdArray, initialStates:Array<Bool>):Array<Bool> {
		var j:Int = 0;
		for (i in 0...initialStates.length) if (initialStates[i]) j += Std.int(Math.pow(2, i));
		var dist = [for (i in 0...states.size) states[i][j].norm2()];
		//trace(dist+'');
		var result = choice(dist);
		var measurement:Array<Bool> = [for (i in 0...initialStates.length) {
			switch(Math.floor(result / Math.pow(2, i)) % 2) {
				case 1: true;
				case 0: false;
				case _: throw '!?';
			}
		}];
		
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