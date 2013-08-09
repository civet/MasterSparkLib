package com.dreamana.game
{
	import flash.utils.getQualifiedClassName;

	public class Entity
	{
		public var name:String;
		public var components:Object = {};//.<Component>
		
		
		public function Entity(name:String=null)
		{
			this.name = name;
		}
		
		public function add(component:Component):Entity
		{			
			components[ component.type ] = component;
			
			//dispatch
			if(onComponentAdded != null) onComponentAdded(this, component);
			
			return this;
		}
		
		public function remove(component:Component):Component
		{			
			//dispatch
			if(onComponentRemoved != null) onComponentRemoved(this, component);
				
			components[ component.type ] = null;
			delete components[ component.type ];
						
			return component;
		}
				
		public function getComponent(type:String):Component
		{
			return components[type];
		}
		
		public function getComponentByClass(componentClass:Class):Component
		{
			return components[ getQualifiedClassName(componentClass) ];
		}
		
		
		
		
		public function createElementOf(elementClass:Class):Element
		{
			var element:Element = ElementPool.create( elementClass );
			
			var match:Boolean = true;
			
			var variables:Array = element.variables;
			var len:int = variables.length;
			for(var i:int=0; i < len; i++)
			{
				var variable:Object = variables[i];
				var name:String = variable.name;
				var type:String = variable.type;
				
				var component:Component = this.getComponent( type );
				if( component ) {
					//assign component reference to element
					element[ name ] = component;
				}
				else {
					//does not match
					match = false;
					break;
				}
			}
			
			if(match) {
				//set entity relation
				element.relatedEntity = this;
				
				return element;
			}
			//else
			
			//cache the element just created
			ElementPool.dispose(element);
			
			return null;
		}
		
		public function createElementMatch(elementClass:Class, componentType:String):Element
		{
			var element:Element = ElementPool.create( elementClass );
			
			var match:Boolean = true;
			var hasType:Boolean = false;
			
			var variables:Array = element.variables;
			var len:int = variables.length;
			for(var i:int=0; i < len; i++)
			{
				var variable:Object = variables[i];
				var name:String = variable.name;
				var type:String = variable.type;
				
				var component:Component = this.getComponent( type );
				if( component ) {
					//assign component reference to element
					element[ name ] = component;
				}
				else {
					//does not match
					match = false;
					break;
				}
				
				if(componentType == type) hasType = true;
			}
			
			if(match && hasType) {
				//set entity relation
				element.relatedEntity = this;
				
				return element;
			}
			//else 
			
			//cache the element just created
			ElementPool.dispose(element);
			
			return null;
		}
		
		//---Callback---		
		internal var onComponentAdded:Function;
		internal var onComponentRemoved:Function;
	}
}