package com.dreamana.utils
{
	public class LinkedListNode
	{
		public var value:*;
		public var next:LinkedListNode;
		public var prev:LinkedListNode;
		
		public function LinkedListNode(value:* = null)
		{
			this.value = value;
			this.prev = null;
			this.next = null;
		}
		
		public function toString():String
		{
			return value;
		}
	}
}