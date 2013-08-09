package com.dreamana.game
{
	import com.dreamana.utils.LinkedList;
	import com.dreamana.utils.LinkedListIterator;
	import com.dreamana.utils.LinkedListNode;
	
	import flash.utils.getTimer;

	public class SystemManager
	{
		private var _systems:LinkedList = new LinkedList();//.<System>
		
		public function SystemManager()
		{
			if(_instance) throw Error("Singleton!");
		}
		
		public function addSystem(system:System, priority:int):void
		{
			system.priority = priority;
			system.initialize();
			
			var itr:LinkedListIterator = _systems.getIterator();
			for(itr.start(); itr.hasNext(); itr.next()) {
				
				var sys:System = itr.node.value;
				
				if(sys.priority > system.priority) {
					_systems.insertBefore(system, itr);
					break;
				}
			}
			if(itr.node == null) _systems.pushOnce(system);
		}
		
		public function removeSystem(system:System):void
		{
			_systems.remove(_systems.nodeOf(system));
			
			system.dispose();
		}
		
		public function getSystem(priority:int):System
		{
			var node:LinkedListNode = _systems.head;
			for(; node; node = node.next) {
				
				var system:System = node.value;
				if(system.priority == priority) {
					return system;
					break;
				}
			}
			return null;
		}
		
		public function getSystemByClass(systemClass:Class):System
		{
			var node:LinkedListNode = _systems.head;
			for(; node; node = node.next) {
				
				var obj:Object = node.value;
				
				if(obj.constructor == systemClass) {
					return obj as System;
					break;
				}
			}
			return null;
		}
		
		public function update():void
		{
			var system:System;
			var node:LinkedListNode = _systems.head;
			for(; node; node = node.next) {
				system = node.value;
				
				//var t:int = flash.utils.getTimer();
				
				system.process();
				
				//trace(system + ":" + (getTimer()-t));
			}
		}
		
		private static var _instance:SystemManager;
		
		public static function getInstance():SystemManager 
		{
			if(_instance == null) _instance = new SystemManager();
			return _instance;
		}
	}
}