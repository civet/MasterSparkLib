package com.dreamana.utils
{
	import flash.utils.Dictionary;

	/**
	 * Broadcaster
	 * @author civet (dreamana.com)
	 * 
	 * a simple way to implement Observer Pattern 
	 * just like Signal (https://github.com/robertpenner/as3-signals/)
	 */
	public class Broadcaster
	{
		protected var _listeners:Array = [];
		protected var _once:Array = [];
		
		
		public function Broadcaster()
		{
		}
		
		/**
		 * add()
		 * @param listener
		 * @param oneshot
		 * 
		 * reference: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/EventDispatcher.html#addEventListener()
		 *
		 * 1. After you successfully register an event listener, 
		 *    you cannot change its priority through additional calls to addEventListener(). 
		 * 
		 * 2. If the event listener is being registered on a node 
		 *    while an event is being processed on this node, 
		 *    the event listener is not triggered during the current phase 
		 *    but can be triggered during a later phase in the event flow, such as the bubbling phase.
		 * 
		 * 3. If an event listener is removed from a node 
		 *    while an event is being processed on the node,it is still triggered by the current actions. 
		 *    After it is removed, the event listener is never invoked again.
		 */		
		public function add(listener:Function, oneshot:Boolean=false):void
		{
			//if exist, do nothing (cannot change its priority)
			var i:int = _listeners.indexOf(listener);
			if(i != -1) return;
			
			i = _listeners.length;
			
			_listeners[ i ] = listener;
			_once[ i ] = oneshot;
		}
			
		/**
		 * remove()
		 * @param listener
		 * 
		 * reference: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/EventDispatcher.html#removeEventListener()
		 * 
		 * If there is no matching listener registered with the EventDispatcher object, 
		 * a call to this method has no effect. 
		 */		
		public function remove(listener:Function):void
		{
			//if not exist, do nothing.
			var i:int = _listeners.indexOf(listener);
			if(i == -1) return; 
				
			_listeners[ i ] = null;
			_once[ i ] = false;
		}
		
		public function addOnce(listener:Function):void
		{
			add(listener, true);
		}
		
		public function removeAll():void
		{
			var i:int = _listeners.length;
			while(i--) {
				var listener:Function = _listeners[i];
				
				_listeners[ i ] = null;
				_once[ i ] = false;
			}
		}
		
		//ATTENTION: if call add(), remove() or dispatch() during dispatching (in Handler/Callback Function)
		
		//recursion count
		protected var _count:int = 0;
		
		public function dispatch(...args):void
		{
			_count++;
			
			var func:Function;
			var n:int = _listeners.length;
			for(var i:int = 0; i < n; ++i)
			{
				func = _listeners[i];
				
				if(func != null)
				{
					//if oneshot, remove it before invoke.
					if(_once[i]) remove(func);
					
					//invoke
					func.apply(null, args);
				}
			}
			
			_count--;
			
			if(_count == 0) clear();
		}
		
		protected function clear():void
		{
			var i:int = _listeners.length;
			while(i--) {
				var listener:Function = _listeners[i];
				if(listener == null) {
					_listeners.splice(i, 1);
					_once.splice(i, 1);
					//delete _hash[ listener ];//BUG: indexes changed in array when removing but hash
				}
			}
		}
		
		//--- Getter/Setters ---
		
		public function get listeners():Array { return _listeners; }
	}
}