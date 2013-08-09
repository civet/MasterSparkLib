package com.dreamana.display
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Custom Cursor
	 * @author civet (dreamana.com)
	 * 
	 * Note: flashplayer 10.2 support Native custom mouse cursors.
	 */	
	public class CustomCursor extends Sprite
	{
		public function CustomCursor(container:Stage)
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			container.addChild(this);
		}
				
		public function setStyle(display:DisplayObject):void
		{
			//removeAllChildren
			var i:int = this.numChildren;
			while(i--) {
				this.removeChildAt(i);
			}
			
			if(display != null) {
				if(display is Bitmap) {
					display.x = -int(display.width/2);
					display.y = -int(display.height/2);
				}
				this.addChild(display);
			}
		}
		
		private var useMouse:Boolean = true;
		
		public function startTrace():void
		{
			if(this.stage && useMouse) {
				//init position
				this.x = stage.mouseX;
				this.y = stage.mouseY;
				
				//keep on top
				//stage.addChild(this);
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			}
		}
		
		public function stopTrace():void
		{
			if(this.stage && useMouse) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			}
		}
		
		//--- EVENT HANDLERS ---
		
		private function onMouseMove(e:MouseEvent):void
		{
			this.x = stage.mouseX;
			this.y = stage.mouseY;
			//use or not?
			//e.updateAfterEvent();
		}
		
		private function onMouseLeave(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEnter);//add once
			stopTrace();
			this.visible = false;
		}
		
		private function onMouseEnter(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEnter);
			startTrace();
			this.visible = true;
		}
	}
}