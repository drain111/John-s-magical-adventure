package objects 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameFrontground extends Sprite 
	{
		
		private var _sectorX:int;
		private var _sectorY:int;
		
		private var terrainMap:Array;
		private var roadsMap:Array;
		private var objectsAndWallsMap:Array;
		
		private var _editor:Editor;
		
		
		public var tileDimension:int;
		
		public var rows:int;
		public var columns:int;
		
		private var loaded:Boolean = false;
		
		private var terrainLayer:BgLayer;
		private var roadsLayer:BgLayer;
		private var objectsAndWallsLayer:BgLayer;
		
		public function GameFrontground(sectorX:int, sectorY:int, editor:Editor) 
		{
			super();
			
			_sectorX = sectorX;
			_sectorY = sectorY;
			
			_editor = editor;
			
			
			tileDimension = 36;
			
			_editor.editorDim =  tileDimension;
			
			rows = 500 / tileDimension + 1;
			columns = 500 / tileDimension + 1;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			terrainMap = new Array();
			createVoidTileMap(terrainMap, rows, columns, false);
			terrainLayer = new BgLayer("terrain", _sectorX, _sectorY, 4, rows, columns, tileDimension, terrainMap, editor, true);
			
			roadsMap = new Array();
			createVoidTileMap(roadsMap, rows, columns, false);
			roadsLayer = new BgLayer("terrain", _sectorX, _sectorY, 5, rows, columns, tileDimension, roadsMap, editor, true);
			
			objectsAndWallsMap = new Array();
			createVoidTileMap(objectsAndWallsMap, rows, columns, false);
			objectsAndWallsLayer = new BgLayer("terrain", _sectorX, _sectorY, 6, rows, columns, tileDimension, objectsAndWallsMap, editor, true);
			
			this.addChild(terrainLayer);
			this.addChild(roadsLayer);
			this.addChild(objectsAndWallsLayer);
			
			this.addChild(editor);
		}
		
		private static function createVoidTileMap(map:Array, rows:int, columns:int, visible:Boolean):void {
			
			for (var i:int = 0; i < rows * columns; i++) 
			{
				if (visible) 
				{
					map.push(1);
				}
				else map.push(0);
				
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