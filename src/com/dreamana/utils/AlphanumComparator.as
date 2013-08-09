package com.dreamana.utils
{
	/** 
	 * The Alphanum Algorithm: 
	 * http://www.davekoelle.com/alphanum.html
	 */	
	public class AlphanumComparator
	{
		private var _fieldName:String;
		
		public function AlphanumComparator(fieldName:String="name")
		{
			_fieldName = fieldName;
		}
		
		private function isDigit(char:String):Boolean
		{
			var code:int = char.charCodeAt(0);
			return code >= 48 && code <= 57;
		}
		
		/** Length of string is passed in for improved efficiency (only need to calculate it once) **/
		private function getChunk(s:String, length:int, marker:int):String
		{
			var chunk:String = "";
			var c:String = s.charAt(marker);
			chunk += c;
			marker++;
			if(isDigit(c)) {
				while(marker < length) {
					c = s.charAt(marker);
					if(!isDigit(c)) break;
					chunk += c;
					marker++;
				}
			}
			else {
				while(marker < length) {
					c = s.charAt(marker);
					if(isDigit(c)) break;
					chunk += c;
					marker++;
				}
			}
			return chunk;
		}
		
		public function compareObject(o1:Object, o2:Object):int
		{
			var s1:String = o1[_fieldName];
			var s2:String = o2[_fieldName];
						
			if(!s1 || !s2) return 0;
			
			return compare(s1, s2);
		}
		
		public function compare(s1:String, s2:String):int
		{
			var marker1:int = 0;
			var marker2:int = 0;
			var length1:int = s1.length;
			var lenght2:int = s2.length;
			
			while(marker1 < length1 && marker2 < lenght2)
			{
				var chunk1:String = getChunk(s1, length1, marker1);
				marker1 += chunk1.length;
				
				var chunk2:String = getChunk(s2, lenght2, marker2);
				marker2 += chunk2.length;
				
				var result:int = 0;
				
				// If both chunks contain numeric characters, sort them numerically
				if(isDigit(chunk1.charAt(0)) && isDigit(chunk2.charAt(0))) {
					
					// Simple chunk comparison by length.
					var len:int = chunk1.length;
					result = len - chunk2.length;
					
					// If equal, the first different number counts
					if(result == 0)
					{
						for(var i:int = 0; i < len; i++)
						{
							result = chunk1.charCodeAt(i) - chunk2.charCodeAt(i);
							if(result != 0) 
								return normalize(result);
						}
					}
				} 
				else {
					//result = chunk1.compareTo(chunk2);
					if(chunk1 < chunk2) { 
						result = -1; 
					} 
					else if(chunk1 > chunk2) { 
						result = 1; 
					} 
					else {
						result = 0; 
					}
				}
				
				if(result != 0) 
					return normalize(result);
			}
			
			//comparison by length
			return normalize(length1 - lenght2);
		}
		
		private function normalize(result:int):int
		{
			return result < 0 ? -1 : (result > 0 ? 1 : 0);
		}
	}
}