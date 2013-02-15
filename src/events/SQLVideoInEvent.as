package events
{
	import flash.events.Event;
	
	public class SQLVideoInEvent extends Event
	{
		public static const VIDEOIN: String = "videoin";
		
		public function SQLVideoInEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}