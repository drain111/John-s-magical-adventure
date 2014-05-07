package objects 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameForeground extends Sprite 
	{
		
		private var _sectorX:int;
		private var _sectorY:int;
		
		private var _objectsMap:Array;
		private var _treesMap:Array;
		private var _ceilingsMap:Array;
		private var _hitboxesMap:Array;
		
		private var _editor:Editor;
		
		
		public var tileDimension:int;
		
		public var rows:int;
		public var columns:int;
		
		private var _loaded:Boolean = false;
		
		private var _objectsLayer:BgLayer;
		private var _treesLayer:BgLayer;
		private var _ceilingsLayer:BgLayer;
		private var _hitboxesLayer:BgLayer;
		
		public function GameForeground(sectorX:int, sectorY:int, editor:Editor) 
		{
			super();
			
			_sectorX = sectorX;
			_sectorY = sectorY;
			
			_editor = editor;
			
			tileDimension = GlobalVariables.TILE_DIMENSIONS;
			
			_editor.editorDim =  GlobalVariables.TILE_DIMENSIONS;
			
			rows = GlobalVariables.ROWS;
			columns = GlobalVariables.COLUMNS;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_objectsMap = new Array();
			createVoidTileMap(_objectsMap, rows, columns, false);
			_objectsLayer = new BgLayer("objectsAndWalls", _sectorX, _sectorY, 4, rows, columns, tileDimension, _objectsMap, editor, true);
			
			_treesMap = new Array();
			createVoidTileMap(_treesMap, rows, columns, false);
			_treesLayer = new BgLayer("trees", _sectorX, _sectorY, 5, rows, columns, tileDimension, _treesMap, editor, true);
			
			_ceilingsMap = new Array();
			createVoidTileMap(_ceilingsMap, rows, columns, false);
			_ceilingsLayer = new BgLayer("ceilings", _sectorX, _sectorY, 6, rows, columns, tileDimension, _ceilingsMap, editor, true);
			
			_hitboxesMap = new Array;
			createVoidTileMap(_hitboxesMap, rows, columns, false);
			_hitboxesLayer = new BgLayer("hitbox", _sectorX, _sectorY, 7, rows, columns, tileDimension, _hitboxesMap, editor, true);
			
			this.addChild(_objectsLayer);
			this.addChild(_treesLayer);
			this.addChild(_ceilingsLayer);
			this.addChild(_hitboxesLayer);
			
			//this.addChild(editor);
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
		
		public function get objectsMap():Array 
		{
			return _objectsMap;
		}
		
		public function set objectsMap(value:Array):void 
		{
			_objectsMap = value;
		}
		
		public function get treesMap():Array 
		{
			return _treesMap;
		}
		
		public function set treesMap(value:Array):void 
		{
			_treesMap = value;
		}
		
		public function get ceilingsMap():Array 
		{
			return _ceilingsMap;
		}
		
		public function set ceilingsMap(value:Array):void 
		{
			_ceilingsMap = value;
		}
		
		public function get hitboxesLayer():BgLayer 
		{
			return _hitboxesLayer;
		}
		
		public function set hitboxesLayer(value:BgLayer):void 
		{
			_hitboxesLayer = value;
		}
	}
}