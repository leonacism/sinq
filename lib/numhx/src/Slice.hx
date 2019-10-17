package;

/**
 * ...
 * @author leonaci
 */
enum SliceObject {
	Index(i:Int);
	Object(data:Array<Null<Int>>);
	Ellipsis;
	None;
}

abstract Slice(String) from String
{
	public function resolveSlice(shape:Array<Int>, c:Array<Bool>, b:Array<Int>, e:Array<Int>, s:Array<Int>):Void {
		var slice:Array<SliceObject> = build();
		
		if (slice.length > shape.length) throw 'error: too many indices for array.';
		
		for (i in 0...shape.length) {
			var check:Bool = false;
			var begin:Null<Int> = null;
			var end:Null<Int> = null;
			var stride:Null<Int> = null;
			
			if (i < slice.length) switch(slice[i]) {
				case SliceObject.Index(idx): {
					if (idx < 0) idx += shape[i];
					begin = idx;
					end = idx + 1;
					stride = 1;
					check = true;
				}
				case SliceObject.Object(data): {
					begin = data[0];
					end = data[1];
					stride = data[2];
				}
				case SliceObject.Ellipsis: throw 'error: Ellipsis object has no data';
				case SliceObject.None: throw 'error: None object has no data';
			}
			else {
				begin = 0;
				end = shape[i];
				stride = 1;
			}
			
			if (stride == 0) throw 'error: stride should not be zero.';
			if (begin < 0) begin += shape[i];
			if (end < 0) end += shape[i];
			
			if (stride == null) stride = 1;
			if (begin == null) begin = stride > 0? 0 : shape[i] - 1;
			if (end == null) end = stride > 0? shape[i] : -1;
			
			c.push(check);
			b.push(begin);
			e.push(end);
			s.push(stride);
		}
	}
	
	private function build():Array<SliceObject> {
		var obj:Array<Array<String>> = this.split(',').map(str->str.split(':'));
		
		var result:Array<SliceObject> = [];
		for (i in 0...obj.length) {
			var slice:Array<String> = obj[i].map(str->StringTools.trim(str));
			switch(slice) {
				case ['']: throw 'error: invalid index syntax.';
				case ['None']:
				{
					result.push(SliceObject.None);
				}
				case ['...']:
				{
					result.push(SliceObject.Ellipsis);
				}
				case [idx]:
				{
					var index:Null<Int> = Std.parseInt(idx);
					result.push(SliceObject.Index(index));
				}
				case [b,e]:
				{
					var begin :Null<Int> = b==''? null : Std.parseInt(b);
					var end   :Null<Int> = e==''? null : Std.parseInt(e);
					result.push(SliceObject.Object([begin, end, null]));
				}
				case [b,e,s]:
				{
					var begin :Null<Int> = b==''? null : Std.parseInt(b);
					var end   :Null<Int> = e==''? null : Std.parseInt(e);
					var stride:Null<Int> = s==''? null : Std.parseInt(s);
					result.push(SliceObject.Object([begin, end, stride]));
					
				}
				case _: throw 'error: invalid index syntax.';
			}
		}
		
		return result;
	}
}