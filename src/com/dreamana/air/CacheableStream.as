/**
 * URLStream for AIR mobile
 * 
 * Feature:
 * 1. Load binary file
 * 2. Cache file in cacheDirectory or applicationStorageDirectory
 */
package com.dreamana.air
{
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

	public class CacheableStream extends EventDispatcher
	{
		protected var _url:String;
		protected var _cacheDir:File;
		protected var _bytes:ByteArray;
		protected var _stream:URLStream;
		
		
		public function CacheableStream()
		{
			_stream = new URLStream();
			_stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_stream.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_stream.addEventListener(Event.COMPLETE, onLoadComplete);
			
			//for iOS
			//http://blogs.adobe.com/airodynamics/2012/03/05/app-compliance-with-apple-data-storage-guidelines/
			//Note: outdate!
			//_cacheDir = new File(File.applicationDirectory.nativePath +"/\.\./Library/Caches");
			
			//for all
			//http://blogs.adobe.com/airodynamics/2013/02/13/preventing-automatic-cloud-backup-on-ios-devices/
			//Note: The above properties will only work for application descriptor namespace 3.6 (or greater) and SWF version greater than 19.
			_cacheDir = File.cacheDirectory || File.applicationStorageDirectory;
		}
		
		public function load(request:URLRequest):void
		{
			_url = request.url;
			
			var file:File = _cacheDir.resolvePath( this.generatePath(_url) );
			if(file.exists) {
				//get data from cache
				var fileStream:FileStream = new FileStream();
				fileStream.addEventListener(Event.COMPLETE, onCacheFileLoadComplete);
				fileStream.openAsync(file, FileMode.READ);
				
				this.dispatchEvent(new Event(Event.OPEN));
			}
			else {
				//load data from server
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
			
			//clear bytes, save memory!
			if(_bytes) _bytes.clear();
		}
		
		protected function generatePath(url:String):String
		{
			var sep:int = url.lastIndexOf('/') + 1;
			var dir:String = url.substring(0, sep);
			var filename:String = url.substr(sep);
			
			//Method 1. convert to hashcode?
			//dir = ELFHash(dir).toString(16) + "/";
			
			//Method 2. simply mapping url to path without protocol
			dir = dir.replace('http://', '');
						
			return dir + filename;
		}
		
		//------Event Handlers------
		
		protected function onIOError(e:IOErrorEvent):void
		{
			this.dispatchEvent(e);
		}
		
		protected function onLoadProgress(e:ProgressEvent):void
		{
			this.dispatchEvent(e);
		}
		
		protected function onLoadComplete(e:Event):void
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
		
		protected function onCacheFileLoadComplete(event:Event):void
		{
			var fileStream:FileStream = event.currentTarget as FileStream;
			
			var bytes:ByteArray = new ByteArray();
			fileStream.readBytes(bytes);
			fileStream.close();
			
			//get data
			_bytes = bytes;
			_bytes.position = 0;
						
			//COMPLETE
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
				
		/*---Utils--
		
		public static function ELFHash(key:String):uint
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
		*/
		
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