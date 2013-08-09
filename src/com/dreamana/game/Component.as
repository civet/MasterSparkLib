package com.dreamana.game
{
	import flash.utils.getQualifiedClassName;

	public class Component
	{
		public var type:String;
		
		public function Component()
		{
			this.type = getQualifiedClassName(this);
		}
	}
}