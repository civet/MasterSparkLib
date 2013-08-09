package com.dreamana.command
{
	import com.dreamana.utils.Broadcaster;
	
	public class BaseCommand implements ICommand
	{
		public function BaseCommand()
		{
		}
		
		public function execute():void
		{
			//overriden in subclasses
		}
		
		public function interrupt():void
		{
			//overriden in subclasses
		}
		
		public function skip():void
		{
			this.interrupt();
			
			this.complete();
		}
		
		public function addCompleteHandler(handler:Function):void
		{
			completed.add(handler);
		}
		
		public function removeCompleteHandler(handler:Function):void
		{
			completed.remove(handler);
		}
		
		protected function complete():void
		{
			completed.dispatch( this );//eventTarget:this 
		}
		
		//------Signals------
		public var completed:Broadcaster = new Broadcaster();
	}
}