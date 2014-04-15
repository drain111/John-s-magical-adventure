package objects 
{
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Adri
	 */
	public class Monster extends Sprite 
	{
		private var _health:int;
		private var MonsterArt:Image;
		private var _alreadyhit:Boolean;
		
		public function Monster() 
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);

		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createMonsterArt();
		}
		
		private function createMonsterArt():void
		{
			MonsterArt = new Image(Assets.getAtlas().getTexture("slime"));
			MonsterArt.x = Math.ceil(-MonsterArt.width/2);
			MonsterArt.y = Math.ceil( -MonsterArt.height / 2);
			health = 100;
			alreadyhit = false;
			//starling.core.Starling.juggler.add(heroArt);
			/*directionx = 1;
			directiony = -1;
			magic = new Vector.<int>;
			magic.push(2);
			magic.push(1);
			magic.push(0);
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, changeside);*/
			
			this.addChild(MonsterArt);
			
			
			
		}
		public function get health():int 
		{
			return _health;
		}
		
		public function set health(value:int):void 
		{
			_health = value;
		}
		
		public function get alreadyhit():Boolean 
		{
			return _alreadyhit;
		}
		
		public function set alreadyhit(value:Boolean):void 
		{
			_alreadyhit = value;
		}
		
	}

}