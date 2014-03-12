package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.hires.debug.Stats;
	import screens.GameWorld;
	import starling.core.Starling;

	[SWF(frameRate = "60", width = "500", height = "500", backgroundColor = "0x333333")]
	
	/**
	 * ...
	 * @author Yo
	 */
	public class Main extends Sprite 
	{
		private var stats:Stats;
		private var starling:Starling;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stats = new Stats();
			addChild(stats);
			
			starling = new Starling(Game, stage);
			starling.antiAliasing = 0;
			starling.start();
		}
		
	}
	
}