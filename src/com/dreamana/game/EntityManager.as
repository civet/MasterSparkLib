package com.dreamana.game
{
	import com.dreamana.utils.LinkedList;
	import com.dreamana.utils.LinkedListNode;
	
	import flash.utils.Dictionary;

	public class EntityManager
	{
		private var _entities:LinkedList = new LinkedList();//.<Entity>
		private var _elementListPool:Dictionary = new Dictionary();//.<ElementList>
		
		
		public function EntityManager()
		{
			if(_instance) throw Error("Singleton!");
		}
		
		public function addEntity(entity:Entity):void
		{
			_entities.pushOnce(entity);
			
			//start listening
			entity.onComponentAdded = onComponentAdded;
			entity.onComponentRemoved = onComponentRemoved;
			
			//update element lists
			for(var elementClass:* in _elementListPool)
			{
				var element:Element = entity.createElementOf(elementClass);
				if(element) {
					var list:ElementList = _elementListPool[ elementClass ];
					
					//add if match
					list.addElement( element );
				}
			}
		}
						
		public function removeEntity(entity:Entity):void
		{
			_entities.remove(_entities.nodeOf(entity));
			
			//remove listening
			entity.onComponentAdded = null;
			entity.onComponentRemoved = null;
			
			//update element lists
			for each(var list:ElementList in _elementListPool)
			{
				//remove
				list.removeElementRelate(entity);
			}
		}
		
		protected function onComponentAdded(targetEntity:Entity, targetComponent:Component):void
		{
			//update element lists
			for(var elementClass:* in _elementListPool)
			{
				var element:Element = targetEntity.createElementMatch(elementClass, targetComponent.type);
				if(element) {
					var list:ElementList = _elementListPool[ elementClass ];
					
					if( ! list.containsElementRelate(targetEntity) ) {
						
						//append if macth and not contained 
						list.addElement( element );
						
					}
				}
			}
		}
		
		protected function onComponentRemoved(targetEntity:Entity, targetComponent:Component):void
		{
			//update element lists
			for(var elementClass:* in _elementListPool)
			{
				var match:Object = targetEntity.createElementMatch(elementClass, targetComponent.type);
				if(match) {
					var list:ElementList = _elementListPool[ elementClass ];
					
					//remove
					list.removeElementContains(targetComponent);
					
				}
			}
		}
				
		//--- Flyweight ---
		
		public function getElementList(elementClass:Class):ElementList
		{
			var list:ElementList = _elementListPool[ elementClass ];
			
			if(list == null)
			{
				//generate new list of element.
				list = new ElementList();
				
				//traverse entities and collect matched elements
				var node:LinkedListNode = _entities.head;
				for(; node; node = node.next)
				{
					var entity:Entity = node.value;
					
					var element:Element = entity.createElementOf(elementClass);
					if(element) {
						//add if match
						list.addElement( element );
					}
				}
				
				//cache this list
				_elementListPool[ elementClass ] = list;
			}
			
			return list;
		}
		
		//--- Singleton ---
		
		private static var _instance:EntityManager;
		
		public static function getInstance():EntityManager 
		{
			if(_instance == null) _instance = new EntityManager();
			return _instance;
		}
	}
}