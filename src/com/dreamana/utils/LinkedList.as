package com.dreamana.utils
{
	public class LinkedList
	{
		public var head:LinkedListNode;
		public var tail:LinkedListNode;
		protected var _length:int;//
		
		public function LinkedList()
		{
			this.head = null;
			this.tail = null;
			_length = 0;
			
			//if(parameters.length > 0) this.push(parameters);//bug
		}
				
		public function push(...parameters):uint
		{
			var num:int = parameters.length;
			
			//One value
			var node:LinkedListNode;			
			node = new LinkedListNode(parameters[0]);
			if(tail) {
				//link new node
				tail.next = node;
				node.prev = tail;
				//tail node
				tail = node;
			}
			else {
				//first node
				head = node;
				tail = node;
			}
			_length++;
			
			//More value
			if(num > 1) {
				for(var i:int = 1; i < num; i++)
				{
					node = new LinkedListNode(parameters[i]);
					//link new node
					tail.next = node;
					node.prev = tail;
					//tail node
					tail = node;
					_length++;
				}
			}
			
			return _length;
		}
		
		public function pop():*
		{
			if(tail) {
				var value:* = tail.value;				
				if(_length == 1) {
					tail = null;
					head = null;
				}
				else {				 
					tail = tail.prev;
					tail.next = null;
				}
				_length--;
				return value;
			}
			
			return null;
		}
		
		public function shift():*
		{
			if(head) {
				var value:* = head.value;
				if(_length == 1) {
					head = null;
					tail = null;
				}
				else {
					head = head.next;
					head.prev = null;
				}				
				_length--;				
				return value;
			}
			
			return null;
		}
		
		public function unshift(...parameters):uint
		{
			var num:int = parameters.length;
			
			var node:LinkedListNode = new LinkedListNode(parameters[0]);
			var firstNode:LinkedListNode = node;
			
			//More value
			if(num > 1) {
				for(var i:int = 1; i < num; i++)
				{
					var n:LinkedListNode = new LinkedListNode(parameters[i]);
					node.next = n;
					n.prev = node;
					
					node = n;
					_length++;
				}
			}
			
			//One value
			if(head) {
				//link new node
				node.next = head;
				head.prev = node;
				//head node
				head = firstNode;
			}
			else {
				//first node
				head = firstNode;
				tail = firstNode;
			}
			_length++;
						
			return _length;
		}
		
		public function pushOnce(value:*):void
		{
			var node:LinkedListNode = new LinkedListNode(value);
			if(tail) {
				//link new node
				tail.next = node;
				node.prev = tail;
				//tail node
				tail = node;
			}
			else {
				//first node
				head = node;
				tail = node;
			}
			_length++;
		}
		
		public function unshiftOnce(value:*):void
		{
			var node:LinkedListNode = new LinkedListNode(value);
			var firstNode:LinkedListNode = node;
			if(head) {
				//link new node
				node.next = head;
				head.prev = node;
				//head node
				head = firstNode;
			}
			else {
				//first node
				head = firstNode;
				tail = firstNode;
			}
			_length++;
		}
		
		public function getIterator():LinkedListIterator
		{
			return new LinkedListIterator(this, head);
		}
		
		/**
		 * Inserts an item after a given iterator or appends it if the iterator is invalid. 
		 * @param value
		 * @param itr 
		 */		 
		public function insertAfter(value:*, itr:LinkedListIterator):void
		{
			if(itr == null || itr.list != this) return;
			
			var left:LinkedListNode = itr.node;
			if(left)
			{
				var right:LinkedListNode = left.next;
				
				//link new node to left node
				var node:LinkedListNode = new LinkedListNode(value);
				left.next = node;
				node.prev = left;
				
				//link new node to right node
				node.next = right;
				if(right) {
					right.prev = node;
				}
				else {
					tail = node;
				}
								
				_length++;
			}
			else {
				this.push(value);
			}
		}
		
		/**
		 * Inserts an item before a given iterator or appends it if the iterator is invalid. 
		 * @param value
		 * @param itr
		 */		
		public function insertBefore(value:*, itr:LinkedListIterator):void
		{
			if(itr == null || itr.list != this) return;
			
			var right:LinkedListNode = itr.node;
			if(right)
			{
				var left:LinkedListNode = right.prev;
				
				//link new node to left node
				var node:LinkedListNode = new LinkedListNode(value);
				node.prev = left;
				if(left) {
					left.next = node;
				}
				else {
					head = node;
				}
				
				//link new node to right node
				right.prev = node;
				node.next = right;
				
				_length++;
			}
			else {
				this.unshift(value);
			}
		}
				
		/**
		 * Removes the node the iterator is pointing to while moving the iterator to the next node. 
		 * @param itr
		 */		
		public function remove(itr:LinkedListIterator):void
		{
			if(itr == null || itr.list != this) return;
			
			var node:LinkedListNode = itr.node;
			if(node)
			{
				//move head or tail
				if(node == head) {
					head = head.next;
				}
				else if(node == tail) {
					tail = tail.prev;
				}
				
				//unlink left
				var left:LinkedListNode = node.prev;
				if(left) {
					left.next = node.next;
				}
				
				//unlink right
				var right:LinkedListNode = node.next;
				if(right) {
					right.prev = node.prev;
					
					//iterator move next
					itr.node = node.next;
				}
				else {
					//point to head?
					itr.node = head;					
				}
				
				//unlink itself
				node.prev = null;
				node.next = null;
				
				_length--;
				
				if(_length == 0) head = tail = null;
			}
		}
		
		public function addNode(node:LinkedListNode):void
		{
			if(tail) {
				//link new node
				tail.next = node;
				node.prev = tail;
				//tail node
				tail = node;
			}
			else {
				//first node
				head = node;
				tail = node;
			}
			_length++;
		}
		
		public function removeNode(node:LinkedListNode):void
		{
			if(node)
			{
				//move head or tail
				if(node == head) {
					head = head.next;
				}
				else if(node == tail) {
					tail = tail.prev;
				}
				
				//unlink left
				var left:LinkedListNode = node.prev;
				if(left) {
					left.next = node.next;
				}
				
				//unlink right
				var right:LinkedListNode = node.next;
				if(right) {
					right.prev = node.prev;
				}
				
				//unlink itself
				node.prev = null;
				node.next = null;
				
				_length--;
				
				if(_length == 0) head = tail = null;
			}
		}
		
		public function nodeOf(searchElement:*, from:LinkedListIterator=null):LinkedListIterator
		{
			if(from && from.list != this) return null;
			
			var node:LinkedListNode = (from == null) ? head : from.node;
			for(; node != null; node = node.next)
			{
				if(node.value === searchElement) {
					return new LinkedListIterator(this, node);
				}
			}
			
			return null;
		}
		
		public function lastNodeOf(searchElement:*, from:LinkedListIterator=null):LinkedListIterator
		{
			if(from && from.list != this) return null;
			
			var node:LinkedListNode = (from == null) ? tail : from.node;
			for(; node != null; node = node.prev)
			{
				if(node.value === searchElement) {
					return new LinkedListIterator(this, node);
				}
			}
			
			return null;
		}
		
		public function merge(list:LinkedList):void
		{
			var head2:LinkedListNode = list.head;
			var tail2:LinkedListNode = list.tail;
			if(head2) {
				if(head) {
					tail.next = head2;
					head2.prev = tail;
					tail = tail2;
				}
				else {
					head = head2;
					tail = tail2;
				}
			}
			return;
		}
		
		public function clear():void
		{
			var n:LinkedListNode;
			var node:LinkedListNode = head;
			while(node) {
				n = node;
				node = node.next;
				
				//unlink
				n.prev = null;
				n.next = null;
			}
			
			head = null;
			tail = null;
			_length = 0;
		}
		
		public function clone():LinkedList
		{
			var l:LinkedList = new LinkedList();
			for(var node:LinkedListNode = this.head; node != null; node = node.next)
			{
				l.push(node.value);
			}
			return l;
		}
				
		public function toArray():Array
		{
			var a:Array = [];
			for(var node:LinkedListNode = this.head; node != null; node = node.next)
			{
				a[a.length] = node.value;//fast push
			}
			return a;
		}
		
		public function toString():String
		{
			var str:String = "";
			for(var node:LinkedListNode = this.head; node != null; node = node.next)
			{
				str += node.toString();
				if(node != this.tail) str += ",";
			}
			return str;
		}
		
		//------Getter/Setters------
		public function get length():int { return _length; }
		public function set length(value:int):void {
			var i:int;
			if(value == length) {
				//do nothing
				return;
			}
			else if(value == 0) {
				//clear
				this.clear();
			}
			else if(value < _length) {
				//cut
				var node:LinkedListNode = head;
				for(i=0; i < value; i++) {
					node = node.next;
				}
				tail = node.prev;
				tail.next = null;
				node.prev = null;
				_length = value;
			}
			else {
				//create
				var num:int = value - _length
				for(i=0; i < num; i++) this.push(null);
			}
		}
	}
}