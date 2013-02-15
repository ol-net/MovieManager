package events
{
	import flash.events.Event;

	public class NotConnectedEvent extends Event
	{
		public static const NOTCONNECTED:String = "notconnected";
		
		public function NotConnectedEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}