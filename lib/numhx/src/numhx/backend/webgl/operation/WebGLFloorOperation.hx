package numhx.backend.webgl.operation;
import numhx.backend.webgl.WebGLBackend;
import numhx.backend.webgl.WebGLNdArrayOperation;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;
import numhx.util.MathUtil;

/**
 * ...
 * @author leonaci
 */

class WebGLFloorOperation extends WebGLNdArrayOperation
{
	private var a:NdArrayBufferViewData;
	private var dst:NdArrayBufferViewData;
	
	public function new(backend:WebGLBackend, a:NdArrayBufferViewData, dst:NdArrayBufferViewData) {
		super(backend, [a], [dst]);
		this.a = a;
		this.dst = dst;
	}
	
	override public function run():Void {
	}
}
