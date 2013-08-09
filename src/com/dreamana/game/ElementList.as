package com.dreamana.game
{
	import com.dreamana.utils.Broadcaster;
	import com.dreamana.utils.LinkedList;
	import com.dreamana.utils.LinkedListIterator;
	import com.dreamana.utils.LinkedListNode;
	
	import flash.utils.Dictionary;
	
	public class ElementList extends LinkedList
	{
		private var _nodeHash:Dictionary = new Dictionary();
		
		public function ElementList()
		{
			super();
		}
		
		public function addElement(element:Element):void
		{
			this.addElementRelate( element.relatedEntity, element );
		}
		
		public function removeElement(element:Element):void
		{
			this.removeElementRelate( element.relatedEntity );
		}
		
		public function containsElement(element:Element):Boolean
		{
			return this.containsElementRelate( element.relatedEntity) ;
		}
		
		private function addElementRelate(entity:Entity, element:Element):void
		{
			this.addNode(new LinkedListNode(element));
			
			//set node mapping (entity -> node)
			_nodeHash[ element.relatedEntity ] = this.tail;
			
			//dispatch change
			elementAdded.dispatch(this, element);
		}
		
		public function removeElementRelate(entity:Entity):void
		{
			var node:LinkedListNode = _nodeHash[ entity ];
			if(node) {
				this.removeNode(node);
				
				var element:Element = node.value;
				
				//clear node mapping
				_nodeHash[ entity ] = null;
				
				//dispatch change
				elementRemoved.dispatch(this, element);
				
				//object pool - dispose
				ElementPool.dispose( element );
			}
		}
		
		public function containsElementRelate(entity:Entity):Boolean
		{
			return _nodeHash[ entity ] != null;
		}
		
		public function removeElementContains(component:Component):void
		{
			//find target element
			var node:LinkedListNode = this.head;
			for(; node; node = node.next) {
				var element:Element = node.value;
				
				if(element.contains(component)) {
					
					//remove from list
					this.removeElementRelate( element.relatedEntity );
					
					break;
				}
			}
		}
		
		
		//--- Signals ---
		
		public var elementAdded:Broadcaster = new Broadcaster();
		public var elementRemoved:Broadcaster = new Broadcaster();
	}
}