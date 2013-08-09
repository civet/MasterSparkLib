package com.dreamana.utils
{
	public function trim(s:String):String {
		return s ? s.replace(/^\s+|\s+$/gs, '') : "";
	}
}