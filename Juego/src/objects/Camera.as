package objects 
{
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Camera extends Sprite 
	{
		
		private var _objectToFollow:Image;
		private var _posX:int;
		private var _posY:int;
		
		public function Camera(object:Image) 
		{
			super();
			
			
			_objectToFollow = object;
			
			this.addEventListener(Event.ENTER_FRAME, updatePosition);
			
		}
		
		private function updatePosition(e:Event):void 
		{
			if (_objectToFollow != null) 
			{
				_posX = -_objectToFollow.x - _objectToFollow.texture.width/2 + stage.stageWidth/2;
				_posY = -_objectToFollow.y - _objectToFollow.texture.height/2 + stage.stageHeight/2;
			}
		}
		
		public function get objectToFollow():Image 
		{
			return _objectToFollow;
		}
		
		public function set objectToFollow(value:Image):void 
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