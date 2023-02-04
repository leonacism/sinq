package numhx.backend.webgl;
import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.GL;
import numhx.backend.Backend;
import numhx.backend.NdArrayOperation;
import numhx.backend.webgl.operation.WebGLAbsOperation;
import numhx.backend.webgl.operation.WebGLAcosOperation;
import numhx.backend.webgl.operation.WebGLAddOperation;
import numhx.backend.webgl.operation.WebGLAddScalarOperation;
import numhx.backend.webgl.operation.WebGLAsinOperation;
import numhx.backend.webgl.operation.WebGLAssignOperation;
import numhx.backend.webgl.operation.WebGLAssignScalarOperation;
import numhx.backend.webgl.operation.WebGLAtanOperation;
import numhx.backend.webgl.operation.WebGLCeilOperation;
import numhx.backend.webgl.operation.WebGLCosOperation;
import numhx.backend.webgl.operation.WebGLDivOperation;
import numhx.backend.webgl.operation.WebGLDivScalarOperation;
import numhx.backend.webgl.operation.WebGLDotOperation;
import numhx.backend.webgl.operation.WebGLExpOperation;
import numhx.backend.webgl.operation.WebGLFloorOperation;
import numhx.backend.webgl.operation.WebGLLogOperation;
import numhx.backend.webgl.operation.WebGLMaxOperation;
import numhx.backend.webgl.operation.WebGLMaxScalarOperation;
import numhx.backend.webgl.operation.WebGLMinOperation;
import numhx.backend.webgl.operation.WebGLMinScalarOperation;
import numhx.backend.webgl.operation.WebGLMulOperation;
import numhx.backend.webgl.operation.WebGLMulScalarOperation;
import numhx.backend.webgl.operation.WebGLPowOperation;
import numhx.backend.webgl.operation.WebGLPowScalarOperation;
import numhx.backend.webgl.operation.WebGLRoundOperation;
import numhx.backend.webgl.operation.WebGLSinOperation;
import numhx.backend.webgl.operation.WebGLSqrtOperation;
import numhx.backend.webgl.operation.WebGLSubOperation;
import numhx.backend.webgl.operation.WebGLSubScalarOperation;
import numhx.backend.webgl.operation.WebGLTanOperation;
import numhx.buffer.NdArrayBuffer;
import numhx.buffer.NdArrayBufferView.NdArrayBufferViewData;

/**
 * ...
 * @author leonaci
 */

class WebGLBackend implements Backend
{
	public var gl(default, null):GL;
	
	public function new() 
	{
		var canvas:CanvasElement = Browser.document.createCanvasElement();
		gl = canvas.getContextWebGL();
	}
	
	public function run(ops:Array<NdArrayOperation>):Void {
		for (op in ops) op.run();
	}
	
	public function createBuffer():NdArrayBuffer {
		return new WebGLNdArrayBuffer(gl);
	}
	
	public function assign(a:NdArrayBufferViewData, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLAssignOperation(this, a, dummyDst, dst);
	}
	
	public function assignScalar(a:Dynamic, dummyDst:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLAssignScalarOperation(this, a, dummyDst, dst);
	}
	
	public function add(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLAddOperation(this, a, b, dst);
	}
	
	public function addScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLAddScalarOperation(this, a, b, dst);
	}
	
	public function sub(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLSubOperation(this, a, b, dst);
	}
	
	public function subScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLSubScalarOperation(this, a, b, dst);
	}
	
	public function mul(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLMulOperation(this, a, b, dst);
	}
	
	public function mulScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLMulScalarOperation(this, a, b, dst);
	}
	
	public function div(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLDivOperation(this, a, b, dst);
	}
	
	public function divScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLDivScalarOperation(this, a, b, dst);
	}
	
	public function dot(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLDotOperation(this, a, b, dst);
	}
	
	// function
	
	public function abs(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLAbsOperation(this, a, dst);
	}
	
	public function min(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLMinOperation(this, a, b, dst);
	}
	
	public function minScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLMinScalarOperation(this, a, b, dst);
	}
	
	public function max(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLMaxOperation(this, a, b, dst);
	}
	
	public function maxScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLMaxScalarOperation(this, a, b, dst);
	}
	
	public function sin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLSinOperation(this, a, dst);
	}

	public function cos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLCosOperation(this, a, dst);
	}
	
	public function tan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLTanOperation(this, a, dst);
	}
	
	public function asin(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLAsinOperation(this, a, dst);
	}
	
	public function acos(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLAcosOperation(this, a, dst);
	}
	
	public function atan(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLAtanOperation(this, a, dst);
	}
	
	public function exp(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLExpOperation(this, a, dst);
	}
	
	public function log(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLLogOperation(this, a, dst);
	}
	
	public function pow(a:NdArrayBufferViewData, b:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLPowOperation(this, a, b, dst);
	}
	
	public function powScalar(a:NdArrayBufferViewData, b:Dynamic, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLPowScalarOperation(this, a, b, dst);
	}
	
	public function sqrt(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLSqrtOperation(this, a, dst);
	}
	
	public function round(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLRoundOperation(this, a, dst);
	}
	
	public function floor(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLFloorOperation(this, a, dst);
	}
	
	public function ceil(a:NdArrayBufferViewData, dst:NdArrayBufferViewData):NdArrayOperation {
		return new WebGLCeilOperation(this, a, dst);
	}
}
