package com.dreamana.command
{
	import flash.events.Event;
	
	public class SerialCommand extends BaseCommand
	{
		protected var _commands:Array;
		protected var _count:int;
		
		public function SerialCommand(...commands)
		{
			_commands = commands;
		}
		
		override public function execute():void
		{
			_count = 0;
			
			if(_commands && _commands.length > 0) {
				//execute the first subcommand.
				executeSubCommand(0);
			}
			else {
				this.complete();
			}
		}
		
		override public function interrupt():void
		{
			if(_count < _commands.length) {
				var command:ICommand = _commands[_count];//current command
				command.removeCompleteHandler(onSubCommandComplete);
				command.interrupt();
			}
		}
		
		//
		public function resume():void
		{
			if(_count < _commands.length) {
				var command:ICommand = _commands[_count];
				command.addCompleteHandler(onSubCommandComplete);
				command.execute();
			}
		}
		
		protected function executeSubCommand(i:int):void
		{
			var command:ICommand = _commands[i];
			command.addCompleteHandler(onSubCommandComplete);
			command.execute();
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
			else {
				//execute next subcommand.
				executeSubCommand(_count);
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
		//Note: when subcommand completed, numCompletedCommands may not increased in the subcommand complete handler.
	}
}