package business.datahandler
{	
	import business.Download;
	import business.database.SelectVideoSQL;
	
	import events.DownloadEvent;
	import events.NotConnectedEvent;
	import events.SQLVideoInsideEvent;
	import events.VideosLoadedEvent;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.XMLListCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import spark.events.IndexChangeEvent;
	
	public class VideoHandler extends EventDispatcher
	{		
		private var serviceObj:HTTPService; 
		
		private var videos:XMLListCollection;
		
		private var videoHandler:SelectVideoSQL;
		
		static private var instance:VideoHandler;
		
		public function VideoHandler()
		{
			serviceObj = new HTTPService();
			videos = new XMLListCollection();
		}
		
		public static function getInstance():VideoHandler{
			if (instance == null) instance = new VideoHandler();
			
			return instance;
		}
		
		public function init():void
		{	
			serviceObj.resultFormat = 'e4x';
			serviceObj.method = 'GET';
			serviceObj.useProxy = false;
			serviceObj.addEventListener(ResultEvent.RESULT, processResult);	
			serviceObj.addEventListener(FaultEvent.FAULT, notConnected);
			
			serviceObj.url = "http://84.23.76.132/videos.xml";
			
			serviceObj.send();
		}
		
		private var index:uint = 0;
		private var imageName:String = "";
		
		protected function processResult(response:ResultEvent):void
		{			
			var XMLResults:XML = response.result as XML;
			
			videos = new XMLListCollection(XMLResults.children());
			
			index = 0;
			
			//imageDownloader();
			
			downloadComplete(null);
		}
	
		public function imageDownloader():void 
		{
			if (index < videos.length)
			{
				var thumb:String = videos.getItemAt(index).thumbnail;
								
				var r:RegExp = /\//g;
				var r2:RegExp = /\:/g;
				var s:String = videos.getItemAt(index).thumbnail.replace(r, "");
				s = s.replace(r, "");
				
				var downLoader:Download = new Download();
				
				downLoader.addEventListener(DownloadEvent.DOWNLOAD_COMPLETE, downloadComplete);

				imageName = s.replace(r2, "");
				var file:File = File.applicationStorageDirectory.resolvePath(imageName);
				
				downLoader.download(thumb, file, "", "");
			} 
			else
			{
				var xmlLoaded:VideosLoadedEvent = new VideosLoadedEvent(VideosLoadedEvent.VIDEOSLOADED);
				dispatchEvent(xmlLoaded);
			}
		}
		
		private var vName:String = "";
		private var vURL:String = "";
		private var vThumbnail:String = "";
		
		public function downloadComplete(e:DownloadEvent):void
		{
			vName = videos.getItemAt(index).name+".mp4";
			vURL = videos.getItemAt(index).url;
			//vThumbnail = e.file.url;
			vThumbnail = videos.getItemAt(index).thumbnail;
			
			videoHandler = SelectVideoSQL.getInstance();
			videoHandler.checkVideo("mh2go/"+vName, true);
			videoHandler.addEventListener(SQLVideoInsideEvent.SELECTVIDEOCOMPLETE, videoInsideChecked);
		}
		
		public function videoInsideChecked(e:SQLVideoInsideEvent):void
		{			
			var inside:Boolean = videoHandler.getVideoInsideStatus();
			
			if(inside)
			{
				vURL = vName;
			}
			else
			{
				inside = false;
			}
			
			var newItem:Object = "<video>" +
				"<inside>"+inside+"</inside>" +
				"<name>"+vName+"</name>" +
				"<url>"+vURL+"</url>" +
				"<thumbnail>"+vThumbnail+"</thumbnail>" +
				"</video>";

			if(videos.length > index)
			{
				videos.removeItemAt(index);
				videos.addItemAt(XML(newItem), index);
			}else
			{
				//trace("out")
			}
			
			index++;
			imageDownloader();
		}
		
		public function notConnected(event:FaultEvent):void 
		{
			var notConnected:NotConnectedEvent = new NotConnectedEvent(NotConnectedEvent.NOTCONNECTED);
			dispatchEvent(notConnected);
		}
		
		public function getVideosListCollection():XMLListCollection
		{						
			return videos;
		}
	}
}