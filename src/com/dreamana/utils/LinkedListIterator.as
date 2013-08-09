package com.dreamana.utils
{
	public class LinkedListIterator
	{
		public var node:LinkedListNode;
		public var list:LinkedList;
		
		public function LinkedListIterator(list:LinkedList, node:LinkedListNode=null)
		{
			this.list = list;
			this.node = node;
		}
		
		public function start():void
		{
			this.node = list.head;
		}
		
		public function end():void
		{
			this.node = list.tail;
		}
				
		public function next():void
		{
			if(node)
				this.node = node.next;
			else 
				throw new RangeError("LinkedList iterator outside range.");
		}
		
		public function prev():void
		{
			if(node)
				this.node = node.prev;
			else 
				throw new RangeError("LinkedList iterator outside range.");
		}
		
		public function hasNext():Boolean
		{
			return node != null;
		}
		
		public function hasPrev():Boolean
		{
			return node != null;
		}
	}
}