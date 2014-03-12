package objects 
{
	import flash.ui.Keyboard;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Editor extends Sprite 
	{
		private var _realXpos:int;
		private var _realYpos:int;
		
		private var _Xpos:int;
		private var _Ypos:int;
		
		private var _index:int;
		
		private var _changeMapTile:Boolean;
		private var _sendTrace:Boolean;
		
		private var _tileSelected:int;
		private var _lastTileSelected:int;
		private var _editorDim:int;
		
		private var _image:Image;
		
		public function Editor() 
		{
			super();
			
			this._realXpos = 0;
			this._realYpos = 0;
			this._Xpos = 0;
			this._Ypos = 0;
			this._index = 0;
			this._tileSelected = 2;
			this._changeMapTile = false;
			this._sendTrace = false;
			this._lastTileSelected = this._tileSelected;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initializeEditor);
		}
		
		
		
		private function initializeEditor():void {
			this.removeEventListener(Event.ADDED_TO_STAGE, initializeEditor);
			
			this._image = new Image(Assets.getAtlas().getTexture("terrain_" + _tileSelected));
			this._image.x = _realXpos;
			this._image.y = _realYpos;
			this._image.height = _editorDim;
			this._image.width = _editorDim;
			this.addChild(_image);
			
			this.addEventListener(Event.ENTER_FRAME, refresh);
		}
		
		private function refresh():void {
			this.addEventListener(KeyboardEvent.KEY_DOWN, moveEditor);
			this._image.x = _realXpos;
			this._image.y = _realYpos;
			
			if (this._tileSelected != this._lastTileSelected) 
			{
				this.changeImage();
			}
		}
		
		private function moveEditor(e:KeyboardEvent):void {
			
			if (e.keyCode == Keyboard.W && this._Ypos > 0) 
			{
				this._Ypos -= 1;
			}
			if (e.keyCode == Keyboard.S && this._Ypos < stage.stageHeight / _editorDim - 2) 
			{
				this._Ypos += 1;
			}
			if (e.keyCode == Keyboard.A && this._Xpos > 0) 
			{
				this._Xpos -= 1;
			}
			if (e.keyCode == Keyboard.D && this._Xpos < stage.stageWidth / _editorDim - 2) 
			{
				this._Xpos += 1;
			}
			
			if (e.keyCode == Keyboard.Q) 
			{
				if (this._tileSelected > 1) this._tileSelected -= 1;
				else this._tileSelected = 18;
			}
			if (e.keyCode == Keyboard.E) 
			{
				if (this._tileSelected < 18) this._tileSelected += 1;
				else this._tileSelected = 1;
			}
			
			if (e.keyCode == Keyboard.P) 
			{
				this._changeMapTile = true;
			}
			
			if (e.keyCode == Keyboard.T) 
			{
				this._sendTrace = true;
			}
			
			this._realXpos = _Xpos * _editorDim;
			this._realYpos = _Ypos * _editorDim;
		}
		
		private function changeImage():void {
			this._image.texture = Assets.getAtlas().getTexture("terrain_" + _tileSelected);
			this._lastTileSelected = this._tileSelected;
		}
		
		public function get changeMapTile():Boolean {
			return this._changeMapTile;
		}
		
		public function set changeMapTile(change:Boolean):void {
			this._changeMapTile = change;
		}
		
		public function get sendTrace():Boolean {
			return this._sendTrace;
		}
		
		public function set sendTrace(sendTrace:Boolean):void {
			this._sendTrace = sendTrace;
		}
		
		public function get tileToChange():int {
			return this._tileSelected;
		}
		
		public function set tileToChange(tile:int):void {
			this._tileSelected = tile;
		}
		
		public function get Xposition():int {
			return this._Xpos;
		}
		public function set Xposition(x:int):void {
			this._Xpos = x;
		}
		
		public function get Yposition():int {
			return this._Ypos;
		}
		public function set Yposition(y:int):void {
			this._Ypos = y;
		}
		
		public function get image():Image 
		{
			return _image;
		}
		
		public function set image(value:Image):void 
		{
			_image = value;
		}
		
		public function get editorDim():int 
		{
			return _editorDim;
		}
		
		public function set editorDim(value:int):void 
		{
			_editorDim = value;
		}
	}

}