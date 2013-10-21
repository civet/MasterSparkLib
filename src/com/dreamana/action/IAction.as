package com.dreamana.action
{
	public interface IAction
	{
		//basic functions
		function update(delta:Number):void;
		
		//complete
		function complete():void;
		function get isComplete():Boolean;
		
		//block & unblock
		function block():void;
		function unblock():void;
		function get isBlocking():Boolean;
		
		//lane ID (powers of 2, range: 2^0 ~ 2^32)
		function get laneID():int;
		function set laneID(value:int):void;
		
		//owner
		function get owner():IAction;
		function set owner(value:IAction):void;
	}
}