package objects 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameBackground extends Sprite 
	{
		private var _sectorX:int;
		private var _sectorY:int;
		
		private var tileMap:Array;
		
		private var _editor:Editor;
		
		
		public var tileDimension:int;
		
		public var rows:int;
		public var columns:int;
		
		
		private var bgLayer1:BgLayer;
		
		public function GameBackground(sectorX:int, sectorY:int, editor:Editor) 
		{
			super();
			
			_sectorX = sectorX;
			_sectorY = sectorY;
			
			_editor = editor;
			
			
			tileDimension = 35;
			
			_editor.editorDim =  tileDimension;
			
			rows = 600 / tileDimension ;//+// 1;
			columns = 800 / tileDimension ;// + 1;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			tileMap = new Array();
			createVoidTileMap(tileMap, rows, columns);
			bgLayer1 = new BgLayer("terrain", _sectorX, _sectorY, 1, rows, columns, tileDimension, tileMap, editor, true);
			this.addChild(bgLayer1);
			
			
			this.addChild(editor);
		}
		
		private static function createVoidTileMap(map:Array, rows:int, columns:int):void {
			for (var i:int = 0; i < rows * columns; i++) 
			{
				map.push(1);
			}
		}
		
		public function get editor():Editor 
		{
			return _editor;
		}
		
		public function set editor(value:Editor):void 
		{
			_editor = value;
		}
	}
}