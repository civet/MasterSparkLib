package com.dreamana.command
{
	import flash.events.Event;

	public interface ICommand
	{
		function execute():void;
		function interrupt():void;
		function skip():void;
		function addCompleteHandler(handler:Function):void;
		function removeCompleteHandler(handler:Function):void;
	}
}