package com.dreamana.pseudo3d
{
	import flash.display.DisplayObjectContainer;
	
	public class ZSorter
	{
		public var sortField:String = "z";
		public var elementField:String = "display";
		
		public function ZSorter(sortField:String="z", elementField:String="display")
		{
			this.sortField = sortField;
			this.elementField = elementField;
		}
		
		public function sort(container:DisplayObjectContainer, objects:Array):void
		{
			//TODO: a faster sorting function?
			objects.sortOn(sortField, Array.NUMERIC);
			
			var len:uint = objects.length;
			for (var i:uint = 0; i < len; ++i)
			{
				container.setChildIndex(objects[i][elementField], i);
			}
		}
	}
}