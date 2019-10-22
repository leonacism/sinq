package simulation;
import numhx.NdArray;

/**
 * ...
 * @author leonaci
 */
class StepResult
{
	public var wave(default, null):Wave;
	public var data(default, null):Array<MeasurementData>;
	
	public function new(wave:Wave, data:Array<MeasurementData>) {
		this.wave = wave;
		this.data = data;
	}
}