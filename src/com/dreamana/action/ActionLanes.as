package com.dreamana.action
{
	import com.dreamana.utils.LinkedListNode;

	public class ActionLanes extends ActionList
	{
		public function ActionLanes()
		{
			super();
		}
		
		override public function update(delta:Number):void
		{
			if(_list.length == 0) {
				complete();
				return;
			}
			
			var lanes:int = 0;
			
			var action:IAction;
			var node:LinkedListNode = _list.head;
			for(; node; node = node.next) {
				
				action = node.value;
				
				if(lanes & action.laneID) continue;
								
				action.update( delta );
				
				if(action.isComplete) {
					this.remove(action);
					continue;
				}
				
				if(action.isBlocking) lanes |= action.laneID;
			}
		}
	}
}