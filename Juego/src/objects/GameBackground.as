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
		
		private var _terrainMap:Array;
		private var _roadsMap:Array;
		private var _objectsAndWallsMap:Array;
		
		private var _editor:Editor;
		
		
		public var tileDimension:int;
		
		public var rows:int;
		public var columns:int;
		
		private var _loaded:Boolean = false;
		
		private var _terrainLayer:BgLayer;
		private var _roadsLayer:BgLayer;
		private var _objectsAndWallsLayer:BgLayer;
		
		public function GameBackground(sectorX:int, sectorY:int, editor:Editor) 
		{
			super();
			
			_sectorX = sectorX;
			_sectorY = sectorY;
			
			_editor = editor;
			
			
			tileDimension = GlobalVariables.TILE_DIMENSIONS;
			
			_editor.editorDim =  tileDimension;
			
			rows = GlobalVariables.ROWS;
			columns = GlobalVariables.COLUMNS;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_terrainMap = new Array();
			createVoidTileMap(_terrainMap, rows, columns, true);
			_terrainLayer = new BgLayer("terrain", _sectorX, _sectorY, 1, rows, columns, tileDimension, _terrainMap, editor, true);
			
			_roadsMap = new Array();
			createVoidTileMap(_roadsMap, rows, columns, false);
			_roadsLayer = new BgLayer("roads", _sectorX, _sectorY, 2, rows, columns, tileDimension, _roadsMap, editor, true);
			
			_objectsAndWallsMap = new Array();
			createVoidTileMap(_objectsAndWallsMap, rows, columns, false);
			_objectsAndWallsLayer = new BgLayer("objectsAndWalls", _sectorX, _sectorY, 3, rows, columns, tileDimension, _objectsAndWallsMap, editor, true);
			
			this.addChild(_terrainLayer);
			this.addChild(_roadsLayer);
			this.addChild(_objectsAndWallsLayer);
			
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
		
		public function get terrainMap():Array 
		{
			return _terrainMap;
		}
		
		public function set terrainMap(value:Array):void 
		{
			_terrainMap = value;
		}
	}
}