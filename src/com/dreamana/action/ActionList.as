package com.dreamana.action
{
	import com.dreamana.utils.Broadcaster;
	import com.dreamana.utils.LinkedList;
	import com.dreamana.utils.LinkedListNode;

	public class ActionList implements IAction
	{
		protected var _isComplete:Boolean;
		protected var _isBlocking:Boolean;
		protected var _list:LinkedList;
				
		
		public function ActionList()
		{
			_list = new LinkedList();
		}
		
		public function push(action:IAction):void
		{
			action.owner = this;
			
			_list.pushOnce( action );
		}
		
		public function unshift(action:IAction):void
		{
			action.owner = this;
			
			_list.unshiftOnce( action );
		}
				
		public function remove(action:IAction):void
		{
			action.owner = null;
			
			_list.remove( _list.lastNodeOf(action) );
		}
		
		public function blockChildren():void
		{
			var action:IAction;
			var node:LinkedListNode = _list.head;
			for(; node; node = node.next) {
				
				action = node.value;
				action.block();
			}	
		}
		
		public function unblockChildren():void
		{
			var action:IAction;
			var node:LinkedListNode = _list.head;
			for(; node; node = node.next) {
				
				action = node.value;
				action.unblock();
			}	
		}
		
		public function update(delta:Number):void
		{
			if(_isComplete) return;
			
			var action:IAction;
			var node:LinkedListNode = _list.head;
			for(; node; node = node.next) {
				
				action = node.value;
				
				action.update( delta );
				
				if(action.isComplete) {
					this.remove(action);
					continue;
				}
				
				if(action.isBlocking) break;
			}
			
			if(_list.length == 0) {
				complete();
			}
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
		
		public function get isComplete():Boolean {
			return _isComplete;
		}
		
		public function get isBlocking():Boolean {
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
		
		public function get numActions():int {
			return _list.length;
		}
		
		//--- Utils ---
		
		public static function serial(...actions):ActionList
		{
			var actionList:ActionList = new ActionList();
			var num:int = actions.length;
			for(var i:int = 0; i < num; ++i)
			{
				var action:Action = actions[i];
				if(action) {
					
					action.block();
					actionList.push(action);
				}
			}
			
			return actionList;
		}
		
		public static function parallel(...actions):ActionList
		{
			var actionList:ActionList = new ActionList();
			var num:int = actions.length;
			for(var i:int = 0; i < num; ++i)
			{
				var action:Action = actions[i];
				if(action) {
					
					action.unblock();
					actionList.push(action);
				}
			}
			
			return actionList;
		}
		
		//--- Signals ---
		
		public var completed:Broadcaster = new Broadcaster();		
	}
}