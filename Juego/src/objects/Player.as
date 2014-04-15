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
	import starling.animation.DelayedCall;

	
	/**
	 * ...
	 * @author Adri
	 */
	public class Player extends Sprite 
	{
		private var health:int;
		private var magic:Vector.<int>;
		private var _directionx:int;
		private var _directiony:int;
		private var _heroArt:MovieClip;
		private var _strength:int;
		private var posx:int;
		private var posy:int;
		private var actualimage:int;
		

		
		public function Player() 
		{
			super();
			health = 100;
			directionx = 0;
			directiony = 1;
			magic = new Vector.<int>;
			magic.push(2);
			magic.push(1);
			magic.push(0);
			strength = 10;
			actualimage = 2;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createHeroArt();
		}
		
		private function createHeroArt():void
		{
			heroArt = new MovieClip(Assets.getAtlas().getTextures("Mage_2" ),1);
			heroArt.x = Math.ceil(-heroArt.width/2);
			heroArt.y = Math.ceil(-heroArt.height/2);
			starling.core.Starling.juggler.add(heroArt);
			
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, changeside);
			this.addEventListener(Event.ENTER_FRAME, update);
			this.addChild(heroArt);
			
			
			
		}
		
		
		
		private function update(e:Event):void 
		{
			
		}
		public function changeside(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.N ) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("Mage_1");
				directiony = -1;
				directionx = 0;


		
			}
			else{
			if (e.keyCode == Keyboard.M) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("Mage_2");
				directiony = 1;
				directionx = 0;
				
			}
			else{
			if (e.keyCode == Keyboard.V) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("Mage_3");
				directionx = -1;
				directiony = 0;

				
			}
			else{
			if (e.keyCode == Keyboard.C) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("Mage_4");
				directionx = 1;
				directiony = 0;
				
				
			}
			}
			}
			}
			
		}
		public function  obtainactualspell():int
		{
			return magic[0];
		}
		public function pushtheactualspell():void
		{
				var aux:int = 0;
				aux = magic.pop();
				magic.unshift(aux);
			
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
		
		public function get heroArt():MovieClip 
		{
			return _heroArt;
		}
		
		public function set heroArt(value:MovieClip):void 
		{
			_heroArt = value;
		}
		
		
	}

}