package;
import circuit.Circuit;
import operation.HOperation;
import operation.XOperation;

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
		var circuit = new Circuit();
		
		// setup operations.
		circuit.append([
			new HOperation([q0]),
			new HOperation([q1]),
			new HOperation([q2]),
		]);
		
		// run the simulation.
		var result:Array<Bool> = Simulator.run(circuit);
		
		print(result);
	}
	
	static function print(result:Array<Bool>):Void {
		var str:String = '';
		for (r in result) str += r? '↑' : '↓';
		trace(str);
	}
}