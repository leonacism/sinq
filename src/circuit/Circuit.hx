package circuit;
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
	
	private var strategyKind:InsertStrategyKind;
	
	public function new() {
		moments = [];
		strategyKind = InsertStrategyKind.NewThenInline;
	}
	
	public function append(operations:Array<Operation>, ?strategyKind:InsertStrategyKind):Circuit {
		switch(strategyKind!=null? strategyKind : this.strategyKind) {
			case InsertStrategyKind.Earliest: InsertStrategyEarliest.insert(moments, operations);
			case InsertStrategyKind.New: InsertStrategyNew.insert(moments, operations);
			case InsertStrategyKind.Inline: InsertStrategyInline.insert(moments, operations);
			case InsertStrategyKind.NewThenInline: InsertStrategyNewThenInline.insert(moments, operations);
		}
		trace(moments.length);
		return this;
	}
	
	static public function fromOperations(operations:Array<Operation>, ?strategyKind:InsertStrategyKind):Circuit {
		var circuit = new Circuit();
		circuit.append(operations, strategyKind);
		return circuit;
	}
	
	public function getQubits():Array<Qubit> {
		var result:Array<Qubit> = [];
		
		for (moment in moments) for (q in moment.qubits) if (result.indexOf(q) == -1) result.push(q);
		
		return result;
	}
}