package com.dreamana.action
{
	import com.dreamana.utils.Broadcaster;

	public class Action implements IAction
	{
		protected var _isComplete:Boolean;
		protected var _isBlocking:Boolean;
				
		public function Action()
		{
		}
		
		public function update(delta:Number):void
		{
			//Override in subclass
		}
		
		public function complete():void
		{
			_isComplete = true;
			
			completed.dispatch( this );//eventTarget:this 
		}
		
		public function block():void
		{
			_isBlocking = true;
		}
		
		public function unblock():void
		{
			_isBlocking = false;
		}
		
		//--- Getter/setters ---
		
		public function get isComplete():Boolean
		{
			return _isComplete;
		}
		
		public function get isBlocking():Boolean
		{
			return _isBlocking;
		}
		
		protected var _laneID:int;						
		public function get laneID():int { return _laneID; }
		public function set laneID(value:int):void {
			_laneID = value;
		}
		
		protected var _owner:IAction;
		public function get owner():IAction { return _owner; }
		public function set owner(value:IAction):void {
			_owner = value;
		}
		
		//--- Signals ---
		
		public var completed:Broadcaster = new Broadcaster();
	}
}