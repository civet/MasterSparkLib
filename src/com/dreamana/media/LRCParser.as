package com.dreamana.media
{
	public class LRCParser
	{
		public function LRCParser()
		{
			
		}
		
		public function parse(str:String):LRCInfo
		{
			var info:LRCInfo = new LRCInfo();
			var timeline:Array = info.timeline;
			
			
			//replace all multiple line breaks with a single new line character
			str = str.replace(/[\r\n]+/g, '\n');
			
			var lines:Array = str.split('\n');
			
			//range：[00:00.00]～[59:59.99]
			var reg:RegExp = /\[[0-5][0-9]:[0-5][0-9].[0-9][0-9]\]/g;
			
			var numLines:int = lines.length;
			for(var i:int = 0; i < numLines; ++i)
			{
				var line:String = lines[i];
				
				var timeTags:Array = line.match(reg);
				var numTimeTags:int = timeTags.length;
				
				if(numTimeTags > 0) {
					//---TIME Tags---
					
					//get lyric content, the length of time tag is 10
					var lyric:String = line.substr(numTimeTags * 10);
					
					for(var j:int = 0; j < numTimeTags; ++j)
					{
						var timeTag:String = timeTags[j];
						
						var sec:Number = parseInt(timeTag.substr(1,2)) * 60 + parseFloat(timeTag.substr(4,5));
						
						var ms:Number = sec * 1000;
						
						timeline[timeline.length] = {time: ms, content: lyric};
					}
				}
				else {
					//---ID Tags---
					
					//trim
					var idTag:String = line.replace(/^\s*|\s*$/g, '');
					
					var key:String = idTag.substring(1, idTag.indexOf(':'));
					var value:String = idTag.substring(idTag.indexOf(':')+1, idTag.length-1);
					//trace(key, value);
					
					switch(key) {
						case 'ti':
							info.meta['title'] = value;
							break;
						case 'ar':
							info.meta['artist'] = value;
							break;
						case 'al':
							info.meta['album'] = value;
							break;
						case 'by':
							info.meta['by'] = value;
							break;
						case 'offset':
							info.offset = parseInt(value);
							break;
					}
				}
			}
			
			//sort
			timeline.sortOn("time", Array.NUMERIC);
			
			//apply offset
			var num:int = timeline.length;
			for(i=0; i < num; ++i) {
				timeline[i].time += info.offset;
			}
			
			return info;
		}
	}
}