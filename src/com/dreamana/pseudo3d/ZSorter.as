package com.dreamana.pseudo3d
{
	import flash.display.DisplayObjectContainer;
	
	public class ZSorter
	{
		public static var sortField:String = "z";
		public static var elementField:String = "display";
		
		public static function sort(container:DisplayObjectContainer, objects:Array):void
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