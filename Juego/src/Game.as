package  
{
	import events.NavigationEvent;
	import screens.GameWorld;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Yo
	 */
	
	
	public class Game extends Sprite 
	{
		private var screenInGame:GameWorld;
		
		public function Game() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,  onAddedStage);
		}
		
		private function onAddedStage(event:Event):void {
			trace("Starling iniciado.");
			
			screenInGame = new GameWorld();
			screenInGame.initialize();
			this.addChild(screenInGame);
		}
	}

}