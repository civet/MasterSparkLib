package com.dreamana.utils
{
	import flash.utils.ByteArray;
	
	public function getCharLength(str:String):int
	{
		var bytes:ByteArray = new ByteArray();
		bytes.writeMultiByte(str, "gb2312");
		var len:int = bytes.length;
		bytes.clear();
		return len;
	}
}