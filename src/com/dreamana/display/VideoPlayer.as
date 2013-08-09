package com.dreamana.display
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * FLV Player
	 * @author civet (dreamana.com)
	 */	
	public class VideoPlayer extends Sprite
	{
		public static const NO_SCALE:int = 0;
		public static const EXACT_FIT:int = 1;
		public static const MAINTAIN_ASPECT_RATIO:int = 2;
		
		private var _block:Shape;
		private var _blockWidth:int;
		private var _blockHeight:int;
		private var _video:Video;
		private var _videoWidth:int;
		private var _videoHeight:int;
		private var _scaleMode:int = 0;
		private var _stream:NetStream;
		private var _metadata:Object = {};
		
		
		public function VideoPlayer(w:int, h:int, scaleMode:int=0)
		{
			_blockWidth = w;
			_blockHeight = h;
			_videoWidth = w;
			_videoHeight = h;
			_scaleMode = scaleMode;
			
			_block = new Shape();
			this.addChild(_block);
			
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			_stream = new NetStream(nc);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_stream.client = this;
			
			_video = new Video();
			//_video.smoothing = true;//bug: [FP-178] Video.clear() fails, fp10.1 fixed
			this.addChild(_video);
			
			_video.attachNetStream(_stream);
			this.redraw();
		}
		
		public function play(url:String=null):void
		{
			if(url && url != "") {
				_stream.play(url);
			}
			else {
				_stream.resume();
			}
		}
		
		public function stop():void
		{
			_stream.close();
			_video.clear();
		}
		
		public function pause():void
		{
			_stream.pause();
		}
		
		public function seek(offset:Number):void
		{
			_stream.seek(offset);
		}
		
		public function setSize(w:int, h:int):void
		{
			_blockWidth = w;
			_blockHeight = h;
			redraw();
		}
				
		private function redraw():void
		{
			_block.graphics.clear();
			_block.graphics.beginFill(0);
			_block.graphics.drawRect(0, 0, _blockWidth, _blockHeight);
			_block.graphics.endFill();
			
			var w:int, h:int;
			var ox:int, oy:int;
			if(_scaleMode == NO_SCALE) {
				w = _videoWidth;
				h = _videoHeight;
				ox = (_blockWidth - _videoWidth) * 0.5;
				oy = (_blockHeight - _videoHeight) * 0.5;
			}
			else if(_scaleMode == EXACT_FIT) {
				w = _blockWidth;
				h = _blockHeight;
				ox = 0;
				oy = 0;
			}
			else if(_scaleMode == MAINTAIN_ASPECT_RATIO) {
				w = (_videoWidth / _videoHeight) * _blockHeight;
				h = _blockHeight;
				if(w > _blockWidth) {
					w = _blockWidth;
					h = (_videoHeight / _videoWidth) * _blockWidth;
				}
				ox = (_blockWidth - w) * 0.5;
				oy = (_blockHeight - h) * 0.5;
			}
			
			_video.width = w;
			_video.height = h;
			_video.x = ox;
			_video.y = oy;
		}
		
		//--- EVENT HANDLERS ---
		
		private function onAsyncError(e:AsyncErrorEvent):void
		{
			//ignore error
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function onNetStatus(e:NetStatusEvent):void
		{
			switch(e.info.code) {
				case "NetStream.Play.Stop":
					dispatchEvent(new Event(Event.COMPLETE));
					break;
				case "NetStream.Play.Start":
					dispatchEvent(new Event(Event.OPEN));			
					break;
			}
		}
		
		//--- NetStream.client CALLBACK FUNCTIONS ---
		
		public function onMetaData(info:Object):void {
			//trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			
			_metadata = info;
			
			//resize the video
			_videoWidth = info.width;
			_videoHeight = info.height;
			redraw();
		}
		
		public function onCuePoint(info:Object):void {
			//trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		//--- GETTER/SETTERS ---
		
		public function get scaleMode():int
		{
			return _scaleMode;
		}
		
		public function set scaleMode(value:int):void
		{
			_scaleMode = value;
			redraw();
		}

		public function get volume():Number
		{
			return _stream.soundTransform.volume;
		}

		public function set volume(value:Number):void
		{
			var t:SoundTransform = _stream.soundTransform;
			t.volume = value;
			_stream.soundTransform = t;
		}
		
		public function get smoothing():Boolean
		{
			return _video.smoothing;
		}
		
		public function set smoothing(value:Boolean):void
		{
			_video.smoothing = value;
		}
		
		public function get stream():NetStream
		{
			return _stream;
		}
		
		public function get metadata():Object
		{
			return _metadata;
		}
	}
}
