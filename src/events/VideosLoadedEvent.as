package events {
	
	import flash.events.Event;
	
	public class  VideosLoadedEvent extends Event 
	{
		public static const VIDEOSLOADED: String = "videosLoaded";
		
		public function VideosLoadedEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)	
		{
			super(type, bubbles, cancelable);
		}
	}
}