package business
{
	import mx.core.FlexSprite;
	import mx.core.UIComponent;
	
	import business.StrobeMediaContainer;
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.ParallelElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.net.NetLoader;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;
	
	//Sets the size of the SWF
	//public class OSMFPlayer
	public class OSMFPlayer
	{
		import org.osmf.media.URLResource;
		
		//URI of the media
		protected var progressive_path:String;
		protected var progressive_path_two:String;
		public var play:MediaPlayer;
		public var container_one:StrobeMediaContainer;
		public var container_two:StrobeMediaContainer;
		public var mediaFactory:DefaultMediaFactory;
		protected var parallelElement:ParallelElement;
		
		protected var height_size:Number = 0;
		protected var width_size:Number = 0;
		
		private var firstElement:VideoElement;
		
		private var track:FlexSprite;
		private var progress:FlexSprite;
		
		private var progressbarContainer:FlexSprite;
		
		public function OSMFPlayer(video:String)
		{
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT;
			//NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);

			this.progressive_path = video;
			
			// Create a mediafactory instance
			//mediaFactory = new DefaultMediaFactory();
			
			// Create the left upper Media Element to play the presenter
			// and apply the meta-data
			//firstElement = mediaFactory.createMediaElement( new URLResource( progressive_path ));
			
			//var net:NetLoader = new NetLoader();
			// Set the stream reconnect properties
			//net.reconnectTimeout = 5; // in seconds
			//var url:URLResource = new URLResource(progressive_path);
			
			//var net:RTMPDynamicStreamingNetLoader = new RTMPDynamicStreamingNetLoader();
			//var url:DynamicStreamingResource = new DynamicStreamingResource(progressive_path);
			import flash.filesystem.File;
			
			// perhaps for iOS 
			//var file:File = File.applicationStorageDirectory.resolvePath(videoName); 
			
			var _url:String = File.userDirectory.resolvePath(progressive_path).nativePath;   
			
			_url = "file:///" + _url;
			
			firstElement = new VideoElement(new URLResource( _url ));

			//firstElement = new VideoElement(new URLResource( progressive_path ));
			//mediaFactory = new DefaultMediaFactory();
			//firstElement = mediaFactory.createMediaElement( new URLResource( progressive_path ));
			
			//firstElement.resource = new StreamingURLResource(progressive_path,StreamType.LIVE,NaN,NaN,null,false);
		
			addSingleElementToContainer();
		}
		
		public function setSize(h_size:Number, w_size:Number):void
		{
			height_size = h_size;
			width_size = w_size;
			
			addSingleElementToContainer();
		}
		
		public function addSingleElementToContainer():void
		{
			//the simplified api controller for media
			play = new MediaPlayer();
			play.media =  firstElement;
			
			//the container for managing display and layout
			container_one = new StrobeMediaContainer();
			container_one.addMediaElement( firstElement );
						
			container_one.width = width_size;
		 	container_one.height = height_size;	
		}
		
		public function setContainerOneSize(width_size:Number, height_size:Number):void
		{
			container_one.width = width_size;
			container_one.height = height_size;	
		}
		
		public function getContainerOne():UIComponent
		{
			var component:UIComponent = new UIComponent();
			component.addChild(container_one);
			
			return component;
		}	
	}
}