package com.dreamana.game
{
	public class System
	{
		public var priority:int;
		
		public function System()
		{
		}
		
		public function initialize():void
		{
			//retrieve components from entities 
		}
		
		public function process():void
		{
			//process
		}
		
		public function dispose():void
		{
			//clear element lists etc.
		}
		
		public function get entityManager():EntityManager
		{
			return EntityManager.getInstance();
		}
	}
}