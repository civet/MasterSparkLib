package com.dreamana.action
{
	public class DelayAction extends Action
	{
		protected var _delay:int;
		protected var _time:int;
		protected var _action:IAction;
		
		public function DelayAction(delay:int, action:IAction)
		{
			_delay = delay;
			_time = delay;
			_action = action;
			_action.owner = this;
		}
		
		override public function update(delta:Number):void
		{
			_time -= delta;			
			if(_time <= 0) {
				
				_action.update(delta);
				if(_action.isComplete) {
					_action.owner = null;										
					this.complete();
				}
				
			}
		}
	}
}