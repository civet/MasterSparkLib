/**
 * 参考: AdvancED ActionScript 3.0 Animation
 *
 * 3D Space -> Screen 
 * (x, y, z) -> (x1, y1, z1)
 * 
 * 推导结果:
 * x1 = (x - z) * .707
 * y1 = y * .866 - ((x + z) * .707) * -.5
 * z1 = ((x + z) * .707) * .866 - y * -.5
 * 
 * x1,y1,z1 同时放大根号2(1.414)倍，因为.707是根号2分之1，
 * 而 .707 * 1.414 = 1 可以再次简化方程。
 * x2 = x - z
 * y2 = y * 1.2247 + (x + z) * .5
 * z2 = (x + z) * .866 - y * .707
 * 
 * z2 会在层深排序中使用到。
 */

package com.dreamana.pseudo3d
{
	public class DimetricUtil
	{
		//a more accurate version of 1.2247...
		public static const Y_CORRECT:Number = Math.cos(-Math.PI / 6) * Math.SQRT2; 
		
		/** 
		 * Converts a 3D point in Dimetric space to 2D screen position, screenZ for z-sorting
		 * @param p	the position in 3D space
		 * @return 
		 */		
		public static function fromSpace(x:Number, y:Number, z:Number):Point3D
		{
			var screenX:Number = x - z;
			var screenY:Number = y * Y_CORRECT + (x + z) * .5;
			var screenZ:Number = (x + z) * .866 - y * .707;		
			return new Point3D(screenX, screenY, screenZ);
		} 
		
		/**
		 * Converts a 2D screen position to a 3D point in Dimetric space, assuming y = 0.
		 * @return 
		 */		
		public static function fromPlane(screenX:Number, screenY:Number):Point3D
		{
			var x:Number = screenY + screenX * .5;
			//var y:Number = 0;
			var z:Number = screenY - screenX * .5;
			return new Point3D(x, 0, z);
		}
	}
}