package com.dreamana.command
{
	public class InvokeCommand extends BaseCommand
	{
		public var func:Function;
		public var args:Array;
		
		public function InvokeCommand(func:Function, ...args)
		{  
			this.func = func;
			if(args.length > 0)	this.args = args;
		}
		
		override public function execute():void
		{
			func.apply(null, args);
			this.complete();
		}
	}
}