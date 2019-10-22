package circuit;
import circuit.strategy.InsertStrategy;
import circuit.strategy.InsertStrategyEarliest;
import circuit.strategy.InsertStrategyInline;
import circuit.strategy.InsertStrategyKind;
import circuit.strategy.InsertStrategyNew;
import circuit.strategy.InsertStrategyNewThenInline;
import operation.Moment;
import operation.Operation;

/**
 * ...
 * @author leonaci
 */
class Circuit
{
	public var moments(default, null):Array<Moment>;
	public var qubits(default, null):Array<Qubit>;
	
	private var strategyKind:InsertStrategyKind;
	
	public function new(qubits:Array<Qubit>) {
		moments = [];
		this.qubits = qubits;
		strategyKind = InsertStrategyKind.NewThenInline;
	}
	
	public function append(operations:Array<Operation>, ?strategyKind:InsertStrategyKind):Circuit {
		var strategy:InsertStrategy = switch(strategyKind!=null? strategyKind : this.strategyKind) {
			case InsertStrategyKind.Earliest: new InsertStrategyEarliest();
			case InsertStrategyKind.New: new InsertStrategyNew();
			case InsertStrategyKind.Inline: new InsertStrategyInline();
			case InsertStrategyKind.NewThenInline: new InsertStrategyNewThenInline();
		}
		
		strategy.insert(moments, operations);
		
		return this;
	}
	
	static public function fromOperations(qubits:Array<Qubit>, operations:Array<Operation>, ?strategyKind:InsertStrategyKind):Circuit {
		var circuit = new Circuit(qubits);
		circuit.append(operations, strategyKind);
		return circuit;
	}
}