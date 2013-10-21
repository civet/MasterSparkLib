package com.dreamana.action
{
	public class SleepAction extends Action
	{
		protected var _duration:int;
		protected var _time:int;
		
		public function SleepAction(duration:int)
		{
			_duration = duration;
			_time = duration;
		}
		
		override public function update(delta:Number):void
		{
			_time -= delta;			
			if(_time <= 0) {
				this.complete();
			}
		}
	}
}