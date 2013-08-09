/*
	[HGEFONT]
	
	Bitmap=font_bitmap.png
	
	Char=" ",1,1,3,30,-1,4
	Char="!",5,1,7,30,1,0
	Char=""",13,1,8,30,3,2
	...
	Char=FE,445,187,17,30,0,0
	Char=FF,463,187,16,30,-2,-1
*/
package com.dreamana.text
{
	import com.dreamana.display.BitmapCutter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class HGEFont extends EventDispatcher
	{
		private var _loader:URLLoader;
		private var _charHash:Object = {};
		private var _rectangles:Array = [];
		private var _imageURL:String;
		
		private var _map:Object = {};
		private var _spacing:int = 8;
		
		
		public function HGEFont()
		{
			_loader = new URLLoader();
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.addEventListener(Event.COMPLETE, onFileLoadComplete);
		}
		
		public function load(url:String):void
		{
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.load(new URLRequest(url));
		}
		
		public function createText(str:String, useHex:Boolean=false):BitmapData
		{
			var clip:BitmapData;
			var maxWidth:int;
			var maxHeight:int;
			var a:Array;
			var i:int;
			var len:int;
			
			if(useHex) {
				a = str.split(' ');
			}
			else {
				len = str.length;
				a = [];
				for(i=0; i<len; ++i) a[a.length] = str.charAt(i);
			}
			
			//calculate maxWidth
			len = a.length;
			
			for(i = 0; i < len; ++i)
			{
				clip = _map[ a[i] ] as BitmapData;
				if(clip) {
					maxWidth += clip.width;
					if(maxHeight < clip.height) maxHeight = clip.height;
				}
				else {
					maxWidth += _spacing;
				}
			}
			
			//merge
			var bd:BitmapData = new BitmapData(maxWidth, maxHeight, true, 0x00000000);
			var pt:Point = new Point(0, 0);
			
			for(i = 0; i < len; ++i)
			{
				clip = _map[ a[i] ] as BitmapData;
				if(clip) {
					bd.copyPixels(clip, clip.rect, pt);
					pt.x += clip.width;
				}
				else {
					pt.x += _spacing;
				}
			}
			
			return bd;
		}
				
		private function parse(data:String):void
		{
			//clear array
			_rectangles.length = 0;
			
			//image URL
			var imageURL:String;
			
			data = data.replace(/\s\n/g, '\n');
			var lines:Array = data.split('\n');
			var num:int = lines.length;
			for(var i:int = 0; i<num; ++i)
			{	
				var line:String = lines[i];
				
				var key:String = line.substring(0, line.indexOf('='));
				key = key.toLowerCase();
				
				//if(key == '')
				
				if(key == "char") {
					
					var value:String = line.substr( line.indexOf('=') + 1 );
					
					//character itself or it's hexadecimal code
					var char:String;
					var a:Array;
					if(value.indexOf('"') == 0) {
						char = value.substring( 1, value.lastIndexOf('"') );
						a = value.substr( value.lastIndexOf('"') + 2 ).split(',');
					}
					else {
						char = value.substring( 0, value.indexOf(',') );
						a = value.substr( value.indexOf(',') + 1 ).split(',');
					}
					
					//the character placing on the font bitmap (x, y, w, h)
					_charHash[char] = _rectangles.length;
					_rectangles.push( new Rectangle(a[0], a[1], a[2], a[3]) );
					//trace(char, new Rectangle(a[0], a[1], a[2], a[3]));
					
					//TODO: horizontal position offsets
					
				}
				else if(key == "bitmap") {
					
					imageURL = line.substr(line.indexOf('=') + 1);
				}
			}
			
			//next step
			loadImage(imageURL);
		}
		
		private function loadImage(url:String):void
		{
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadComplete);
			imageLoader.load(new URLRequest(url));
		}
		
		private function createFont(source:BitmapData):void
		{
			var cutter:BitmapCutter = new BitmapCutter();
			var list:Array = cutter.cutFontBitmap(source, _rectangles);
			
			for(var char:String in _charHash)
			{
				var i:int = _charHash[char];
				var clip:BitmapData = list[i];
				
				_map[char] = clip;
			}
			
			//load and parse complete.
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//--- EVENT HANDLERS ---
		
		private function onFileLoadComplete(e:Event):void
		{
			parse( _loader.data );
		}
		
		private function onImageLoadComplete(e:Event):void
		{
			var bmp:Bitmap = e.currentTarget.content as Bitmap;
			if(bmp) {
				createFont( bmp.bitmapData );
				
				//bmp.bitmapData.dispose();
			}
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		//--- GETTER/SETTERS ---
		
	}
}