package numhx.backend.webgl.operation;
import numhx.buffer.NdArrayBufferView;
import numhx.backend.webgl.WebGLBackend;
import numhx.backend.webgl.WebGLNdArrayOperation;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;
import numhx.util.TypeValidator;

/**
 * ...
 * @author leonaci
 */

class WebGLAssignScalarOperation extends WebGLNdArrayOperation
{
	private var a:Dynamic;
	private var dummyDst:NdArrayBufferViewData;
	private var dst:NdArrayBufferViewData;
	
	public function new(backend:WebGLBackend, a:Dynamic, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData) {
		super(backend, [], [dummyDst]);
		this.a = a;
		this.dummyDst = dummyDst;
		this.dst = dst;
	}
	
	override public function run():Void {
	}
}
