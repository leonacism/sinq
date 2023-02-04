package numhx.backend.webgl.operation;
import numhx.backend.webgl.WebGLBackend;
import numhx.backend.webgl.WebGLNdArrayOperation;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;
import numhx.util.TypeValidator;

/**
 * ...
 * @author leonaci
 */

class WebGLAssignOperation extends WebGLNdArrayOperation
{
	private var a:NdArrayBufferViewData;
	private var dummyDst:NdArrayBufferViewData;
	private var dst:NdArrayBufferViewData;
	
	public function new(backend:WebGLBackend, a:NdArrayBufferViewData, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData) {
		super(backend, [a], [dummyDst]);
		this.a = a;
		this.dummyDst = dummyDst;
		this.dst = dst;
	}
	
	override public function run():Void {
	}
}
