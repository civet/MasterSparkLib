package com.dreamana.game
{
	import com.dreamana.utils.LinkedList;
	import com.dreamana.utils.LinkedListNode;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class GameWorld
	{
		public var stage:Stage;
		public var entityManager:EntityManager;
		public var systemManager:SystemManager;
		
		public function GameWorld(stage:Stage)
		{
			this.stage = stage;
			entityManager = EntityManager.getInstance();
			systemManager = SystemManager.getInstance();
		}
		
		public function start():void
		{
			elapsedTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onFrameLoop);
		}
		
		public function stop():void
		{
			frameTime = 0;
			stage.removeEventListener(Event.ENTER_FRAME, onFrameLoop);
		}
		
		protected function gameLoop():void
		{
			systemManager.update();
		}
		
		//---Event Handlers---
		
		protected var now:int;
		protected var elapsedTime:int;
		public static var frameTime:int;
		
		protected function onFrameLoop(event:Event):void
		{
			now = getTimer();
			frameTime = now - elapsedTime;
			elapsedTime = now;
			
			gameLoop();
		}
	}
}