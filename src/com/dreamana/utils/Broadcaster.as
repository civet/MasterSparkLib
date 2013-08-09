//BUG:2011-11-30
//When dispatching, if one handler function try to remove listener, listenerList is changed!
package com.dreamana.utils
{
	/**
	 * Broadcaster
	 * @author civet (dreamana.com)
	 * 
	 * a simple way to implement Observer Pattern 
	 * just like Signal (https://github.com/robertpenner/as3-signals/)
	 */
	public class Broadcaster
	{
		public var _listeners:Array;//Vector.<Function>
		private var _once:Array;//Vector.<Boolean>
			
		public function Broadcaster()
		{
			_listeners = [];
			_once = [];
		}
		
		public function add(listener:Function, oneshot:Boolean=false):void
		{
			if(!_dispatching) remove(listener);//(FIXED:2013-08-07)
			
			_listeners[_listeners.length] = listener;
			_once[_once.length] = oneshot;
		}
				
		public function remove(listener:Function):void
		{
			var num:int = _listeners.length;
			for(var i:int = 0; i < num; i++) {
				if(_listeners[i] == listener) {
					//_listeners.splice(i, 1);
					//_once.splice(i, 1);
					//remove() method should not remove any elements of listenerList.(FIXED:2011-11-30)
					_listeners[i] = null;
					_once[i] = false;
				}
			}
		}
		
		public function addOnce(listener:Function):void
		{
			add(listener, true);
		}
		
		public function removeAll():void
		{
			_listeners.length = 0;
			_once.length = 0;
		}
		
		private var _dispatching:Boolean;
		
		public function dispatch(...args):void
		{
			//clear null elements of listenerList before dispatch.(FIXED:2011-11-30)
			var i:int = _listeners.length;
			if(!i) return;
			while(i--) {
				if(_listeners[i] == null) {
					_listeners.splice(i, 1);
					_once.splice(i, 1);
				}
			}
			
			//add() or remove() would invoke when dispatching. (FIXED:2013-08-07)
			_dispatching = true;
			
			var func:Function;
			var num:int = _listeners.length;
			for(i = 0; i < num; i++) {
				func = _listeners[i];
				func.apply(null, args);
				if(_once[i]) remove(func);
			}
			
			_dispatching = false;
		}
	}
}