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
		
		private var _hitbox:Image;
        private var _colliding:Boolean = false;
		
		private var _posx:int;
		private var _posy:int;
		private var _actualimage:int;
		
		private var isRight:Boolean = false;
        private var isLeft:Boolean = false;
        private var isUp:Boolean = false;
        private var isDown:Boolean = false;
		
		private var _lastPosition:Point;
		private var _nextPosition:Point;

		
		public function Player(worldhitbox:Image) 
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
			
			_hitbox = worldhitbox;
			
			_strength = 10;
			_actualimage = 2;
			
			_lastPosition = new Point(0, 0);
			_nextPosition = new Point(0, 0);
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			
			this.addChild(_hitbox);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//this.addEventListener(Event.ENTER_FRAME, update);
			createHeroArt();
		}
		
		public function firstUpdate():void
		{
			if (isUp) _nextPosition.y -= 2;
			else if(isDown) _nextPosition.y += 2;
			else if(isLeft) _nextPosition.x -= 2;
			else if (isRight) _nextPosition.x += 2;
			
			hitbox.x = _nextPosition.x;
			hitbox.y = _nextPosition.y;
		}
		
		public function secondUpdate():void
		{
			if (colliding) 
			{
				if (isUp) _nextPosition.y += 2;
				else if(isDown) _nextPosition.y -= 2;
				else if(isLeft) _nextPosition.x += 2;
				else if (isRight) _nextPosition.x -= 2;
				colliding = false;
				trace("NOT COLLIDING");
			}
			else _lastPosition = _nextPosition;
			
			x = _nextPosition.x;
			y = _nextPosition.y;
		}
		
		private function createHeroArt():void
		{
			heroArt = new MovieClip(Assets.getAtlas().getTextures("Magestb"),10);
			heroArt.x = Math.ceil(-heroArt.width/2);
			heroArt.y = Math.ceil(-heroArt.height/2);
			starling.core.Starling.juggler.add(heroArt);
			
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, changeside);
			this.addEventListener(KeyboardEvent.KEY_UP, release);
			this.addChild(heroArt);
			
			
			
		}
		
		private function release(e:KeyboardEvent):void 
		{
			isUp = false;
			isDown = false;
			isLeft = false;
			isRight = false;
			heroArt.stop();
			if (e.keyCode == Keyboard.X)
			{
				pushtheactualspell();
			}
			
			if (e.keyCode == Keyboard.N ) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("Mage_1");

				
			}
			
			else{
				if (e.keyCode == Keyboard.M) 
				{
					heroArt.texture = Assets.getAtlas().getTexture("Mage_2");

				}
				
				else{
					if (e.keyCode == Keyboard.V) 
					{
						heroArt.texture = Assets.getAtlas().getTexture("Mage_3");
						

					}
					
					else{
						if (e.keyCode == Keyboard.C) 
						{
							
							heroArt.texture = Assets.getAtlas().getTexture("Mage_4");
							
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
				_directiony = -1;
				_directionx = 0;
				isUp = true;
				heroArt.setFrameTexture(0, Assets.getAtlas().getTexture("Mageup0"));
				heroArt.setFrameTexture(1, Assets.getAtlas().getTexture("Mageup1"));
				heroArt.setFrameTexture(2, Assets.getAtlas().getTexture("Mageup2"));
				heroArt.setFrameTexture(3, Assets.getAtlas().getTexture("Mageup3"));
				heroArt.setFrameTexture(4, Assets.getAtlas().getTexture("Mageup4"));
				heroArt.setFrameTexture(5, Assets.getAtlas().getTexture("Mageup5"));
				heroArt.setFrameTexture(6, Assets.getAtlas().getTexture("Mageup6"));
				heroArt.setFrameTexture(7,Assets.getAtlas().getTexture("Mageup7"));
				


		
			}
				else{
					if (e.keyCode == Keyboard.M) 
					{
						_directiony = 1;
						_directionx = 0;
						isDown = true;
						heroArt.setFrameTexture(0, Assets.getAtlas().getTexture("Magedown0"));
						heroArt.setFrameTexture(1, Assets.getAtlas().getTexture("Magedown1"));
						heroArt.setFrameTexture(2, Assets.getAtlas().getTexture("Magedown2"));
						heroArt.setFrameTexture(3, Assets.getAtlas().getTexture("Magedown3"));
						heroArt.setFrameTexture(4, Assets.getAtlas().getTexture("Magedown4"));
						heroArt.setFrameTexture(5, Assets.getAtlas().getTexture("Magedown5"));
						heroArt.setFrameTexture(6, Assets.getAtlas().getTexture("Magedown6"));
						heroArt.setFrameTexture(7,Assets.getAtlas().getTexture("Magedown7"));
						
				
					}
					else
					{
						if (e.keyCode == Keyboard.V) 
						{
							directionx = -1;
							directiony = 0;
							isLeft = true;
							heroArt.setFrameTexture(0, Assets.getAtlas().getTexture("Mageleft0"));
							heroArt.setFrameTexture(1, Assets.getAtlas().getTexture("Mageleft1"));
							heroArt.setFrameTexture(2, Assets.getAtlas().getTexture("Mageleft2"));
							heroArt.setFrameTexture(3, Assets.getAtlas().getTexture("Mageleft3"));
							heroArt.setFrameTexture(4, Assets.getAtlas().getTexture("Mageleft4"));
							heroArt.setFrameTexture(5, Assets.getAtlas().getTexture("Mageleft5"));
							heroArt.setFrameTexture(6, Assets.getAtlas().getTexture("Mageleft6"));
							heroArt.setFrameTexture(7,Assets.getAtlas().getTexture("Mageleft7"));
						}
						else{
							if (e.keyCode == Keyboard.C) 
							{
							_directionx = 1;
							_directiony = 0;
							isRight = true;
							heroArt.setFrameTexture(0, Assets.getAtlas().getTexture("Mageright0"));
							heroArt.setFrameTexture(1, Assets.getAtlas().getTexture("Mageright1"));
							heroArt.setFrameTexture(2, Assets.getAtlas().getTexture("Mageright2"));
							heroArt.setFrameTexture(3, Assets.getAtlas().getTexture("Mageright3"));
							heroArt.setFrameTexture(4, Assets.getAtlas().getTexture("Mageright4"));
							heroArt.setFrameTexture(5, Assets.getAtlas().getTexture("Mageright5"));
							heroArt.setFrameTexture(6, Assets.getAtlas().getTexture("Mageright6"));
							heroArt.setFrameTexture(7,Assets.getAtlas().getTexture("Mageright7"));
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
		
		public function get lastPosition():Point 
		{
			return _lastPosition;
		}
		
		public function set lastPosition(value:Point):void 
		{
			_lastPosition = value;
		}
		
		public function get nextPosition():Point 
		{
			return _nextPosition;
		}
		
		public function set nextPosition(value:Point):void 
		{
			_nextPosition = value;
		}
		
		public function get hitbox():Image 
		{
			return _hitbox;
		}
		
		public function set hitbox(value:Image):void 
		{
			_hitbox = value;
		}
		
		public function get colliding():Boolean 
		{
			return _colliding;
		}
		
		public function set colliding(value:Boolean):void 
		{
			_colliding = value;
		}
		
		
	}

}