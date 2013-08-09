package com.dreamana.command
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class SleepCommand extends BaseCommand
	{
		protected var _delay:int;
		protected var _uid:uint;
		
		public function SleepCommand(delay:int)
		{
			_delay = delay;
		}
		
		override public function interrupt():void
		{
			clearTimeout(_uid);
		}
		
		override public function execute():void
		{			
			if(_delay > 0) {
				_uid = setTimeout(this.complete, _delay);
			}
			else {
				this.complete();
			}
		}		
	}
}