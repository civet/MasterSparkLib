package com.dreamana.command
{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class DelayCommand extends BaseCommand
	{
		protected var _delay:int;
		protected var _command:ICommand;
		protected var _uid:uint;
		
		public function DelayCommand(delay:int, command:ICommand)
		{
			_delay = delay;
			_command = command;
		}
		
		override public function execute():void
		{
			if(_delay > 0) {
				_uid = setTimeout(start, _delay);
			}
			else {
				start();
			}
		}
		
		override public function interrupt():void
		{
			clearTimeout(_uid);
			
			//interrupt subcommand
			_command.removeCompleteHandler(onSubCommandComplete);
			_command.interrupt();
		}
					
		protected function start():void
		{
			//execute subcommand
			_command.addCompleteHandler(onSubCommandComplete);
			_command.execute();
		}
		
		protected function onSubCommandComplete(target:ICommand):void
		{
			var command:ICommand = target;
			command.removeCompleteHandler(onSubCommandComplete);
			
			//when subcommand completed
			this.complete();
		}
	}
}