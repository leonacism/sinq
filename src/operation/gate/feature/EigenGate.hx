package operation.gate.feature;

/**
 * @author leonaci
 */
interface EigenGate extends UnitaryGate {
	var exponent(default, null):Float;
	//var eigenComponents(get, null):Array<EigenComponent>;
	
	function pow(exponent:Float):UnitaryGate;
}