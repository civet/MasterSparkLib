package com.dreamana.game
{
	import flash.utils.Dictionary;

	public class ElementPool
	{
		private static var _pool:Dictionary = new Dictionary();
		
		public function ElementPool()
		{
		}
		
		public static function create(elementClass:Class):Element
		{
			var element:Element;
			
			var a:Array = _pool[ elementClass ];
			if(a) element = a.pop();
			
			return element ||  new elementClass();
		}
		
		public static function dispose(element:Object):void
		{			
			var elementClass:Class = element.constructor;
			
			var a:Array = _pool[ elementClass ];
			if(!a) _pool[ elementClass ] = a = [];
			
			a[a.length] = Element(element).reset();
		}
		
	}
}