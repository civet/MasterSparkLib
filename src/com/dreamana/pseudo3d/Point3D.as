package com.dreamana.pseudo3d
{
	public class Point3D
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Point3D(x:Number=0.0, y:Number=0.0, z:Number=0.0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function reset(x:Number=0.0, y:Number=0.0, z:Number=0.0):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function toString():String
		{
			return "(x=" + this.x + ", y=" + this.y + ", z=" + this.z + ")";
		}
	}
}