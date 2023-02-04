package numhx.backend.webgl.gl;
import haxe.ds.Vector;
import js.html.webgl.Extension;
import js.html.webgl.GL;
import js.html.webgl.VertexArrayObject;
import js.html.webgl.extension.OESVertexArrayObject;
import numhx.backend.webgl.gl.GLConstants.GeomKind;
import numhx.backend.webgl.gl.GLConstants.TextureDataType;

/**
 * ...
 * @author leonaci
 */
class GLVertexArrayObject
{
	static private var FORCE_NATIVE:Bool = false;
	
	private var gl:GL;
	
	private var nativeVAOExtension:OESVertexArrayObject;
	private var nativeVAO:VertexArrayObject;
	private var nativeState:GLAttributeState;
	
	private var attributes:Array<GLAttributeProperty>;
	private var indexBuffer:GLBuffer;
	private var dirty:Bool;

	public function new(gl:GL, ?state:GLAttributeState) {
		this.gl = gl;
		
		for (name in ['OES_vertex_array_object', 'MOZ_OES_vertex_array_object', 'WEBKIT_OES_vertex_array_object']) {
			var ext = gl.getExtension(name);
			if (ext != null) nativeVAOExtension = ext;
		}
		
		if (nativeVAOExtension != null) {
			nativeVAO = nativeVAOExtension.createVertexArrayOES();
			
			var maxAttribs:Int = gl.getParameter(GL.MAX_VERTEX_ATTRIBS);
			
			nativeState = state!=null? state : {
				tempAttribState: Vector.fromArrayCopy([for(i in 0...maxAttribs) false]),
				attribState: Vector.fromArrayCopy([for(i in 0...maxAttribs) false]),
			};
			
			attributes = [];
			indexBuffer = null;
			dirty = false;
		}
	}
	
	
	public function bind():Void {
		if (nativeVAO != null) {
			nativeVAOExtension.bindVertexArrayOES(nativeVAO);
			
			if (dirty) {
				dirty = false;
				activate();
			}
		}
		else activate();
		
		if (indexBuffer != null) {
			indexBuffer.bind();
		}
	}
	
	public inline function unbind():Void {
		if (nativeVAO != null) {
			nativeVAOExtension.bindVertexArrayOES(null);
		}
	}
	
	public function activate():Void {
		var lastBuffer = null;
		
		for (attrib in attributes) {
			if (lastBuffer != attrib.buffer) {
				attrib.buffer.bind();
				lastBuffer = attrib.buffer;
			}
			
			gl.vertexAttribPointer(
				attrib.attribute.location,
				attrib.attribute.size,
				attrib.type,
				attrib.normalized,
				attrib.stride,
				attrib.start
			);
		}
		
		setVertexAttribArrays(attributes, nativeState);
		
		if (indexBuffer != null) {
			indexBuffer.bind();
		}
	}
	
	public inline function addAttribute(buffer:GLBuffer, attribute:GLAttributeData, type:TextureDataType, normalized:Bool, stride:Int, start:Int):Void {
		attributes.push({
			buffer: buffer,
			attribute: attribute,
			type: type,
			normalized: normalized,
			stride: stride,
			start: start,
		});
		
		dirty = true;
	}
	
	public inline function addIndex(buffer:GLBuffer):Void {
		indexBuffer = buffer;
		dirty = true;
	}
	
	public function clear():Void {
		if (nativeVAO!=null) {
			nativeVAOExtension.bindVertexArrayOES(nativeVAO);
		}
		
		attributes = [];
		indexBuffer = null;
	}
	
	public inline function draw(mode:GeomKind, size:Int, start:Int):Void {
		if (indexBuffer != null) {
			gl.drawElements(mode, size, TextureDataType.UnsignedShort, 2 * start);
		}
		else gl.drawArrays(mode, start, size);
	}
	
	public function dispose():Void {
		if (nativeVAO != null) {
			nativeVAOExtension.deleteVertexArrayOES(nativeVAO);
		}
		
		gl = null;
		
		nativeVAOExtension = null;
		nativeVAO = null;
		nativeState = null;
		
		attributes = null;
		indexBuffer = null;
	}
	
	private inline function setVertexAttribArrays(attribs:Array<GLAttributeProperty>, state:GLAttributeState):Void {
		var tempAttribState = state.tempAttribState;
		var attribState = state.attribState;
		
		//initialize state
		for (i in 0...tempAttribState.length) {
			tempAttribState[i] = false;
		}
		
		//apply attribute location
		for (attrib in attribs) {
			tempAttribState[attrib.attribute.location] = true;
		}
		
		//update
		for (i in 0...attribState.length) {
			if (attribState[i] != tempAttribState[i]) {
				attribState[i] = tempAttribState[i];
				
				if (attribState[i]) {
					gl.enableVertexAttribArray(i);
				}
				else {
					gl.disableVertexAttribArray(i);
				}
			}
		}
	}
}

private typedef GLAttributeProperty = {
	var buffer:GLBuffer;
	var attribute:GLAttributeData;
	var type:TextureDataType;
	var normalized:Bool;
	var stride:Int;
	var start:Int;
}