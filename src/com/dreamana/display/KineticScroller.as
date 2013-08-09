package com.dreamana.display
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class KineticScroller extends Sprite
	{
		//factors
		protected static const FRICTION:Number = 0.8;
		protected static const STIFFNESS:Number = 0.4;
		
		protected var _viewWidth:int;
		protected var _viewHeight:int;
		protected var _content:DisplayObject;
		protected var _mask:Shape;
		
		public function KineticScroller(w:int, h:int)
		{
			_viewWidth = w;
			_viewHeight = h;
			
			_mask = new Shape();
			
			draw();
		}
		
		public function setSize(w:int, h:int):void
		{
			_viewWidth = w;
			_viewHeight = h;
			
			draw();
		}
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginFill(0x0, 0);
			graphics.drawRect(0, 0, _viewWidth, _viewHeight);
			graphics.endFill();
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x0);
			_mask.graphics.drawRect(0, 0, _viewWidth, _viewHeight);
			_mask.graphics.endFill();
		}
		
		protected var _mx:int;
		protected var _my:int;
		protected var _vx:Number;
		protected var _vy:Number;
		
		public function drag(mx:int, my:int):void
		{
			//init position
			_mx = mx;
			_my = my;
			
			//stop droping
			this.removeEventListener(Event.ENTER_FRAME, onDropping);
			
			//start moving
			//this.addEventListener(Event.ENTER_FRAME, onMoving);
			
			//state
			_isDragging = true;
		}
		
		public function drop(mx:int, my:int):void
		{
			//stop moving
			//this.removeEventListener(Event.ENTER_FRAME, onMoving);
			
			//start dropping
			this.addEventListener(Event.ENTER_FRAME, onDropping);
			
		}
		
		//start moving
		public function moveTo(mx:int, my:int):void
		{						
			//moving content
			this.move(mx - _mx, my - _my);
			
			//tracking velocity
			_vx = mx - _mx;
			_vy = my - _my;
			
			//update position
			_mx = mx;
			_my = my;
		}
		
		protected function move(dx:Number, dy:Number):void
		{
			if(dx == 0 && dy == 0) return;
			
			if(scrollHEnabled) _content.x += dx;
			if(scrollVEnabled) _content.y += dy;
		}
		
		public function cancel():void
		{
			_isDragging = false;
		}
		
		//------Event handlers
				
		protected function onDropping(event:Event):void
		{
			//decay the velocity
			_vx *= FRICTION;
			_vy *= FRICTION;
			if(_vx > -0.01 && _vx < 0.01 && _vy > -0.01 && _vy < 0.01)
			{
				_vx = 0;
				_vy = 0;
			}
			
			//spring displacement
			var displacementX:int = getDisplacementX();
			var displacementY:int = getDisplacementY();
			
			//apply Hooke's law: F = kx
			var fx:Number = displacementX * STIFFNESS;
			var fy:Number = displacementY * STIFFNESS;
						
			var dx:Number = _vx + fx;
			var dy:Number = _vy + fy;
			
			if(displacementY == 0 && displacementX == 0 && _vx == 0 && _vy == 0)
			{
				//stop dropping
				this.removeEventListener(Event.ENTER_FRAME, onDropping);
				
				//align to pixel
				//_content.x = Math.round(_content.x);
				//_content.y = Math.round(_content.y);
				_content.x = int(_content.x);
				_content.y = int(_content.y);
				
				//finish
				_isDragging = false;
			}
			else {
				//moving content
				this.move(dx, dy);
			}
		}
		
		//------Utils
		
		protected function getDisplacementX():Number
		{
			var min:int, max:int;
			if(content.width > _viewWidth) {
				min = _viewWidth - content.width;
				max = 0;
			}
			else {
				if(alignment == 0) {
					min = 0;
					max = 0;
				}
				else {
					min = (_viewWidth - content.width) >> 1;
					max = (_viewWidth - content.width) >> 1;
				}
			}
			
			var px:Number = this.content.x;
			if (px > max) {
				return max - px;
			}
			else if(px < min) {
				return min - px;
			}
			return 0;
		}
		
		protected function getDisplacementY():int
		{
			var min:int, max:int;
			if(content.height > _viewHeight) {
				min = _viewHeight - content.height;
				max = 0;
			}
			else {
				if(alignment == 0) {
					min = 0;
					max = 0;
				}
				else {
					min = (_viewHeight - content.height) >> 1;
					max = (_viewHeight - content.height) >> 1;
				}
			}
			
			var py:Number = this.content.y;
			if (py > max) {
				return max - py;
			}
			else if(py < min) {
				return min - py;
			}
			return 0;
		}
		
		//------Getter/setters
		
		public function get content():DisplayObject { return _content; }
		
		public function set content(value:DisplayObject):void
		{
			if(_content && _content.parent == this) {
				this.removeChild(_content);
			}
			
			_content = value;
			
			this.addChild(_content);
			this.addChild(_mask);
			_content.mask = _mask;
			
			//events
			//this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//TODO: for touch?
		}
		
		protected var _isDragging:Boolean;
		
		public function get isDragging():Boolean { return _isDragging; }
		
		public var scrollHEnabled:Boolean = true;
		public var scrollVEnabled:Boolean = true;
		
		protected var _useMouse:Boolean = false;
		
		public function get useMouse():Boolean { return _useMouse; }
		public function set useMouse(value:Boolean):void {
			_useMouse = value;
			
			if(_useMouse) this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			else this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public var alignment:int = 0;
		
		//*------Mouse Controls		
		
		protected var _stageX:int;
		protected var _stageY:int;
		
		protected function onMouseDown(event:MouseEvent):void
		{
			drag(event.stageX, event.stageY);
			
			_stageX = event.stageX;
			_stageY = event.stageY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			stage.addEventListener(Event.ENTER_FRAME, onMoving);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			stage.removeEventListener(Event.ENTER_FRAME, onMoving);
			
			drop(event.stageX, event.stageY);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			_stageX = event.stageX;
			_stageY = event.stageY;
		}
		
		protected function onMoving(event:Event):void
		{
			moveTo(_stageX, _stageY);
		}
		//*/
	}
}