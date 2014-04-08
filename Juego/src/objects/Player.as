package objects 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	/**
	 * ...
	 * @author Adri
	 */
	public class Player extends Sprite 
	{
		private var healt:int;
		private var magic:Vector.<String>;
		private var direction:int;
		private var heroArt:MovieClip;
		
		public function Player() 
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createHeroArt();
		}
		
		private function createHeroArt():void
		{
			heroArt = new MovieClip(Assets.getAtlas().getTextures("mage_" ), 20);
			heroArt.x = Math.ceil(-heroArt.width/2);
			heroArt.y = Math.ceil(-heroArt.height/2);
			//starling.core.Starling.juggler.add(heroArt);
			direction = 1;
			this.addEventListener(KeyboardEvent.KEY_DOWN, changeside);
			this.addChild(heroArt);
			
			
		}
		public function changeside(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.N) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("mage_2");
				direction = 0;
			}
			else{
			if (e.keyCode == Keyboard.M) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("mage_1");
				direction = 1;
			}
			}
			
		}
	}

}