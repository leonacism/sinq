package;
import circuit.Circuit;
import circuit.strategy.InsertStrategyKind;
import operation.gate.CCXGate;
import operation.gate.CNotGate;
import operation.gate.CZGate;
import operation.gate.HGate;
import operation.gate.XGate;
import operation.gate.YGate;
import operation.gate.ZGate;
import util.Complex;
import util.NdArray;

/**
 * ...
 * @author leonaci
 */
class Main 
{
	static function main() 
	{
		// prepare a qubit.
		var q0 = new Qubit();
		var q1 = new Qubit();
		var q2 = new Qubit();
		
		// initialize a circuit.
		var circuit = new Circuit([q0, q1, q2]);
		
		// setup operations.
		circuit.append([
			new CCXGate().on([q0,q1,q2])
		]);
		
		// run the simulation.
		var result:Array<Bool> = Simulator.run(circuit);
		
		print(result);
	}
	
	static function print(result:Array<Bool>):Void {
		var str:String = '';
		for (i in 0...result.length) str += result[i]? '↑' : '↓';
		trace(str);
	}
}