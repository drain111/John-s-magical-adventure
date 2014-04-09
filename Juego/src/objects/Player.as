package objects 
{
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import screens.GameWorld;
	import starling.core.Starling;
	import starling.display.MovieClip;

	
	/**
	 * ...
	 * @author Adri
	 */
	public class Player extends Sprite 
	{
		private var healt:int;
		private var magic:Vector.<int>;
		private var _directionx:int;
		private var _directiony:int;
		private var heroArt:MovieClip;
		private var _strength:int;
		private var aux:int;
		

		
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
			directionx = 1;
			directiony = -1;
			magic = new Vector.<int>;
			magic.push(2);
			magic.push(1);
			magic.push(0);
			strength = 10;
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, changeside);
			
			this.addChild(heroArt);
			
			
			
		}
		public function changeside(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.N) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("mage_2");
				directiony = 1;
				aux = this.y;
				while (aux < this.y + 30){
					this.y += 1;
					aux++;
				}
			}
			else{
			if (e.keyCode == Keyboard.M) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("mage_1");
				directiony = -1;
				aux = this.y;
				while (aux > this.y - 30){
					this.y -= 1;
					aux--;
				}
			}
			
			}
		}
		
		public function get directionx():int 
		{
			return _directionx;
		}
		
		public function set directionx(value:int):void 
		{
			_directionx = value;
		}
		
		public function get directiony():int 
		{
			return _directiony;
		}
		
		public function set directiony(value:int):void 
		{
			_directiony = value;
		}
		
		public function get strength():int 
		{
			return _strength;
		}
		
		public function set strength(value:int):void 
		{
			_strength = value;
		}
		
		
	}

}