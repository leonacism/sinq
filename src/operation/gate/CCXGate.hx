package operation.gate;
import io.Complex;
import operation.gate.HGate;
import operation.gate.feature.EigenGate;
import operation.gate.feature.ThreeQubitGate;
import operation.gate.feature.UnitaryGate;


/**
 * ...
 * @author leonaci
 */
class CCXGate implements EigenGate extends ThreeQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new CCXGate(this.exponent * exponent);
		return gate;
	}
	
	public function apply(target:NdArray):NdArray {
		return switch(exponent) {
			case 1:
			{
				var zooSlice:Slice = '6';
				var oooSlice:Slice = '7';
				
				var ooo = target[oooSlice].copy();
				target[oooSlice] = target[zooSlice];
				target[zooSlice] = ooo;
				
				target;
			}
			case 0:
			{
				target;
			}
			case _:
			{
				null;
			}
		}
	}
	
	public function represent():NdArray {
		var j = Complex.j;
		var a = Complex.j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		return NdArray.blockDiag([
			NdArray.diag([1, 1, 1, 1], NdArrayDataType.COMPLEX),
			NdArray.array([
				[ 1, 0,          0,          0],
				[ 0, 1,          0,          0],
				[ 0, 0,      a * c, -j * a * s],
				[ 0, 0, -j * a * s,      a * c],
			]),
		], NdArrayDataType.COMPLEX);
	}
	
	public function decompose(qubit:Array<Qubit>):Array<Operation> {
		var c1 = qubit[0];
		var c2 = qubit[1];
		var t  = qubit[2];
		
		var h = new HGate();
		var powccz = new CCZGate(exponent);
		
		return [
			h     .on([      t]),
			powccz.on([c1,c2,t]),
			h     .on([      t]),
		];
	}
}