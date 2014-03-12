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
		
		public function Camera(object:Image) 
		{
			super();
			
			
			_objectToFollow = object;
			
			this.addEventListener(Event.ENTER_FRAME, updatePosition);
			
		}
		
		private function updatePosition(e:Event):void 
		{
			GlobalVariables.posCameraX = -_objectToFollow.x - _objectToFollow.texture.width/2 + stage.stageWidth/2;
			GlobalVariables.posCameraY = -_objectToFollow.y - _objectToFollow.texture.height/2 + stage.stageHeight/2;
		}
		
		public function get objectToFollow():Image 
		{
			return _objectToFollow;
		}
		
		public function set objectToFollow(value:Image):void 
		{
			_objectToFollow = value;
		}
		
	}

}