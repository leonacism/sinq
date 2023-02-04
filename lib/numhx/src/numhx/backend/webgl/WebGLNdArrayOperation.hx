package numhx.backend.webgl;
import numhx.backend.webgl.WebGLBackend;
import numhx.buffer.NdArrayBufferView;
import numhx.backend.NdArrayOperation;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;

/**
 * ...
 * @author leonaci
 */

class WebGLNdArrayOperation implements NdArrayOperation
{
	private var backend:WebGLBackend;
	public var inputs(default, null):Array<NdArrayBufferViewData>;
	public var outputs(default, null):Array<NdArrayBufferViewData>;
	

	public function new(backend:WebGLBackend, inputs:Array<NdArrayBufferViewData>, outputs:Array<NdArrayBufferViewData>) {
		this.backend = backend;
		this.inputs = inputs;
		this.outputs = outputs;
	}
	
	public function run():Void throw 'error: not implemented.';
}
