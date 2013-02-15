package business
{
	import business.database.InsertVideoSQL;
	
	import events.DownloadEvent;
	import events.OnProgressEvent;
	
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
	
	public class Download extends EventDispatcher
	{
		[Event(name="DownloadComplete", type="events.DownloadEvent")]
		
		private var file:File;
		private var fileStream:FileStream;
		private var url:String;
		private var urlStream:URLStream;
		private var urlLoad:URLLoader;
		
		private var waitingForDataToWrite:Boolean = false;
		
		private var vName:String;
		private var tPath:String;
		
		private var fileData:ByteArray = new ByteArray();
		
		private var fileData2:ByteArray = new ByteArray();

		
		public function Download()
		{
			urlStream = new URLStream();
		
			urlStream.addEventListener(Event.OPEN, onOpenEvent);
			urlStream.addEventListener(ProgressEvent.PROGRESS, onProgressEvent); 
			urlStream.addEventListener(Event.COMPLETE, onCompleteEvent);
			
			/*
			urlLoad = new URLLoader();
			
			urlLoad.addEventListener(Event.OPEN, onOpenEvent);
			urlLoad.addEventListener(ProgressEvent.PROGRESS, onProgressEvent); 
			urlLoad.addEventListener(Event.COMPLETE, onCompleteEvent);
			*/
			
			fileStream = new FileStream();
			fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler)
		}
		
		public function download(formUrl:String, toFile:File, videoName:String, thumbnailPath:String):void 
		{
			this.vName = videoName;
			this.tPath = thumbnailPath;
			this.url = formUrl;
			this.file = toFile;
			fileStream.open(file, FileMode.WRITE);
			
			
			//urlLoad.load(new URLRequest(url));

			urlStream.load(new URLRequest(url));
		}
		
		private function onOpenEvent(event:Event):void 
		{
			waitingForDataToWrite = false;
			
			dispatchEvent(event.clone());
		}
		
		private function onProgressEvent(event:ProgressEvent):void 
		{	
			//fileData2.writeByte(urlStream.readByte());
			
			if(waitingForDataToWrite){
				
				writeToDisk();
				dispatchEvent(event.clone());
			}
			
			if(vName != "" && tPath != "")
			{
				var pro:OnProgressEvent = new OnProgressEvent(OnProgressEvent.PROGRESS);
				pro.percent = String(uint(event.bytesLoaded/event.bytesTotal * 100));
				dispatchEvent(pro);
			}
			
			//index++;
			
			//trace("Index "+index)
		}
		
		private var index:uint = 0;
		
		private function writeToDisk():void 
		{
			//urlStream.
			urlStream.readBytes(fileData, 0, urlStream.bytesAvailable);
			
			fileStream.writeBytes(fileData,0,fileData.length);
			
			urlStream.close();
			
			waitingForDataToWrite = false;
			
			dispatchEvent(new DataEvent(DataEvent.DATA));
		}
		
		private function writeProgressHandler(evt:OutputProgressEvent):void
		{
			waitingForDataToWrite = true;
		}
		
		private function onCompleteEvent(event:Event):void 
		{
			if(urlStream.bytesAvailable>0)
				writeToDisk();
			//fileStream.close();
			
			fileStream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler);
			
			dispatchEvent(event.clone());
			// dispatch additional DownloadEvent
			dispatchEvent(new DownloadEvent(DownloadEvent.DOWNLOAD_COMPLETE, url, file));
			
			if(vName != "" && tPath != "")
			{
				var addVideo:InsertVideoSQL = InsertVideoSQL.getInstance();
				addVideo.insertVideo(vName, tPath);
			}
			fileStream.close();
		}
	}
}