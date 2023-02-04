package numhx.backend.webgl.operation;
import numhx.backend.webgl.WebGLBackend;
import numhx.backend.webgl.WebGLNdArrayOperation;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;
import numhx.util.MathUtil;

/**
 * ...
 * @author leonaci
 */

class WebGLPowOperation extends WebGLNdArrayOperation
{
	private var a:NdArrayBufferViewData;
	private var b:NdArrayBufferViewData;
	private var dst:NdArrayBufferViewData;
	
	public function new(backend:WebGLBackend, a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData) {
		super(backend, [a,b], [dst]);
		this.a = a;
		this.b = b;
		this.dst = dst;
	}
	
	override public function run():Void {
	}
}
