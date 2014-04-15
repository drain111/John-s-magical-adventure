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
		
		private var objectsMap:Array;
		private var treesMap:Array;
		private var ceilingsMap:Array;
		
		private var _editor:Editor;
		
		
		public var tileDimension:int;
		
		public var rows:int;
		public var columns:int;
		
		private var loaded:Boolean = false;
		
		private var objectsLayer:BgLayer;
		private var treesLayer:BgLayer;
		private var ceilingsLayer:BgLayer;
		
		public function GameForeground(sectorX:int, sectorY:int, editor:Editor) 
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
			
			objectsMap = new Array();
			createVoidTileMap(objectsMap, rows, columns, false);
			objectsLayer = new BgLayer("terrain", _sectorX, _sectorY, 4, rows, columns, tileDimension, objectsMap, editor, true);
			
			treesMap = new Array();
			createVoidTileMap(treesMap, rows, columns, false);
			treesLayer = new BgLayer("terrain", _sectorX, _sectorY, 5, rows, columns, tileDimension, treesMap, editor, true);
			
			ceilingsMap = new Array();
			createVoidTileMap(ceilingsMap, rows, columns, false);
			ceilingsLayer = new BgLayer("terrain", _sectorX, _sectorY, 6, rows, columns, tileDimension, ceilingsMap, editor, true);
			
			this.addChild(objectsLayer);
			this.addChild(treesLayer);
			this.addChild(ceilingsLayer);
			
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