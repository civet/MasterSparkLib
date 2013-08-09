package com.dreamana.utils
{
	import flash.display.MovieClip;
	
	[Embed(source="../assets/assets.swf", symbol="EnterFrameDispatcher")]
	public class EnterFrameDispatcher extends MovieClip
	{
		public var enterFrame:Broadcaster;
		
		public function EnterFrameDispatcher()
		{
			enterFrame = new Broadcaster();
			
			function frame1():void
			{
				enterFrame.dispatch();
			}
			
			function frame2():void
			{
				enterFrame.dispatch();
			}
			
			addFrameScript(0, frame1, 1, frame2);
			//trace("EnterFrameDispatcher created.");
		}
		
		
	}
}