package objects 
{
	import flash.geom.Point;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Adri
	 */
	public class Monster extends Sprite 
	{
		private var _health:int;
		private var _monsterArt:Image;
		private var _alreadyhit:Boolean;
		private var _beingtouched:Boolean; //provisional variable desgined for puzzle objects.
		
		private var _tocandopuzle:Boolean = false;
		private var point:Point;

		
		public function Monster() 
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);


		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//recordar crear clase objeto cuando tengas objetos y copiar lo referetne a esto
			this.addEventListener(TouchEvent.TOUCH, puzzles);
			this.addEventListener(Event.ENTER_FRAME, update)

			createMonsterArt();
		}
		
		private function update(e:Event):void 
		{
			if (tocandopuzle == true ){
				this.x = point.x;
				this.y = point.y;
			}
		}
		private function puzzles(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			this.touchable = true;
			this.useHandCursor = true;
			
			try {
			point = touch.getLocation(this.parent);
			if (touch.phase == TouchPhase.BEGAN)
			{
				
				tocandopuzle = true;
			}
			else {
				if (touch.phase == TouchPhase.ENDED) {
					tocandopuzle = false;
				}
			}
			
			}
			catch (e:Error){
				trace("Normal error");
			}
			
		}
		private function createMonsterArt():void
		{
			_monsterArt = new Image(Assets.getAtlas().getTexture("slime"));
			_monsterArt.x = Math.ceil(-_monsterArt.width/2);
			_monsterArt.y = Math.ceil( -_monsterArt.height / 2);
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
			
			this.addChild(_monsterArt);
			
			
			
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
		
		public function get beingtouched():Boolean 
		{
			return _beingtouched;
		}
		
		public function set beingtouched(value:Boolean):void 
		{
			_beingtouched = value;
		}
		
		public function get tocandopuzle():Boolean 
		{
			return _tocandopuzle;
		}
		
		public function set tocandopuzle(value:Boolean):void 
		{
			_tocandopuzle = value;
		}
		
	}

}