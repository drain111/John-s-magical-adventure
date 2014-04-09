package objects 
{
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.events.Event;
	import flash.geom.Point;
	import objects.Player;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Camera extends Sprite 
	{
		
		private var _objectToFollow:Player;
		private var _posX:int;
		private var _posY:int;
		
		
		public function Camera(object:Player) 
		{
			super();
			
			_objectToFollow = object; 
			_posX = object.x;
			_posY = object.y;
			
			this.addEventListener(Event.ENTER_FRAME, updatePosition);
			
		}
		
		private function updatePosition(e:Event):void 
		{
			if (_objectToFollow != null) 
			{
				_posX = - _objectToFollow.x - 32/2 + stage.stageWidth/2;
				_posY = - _objectToFollow.y - 64/2 + stage.stageHeight/2;
			}
		}
		
		public function get objectToFollow():Player
		{
			return _objectToFollow;
		}
		
		public function set objectToFollow(value:Player):void 
		{
			_objectToFollow = value;
		}
		
		public function get posX():int 
		{
			return _posX;
		}
		
		public function set posX(value:int):void 
		{
			_posX = value;
		}
		
		public function get posY():int 
		{
			return _posY;
		}
		
		public function set posY(value:int):void 
		{
			_posY = value;
		}
		
	}

}