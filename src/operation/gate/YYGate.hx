package operation.gate;
import io.Complex;
import operation.gate.feature.EigenGate;
import operation.gate.feature.TwoQubitGate;
import operation.gate.feature.UnitaryGate;



/**
 * ...
 * @author leonaci
 */
class YYGate implements EigenGate extends TwoQubitGate
{
	public var exponent(default, null):Float;
	
	public function new(?exponent:Float=1) {
		this.exponent = exponent;
	}
	
	public function pow(exponent:Float):UnitaryGate {
		var gate:UnitaryGate = new YYGate(this.exponent + exponent);
		return gate;
	}
	
	public function apply(target:NdArray):NdArray {
		return switch(exponent) {
			case 1:
			{
				var zzSlice:Slice = '0';
				var ozSlice:Slice = '1';
				var zoSlice:Slice = '2';
				var ooSlice:Slice = '3';
				
				var zz = target[zzSlice].copy();
				var oz = target[ozSlice].copy();
				var zo = target[zoSlice];
				var oo = target[ooSlice];
				
				target[zzSlice] = oo;
				target[ozSlice] = zo;
				target[zoSlice] = oz;
				target[ooSlice] = zz;
				
				target[zzSlice] *= -1;
				target[ooSlice] *= -1;
				
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
		var a = j ^ exponent;
		var c = Complex.from(Math.cos(Math.PI / 2 * exponent));
		var s = Complex.from(Math.sin(Math.PI / 2 * exponent));
		return NdArray.array([
			[    a * c,          0,          0, j * a * s],
			[        0,      a * c, -j * a * s,         0],
			[        0, -j * a * s,      a * c,         0],
			[j * a * s,          0,          0,     a * c],
		]);
	}
}