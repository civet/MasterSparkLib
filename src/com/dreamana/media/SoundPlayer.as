package com.dreamana.media
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class SoundPlayer extends EventDispatcher
	{
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _transform:SoundTransform;
		private var _positionMarker:Number = 0.0;
		private var _isPlaying:Boolean;
		private var _url:String;
		
		public function SoundPlayer()
		{
			_transform = new SoundTransform();
		}
		
		public function play(url:String=null):void
		{
			if(_isPlaying) return;
			if(url && url != "") _url = url;
			
			//TODO: auto reload after stream close
			if(_sound == null && _url != null) {
				_sound = new Sound();
				_sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_sound.addEventListener(Event.OPEN, onOpen);
				_sound.load(new URLRequest(url));
			}
			
			if(_sound) {
				_channel = _sound.play(_positionMarker, 0, _transform);
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				_isPlaying = true;
			}
		}
		
		public function stop():void
		{
			if(_channel) {
				_positionMarker = 0;
				
				_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				_channel.stop();
				
				_isPlaying = false;
			}
			
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_sound.removeEventListener(Event.OPEN, onOpen);
			try {
				_sound.close();
			} 
			catch(e:Error) {}
			
			_sound = null;//is= not==, I make mistake last time :P
		}
		
		public function pause():void
		{
			if(_channel && _isPlaying) {
				_positionMarker = _channel.position;
				
				_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				_channel.stop();
				
				_isPlaying = false;
			}
		}
		
		public function seek(offset:Number):void
		{
			_positionMarker = offset;
			
			if(_isPlaying) {
				_channel.stop();
				_isPlaying = false;
				
				play();
			}
		}
				
		//--- EVENT HANDLERS ---
		
		private function onIOError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function onOpen(e:Event):void
		{
			_sound.removeEventListener(Event.OPEN, onOpen);
			
			dispatchEvent(new Event(Event.OPEN));
		}
		
		private function onSoundComplete(e:Event):void
		{
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
			dispatchEvent(new Event(Event.COMPLETE));
			
			//TODO: position?
		}
		
		//--- GETTER/SETTERS ---
		
		public function get volume():Number
		{
			return _transform.volume;
		}
		
		public function set volume(value:Number):void
		{
			_transform.volume = value;
			if(_channel) _channel.soundTransform = _transform;
		}
		
		public function get position():Number
		{
			return (_channel && _isPlaying) ? _channel.position : _positionMarker; 
		}
		
		public function get sound():Sound
		{
			return _sound;
		}
				
		public function get soundChannel():SoundChannel
		{
			return _channel;
		}
		
		/*public function get id3():ID3Info
		{
			return null;
		}*/
	}
}