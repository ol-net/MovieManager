package business
{	
	import events.DownloadEvent;
	import events.OnProgressEvent;
	import business.database.InsertVideoSQL;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	public class DownloadVideo extends EventDispatcher
	{
		[Event(name="DownloadComplete", type="events.DownloadEvent")]
		
		private var file:File;
		private var url:String;
		private var urlStream:URLStream;
		
		private var vName:String;
		private var tPath:String;
		
		private var dataFile:File;
		
		public function DownloadVideo()
		{
			urlStream = new URLStream();
			urlStream.addEventListener(ProgressEvent.PROGRESS, onProgressEvent); 
			urlStream.addEventListener(Event.COMPLETE, onCompleteEvent);
		}
		
		public function download(formUrl:String, toFile:File, videoName:String, thumbnailPath:String):void 
		{
			this.vName = videoName;
			this.tPath = thumbnailPath;
			this.url = formUrl;
			this.file = toFile;
			
			urlStream.load(new URLRequest(url));
		}
		
		private function onProgressEvent(event:ProgressEvent):void 
		{	
			var loader:URLStream = event.target as URLStream;
			
			var bytes:ByteArray = new ByteArray();
			
			loader.readBytes(bytes);
			
			var writer:FileStream = new FileStream();
			
			writer.open(this.file, FileMode.APPEND);
			
			writer.writeBytes(bytes);
			writer.close();
			
			if(vName != "" && tPath != "")
			{
				var pro:OnProgressEvent = new OnProgressEvent(OnProgressEvent.PROGRESS);
				pro.percent = String(uint(event.bytesLoaded/event.bytesTotal * 100));
				dispatchEvent(pro);
			}
		}
		
		private function onCompleteEvent(event:Event):void 
		{	
			urlStream.removeEventListener(Event.COMPLETE, onCompleteEvent);
			urlStream.removeEventListener(ProgressEvent.PROGRESS, onProgressEvent);
			
			dispatchEvent(event.clone());
			
			// dispatch additional DownloadEvent
			dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_COMPLETE, url, file));
			
			if(vName != "" && tPath != "")
			{
				var addVideo:InsertVideoSQL = InsertVideoSQL.getInstance();
				addVideo.insertVideo(vName, tPath);
			}
			
			urlStream.close();
		}
	}
}