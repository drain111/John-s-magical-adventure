package events 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NavigationEvent extends Event 
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		
		public var params:Object;
		
		public function NavigationEvent(type:String, _params:Object = null, bubbles:Boolean=false) 
		{
			super(type, bubbles, data);
			this.params = _params;
		}
		
	}

}