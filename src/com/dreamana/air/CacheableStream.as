/**
 * Loader for AIR
 * Feature:
 * 1. Load binary file
 * 2. Cache file in application StorageDirectory
 */
package com.dreamana.air
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public final class CacheableStream extends EventDispatcher
	{
		private var _targetPlatform:String = "iOS";
		
		private var _url:String;
		private var _cacheDir:File;
		private var _bytes:ByteArray;
		private var _stream:URLStream;//loader
		
		
		public function CacheableStream()
		{
			_stream = new URLStream();
			_stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_stream.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_stream.addEventListener(Event.COMPLETE, onLoadComplete);
			
			if(_targetPlatform == "iOS") {
				//for iOS
				//http://blogs.adobe.com/airodynamics/2012/03/05/app-compliance-with-apple-data-storage-guidelines/
				//Note: outdate!
				//_cacheDir = new File(File.applicationDirectory.nativePath +"/\.\./Library/Caches");
				
				//http://blogs.adobe.com/airodynamics/2013/02/13/preventing-automatic-cloud-backup-on-ios-devices/
				//Note: The above properties will only work for application descriptor namespace 3.6 (or greater) and SWF version greater than 19.
				_cacheDir = File.cacheDirectory;
			}
			else {
				//for windows
				_cacheDir = File.applicationStorageDirectory;
			}
		}
		
		public function load(request:URLRequest):void
		{
			_url = request.url;
			
			var file:File = _cacheDir.resolvePath( this.generatePath(_url) );
			if(file.exists) {
				//get data from cache
				var bytes:ByteArray = new ByteArray();
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				fileStream.readBytes(bytes);
				
				//get data
				_bytes = bytes;
				_bytes.position = 0;
				
				//COMPLETE
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			else {
				//load from server
				_stream.load( request );
				
				this.dispatchEvent(new Event(Event.OPEN));
			}
		}
		
		public function close():void
		{
			try {
				_stream.close();
			}
			catch(e:Error) {
				//trace(e.message);
			}
		}
		
		private function generatePath(url:String):String
		{
			var sep:int = url.lastIndexOf('/') + 1;
			var dir:String = url.substring(0, sep);
			var filename:String = url.substr(sep);
			
			//convert to hashcode?
			//dir = ELFHash(dir).toString(16) + "/";
			dir = dir.replace('http://', '');
						
			return dir + filename;
		}
		
		//------Event Handlers------
		
		private function onIOError(e:IOErrorEvent):void
		{
			this.dispatchEvent(e);
		}
		
		private function onLoadProgress(e:ProgressEvent):void
		{
			this.dispatchEvent(e);
		}
		
		private function onLoadComplete(e:Event):void
		{
			//get binary data
			var bytes:ByteArray = new ByteArray();
			var stream:URLStream = e.currentTarget as URLStream;
			stream.readBytes(bytes);
			
			//do cache
			var file:File = _cacheDir.resolvePath( this.generatePath(_url) );
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(bytes);
			fileStream.close();
			
			//get data
			_bytes = bytes;
			_bytes.position = 0;
			
			//COMPLETE
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
				
		//------utils------
		
		private static function ELFHash(key:String):uint
		{
			var hash:uint = 0;
			var g:uint = 0;
			var len:int = key.length;
			for(var i:int=0; i < len; i++)
			{
				hash = (hash << 4) + key.charCodeAt(i);
				g = hash & 0xF0000000;
				if(g != 0)
				{
					hash ^= g >> 24;
				}
				hash &= ~g;
			}
			return hash;
		}
		
		//------Getter/setters------
		
		/** hack function */
		public function readBytes(bytes:ByteArray, offset:uint=0, length:uint=0):void
		{
			_bytes.position = 0;
			_bytes.readBytes(bytes, offset, length);
		}
		
		public function get bytesAvailable():uint
		{
			return _bytes.bytesAvailable;
		}
		
		public function get bytes():ByteArray
		{
			return _bytes;
		}
	}
}