package com.dreamana.action
{
	public class InvokeAction extends Action
	{
		public var func:Function;
		public var args:Array;
		
		public function InvokeAction(func:Function, ...args)
		{
			this.func = func;
			if(args.length > 0)	this.args = args;
		}
		
		override public function update(delta:Number):void
		{
			func.apply(null, args);
			this.complete();
		}
	}
}