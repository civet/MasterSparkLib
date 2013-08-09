package com.dreamana.game
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	public class Element
	{
		protected var _variables:Array;
		protected var _relateEntity:Entity;
		
		public function Element()
		{
			_variables = Element.getVariables( this );
		}
		
		public function contains(component:Component):Boolean
		{
			var i:int = _variables.length;
			while(i--)
			{
				var variable:Object = _variables[i];
				if(this[variable.name] == component) {
					return true;
					break;
				}
			}
			return false;
		}
		
		public function hasType(componentType:String):Boolean
		{
			var i:int = _variables.length;
			while(i--)
			{
				var variable:Object = _variables[i];
				if(variable.type == componentType) {
					return true;
					break;
				}
			}
			return false;
		}
		
		public function reset():Element
		{
			var i:int = _variables.length;
			while(i--)
			{
				var variable:Object = _variables[i];
				this[variable.name] == null;
			}
			
			this.relatedEntity = null;
			
			return this;
		}
		
		//--- Getter/Setters ---
		
		public function get variables():Array {
			return _variables;
		}
		
		//as relation or ID		
		public function get relatedEntity():Entity {
			return _relateEntity;
		}
		public function set relatedEntity(value:Entity):void {
			_relateEntity = value;
		}
		
		//--- Flyweight ---
		
		private static var _variablesPool:Dictionary = new Dictionary();
		
		public static function getVariables(element:Object):Array
		{
			var elementClass:Class = element.constructor;
			var vars:Array = _variablesPool[ elementClass ];
			
			if(vars == null)
			{
				//generate new object
				vars = [];
				var list:XMLList = describeType( element ).variable;
				var num:int = list.length();
				for(var i:int=0; i < num; i++)
				{
					var item:XML = list[i];
					vars[i] = {name:item.@name.toString(), type:item.@type.toString()};
				}
				
				//cache this object
				_variablesPool[ elementClass ] = vars;
			}
			
			return vars;
		}
	}
}