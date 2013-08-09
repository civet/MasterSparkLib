package com.dreamana.command
{
	import flash.events.Event;
	
	public class ParallelCommand extends BaseCommand
	{
		protected var _commands:Array;
		protected var _count:int;
		
		public function ParallelCommand(...commands)
		{
			_commands = commands;
		}
				
		override public function execute():void
		{
			_count = 0;
			
			if(_commands && _commands.length > 0) {
				//execute all subcommands...
				var num:int = _commands.length;
				var command:ICommand;
				for(var i:int=0; i < num; ++i) {
					command = _commands[i];
					command.addCompleteHandler(onSubCommandComplete);
					command.execute();
				}
			}
			else {
				this.complete();
			}
		}
		
		override public function interrupt():void
		{
			//interrupt all subcommands
			var num:int = _commands.length;
			var command:ICommand;
			for(var i:int=0; i < num; ++i) {
				command = _commands[i];
				command.removeCompleteHandler(onSubCommandComplete);
				command.interrupt();
			}
		}
				
		//--- EVENT HANDLERS ---
		
		protected function onSubCommandComplete(target:ICommand):void
		{
			target.removeCompleteHandler(onSubCommandComplete);
			
			_count++;
			if(_count == _commands.length) {
				//when all subcommands completed
				this.complete();
			}
		}
		
		//--- SETTER/GETTERS ---
		
		public function get commands():Array {
			return _commands;
		}
		public function set commands(value:Array):void {
			_commands = value;
		}
		
		public function get numCommands():int {
			return _commands.length;
		}
		
		public function get numCompletedCommands():int {
			return _count;
		}
	}
}