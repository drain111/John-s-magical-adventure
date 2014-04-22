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
		private var _health:int;
		private var _magic:Vector.<int>;
		private var _directionx:int;
		private var _directiony:int;
		private var _heroArt:MovieClip;
		private var _strength:int;
        
		
		private var _posx:int;
		private var _posy:int;
		private var _actualimage:int;
		
		private var isRight:Boolean = false;
        private var isLeft:Boolean = false;
        private var isUp:Boolean = false;
        private var isDown:Boolean = false;

		
		public function Player() 
		{
			super();

			
			_health = 100;
			_directionx = 0;
			_directiony = 1;
			_magic = new Vector.<int>;
			_magic.push(3);
			_magic.push(2);
			_magic.push(1);
			_magic.push(0);
			
			_strength = 10;
			_actualimage = 2;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, update);
			createHeroArt();
		}
		private function update(event:Event):void
		{
			if (isUp) y -= 2;
			else if(isDown) y += 2;
			else if(isLeft) x -= 2;
			else if (isRight) x += 2;
		}
		private function createHeroArt():void
		{
			heroArt = new MovieClip(Assets.getAtlas().getTextures("Magonabaj" ),5);
			heroArt.x = Math.ceil(-heroArt.width/2);
			heroArt.y = Math.ceil(-heroArt.height/2);
			starling.core.Starling.juggler.add(heroArt);
			
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, changeside);
			this.addEventListener(KeyboardEvent.KEY_UP, release);
			this.addChild(heroArt);
			
			
			
		}
		
		private function release(e:KeyboardEvent):void 
		{
			heroArt.stop();
			if (e.keyCode == Keyboard.X)
			{
				pushtheactualspell();
			}
			
			if (e.keyCode == Keyboard.N ) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("Mage_1");

				isUp = false;
			}
			
			else{
				if (e.keyCode == Keyboard.M) 
				{
					heroArt.texture = Assets.getAtlas().getTexture("Mage_2");

					isDown = false;
				}
				
				else{
					if (e.keyCode == Keyboard.V) 
					{
						heroArt.texture = Assets.getAtlas().getTexture("Mage_3");
						
						isLeft = false;
					}
					
					else{
						if (e.keyCode == Keyboard.C) 
						{
							
							heroArt.texture = Assets.getAtlas().getTexture("Mage_4");
							
							isRight = false;
						}
					}
				}
			}
		}
		
		public function changeside(e:KeyboardEvent):void
		{
			heroArt.play();
			if (e.keyCode == Keyboard.N ) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("Mage_1");
				_directiony = -1;
				_directionx = 0;
				isUp = true;
				


		
			}
				else{
					if (e.keyCode == Keyboard.M) 
					{
						_directiony = 1;
						_directionx = 0;
						isDown = true;
						heroArt.setFrameTexture(0, Assets.getAtlas().getTexture("Magonabaj0"));
						heroArt.setFrameTexture(1, Assets.getAtlas().getTexture("Magonabaj1"));
						heroArt.setFrameTexture(2, Assets.getAtlas().getTexture("Magonabaj2"));
						heroArt.setFrameTexture(3, Assets.getAtlas().getTexture("Magonabaj3"));
						heroArt.setFrameTexture(4, Assets.getAtlas().getTexture("Magonabaj4"));
						heroArt.setFrameTexture(5, Assets.getAtlas().getTexture("Magonabaj5"));
						heroArt.setFrameTexture(6, Assets.getAtlas().getTexture("Magonabaj6"));
						heroArt.setFrameTexture(7,Assets.getAtlas().getTexture("Magonabaj7"));
						
				
					}
					else
					{
						if (e.keyCode == Keyboard.V) 
						{
							heroArt.texture = Assets.getAtlas().getTexture("Mage_3");
							directionx = -1;
							directiony = 0;
							isLeft = true;
						}
						else{
							if (e.keyCode == Keyboard.C) 
							{
							heroArt.texture = Assets.getAtlas().getTexture("Mage_4");

							_directionx = 1;
							_directiony = 0;
							isRight = true;
							}
						}
					}
				}
	
		}
		public function  obtainactualspell():int
		{
			return _magic[0];
		}
		public function pushtheactualspell():void
		{
				var aux:int = 0;
				aux = _magic.pop();
				_magic.unshift(aux);
			
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