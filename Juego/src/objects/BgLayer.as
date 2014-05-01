package objects 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BgLayer extends Sprite 
	{	
		private var _matrix:Array;
		private var _tiles:Array;
		
		private var _sectorX:int;
		private var _sectorY:int;
		
		private var _layer:int;
		
		private var _editor:Editor;
		
		private var _numRows:int;
		private var _numColumns:int;
		
		private var _type:String;
		
		private var _dim:int;
		
		public function BgLayer(type:String, sectorX:int, sectorY:int, layer:int, rows:int, columns:int, tileDimension:int, map:Array, editor:Editor, editable:Boolean = false) 
		{
			super();
			this._matrix = new Array();
			this._tiles = new Array();
			
			this._sectorX = sectorX;
			this._sectorY = sectorY;
			
			this._type = type + "_";
			
			this._numRows = rows;
			this._numColumns = columns;
			
			if (editable) this._editor = editor;
			else this._editor = null;
			
			this._dim = tileDimension;
			this._layer = layer;
			
			this._matrix = map;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			selectLayerTiles();
			
			this.addEventListener(Event.ENTER_FRAME, refreshMap);
			this.addEventListener(Event.ENTER_FRAME, sendTrace);
		}	
		
		public function selectLayerTiles():void
		{
			var cont:int = 0;
			
			var actualRow:int = 0;
			var actualColumn:int = 0;
			
			while (cont < _matrix.length) 
			{
				var i:int = _matrix[cont];
				
				drawTile(i, cont, actualRow, actualColumn, _dim);
				
				actualColumn++;
				cont++;
				
				if (actualColumn == _numColumns ) 
				{
					actualColumn = 0;
					actualRow++;
				}
			}
			
			
		}
		
		private function drawTile(numTile:int, index:int, row:int, column:int, dim:int):void {
			if (numTile != 0) 
			{
				this._tiles[index] = new Image(Assets.getAtlas().getTexture(this._type + numTile));
			}
			else 
			{
				this._tiles[index] = new Image(Assets.getAtlas().getTexture(this._type + 1));
				this._tiles[index].visible = false;
			}
			
			this._tiles[index].x =(_sectorX * (_numColumns * (_dim))) + column * _dim;
			this._tiles[index].y =(_sectorY * (_numRows * (_dim))) + row * _dim;
			
			this._tiles[index].width = _dim + 1;
			this._tiles[index].height = _dim + 1;
			
			this.addChild(_tiles[index]);
			
		}
		
		private function refreshMap():void {
			if (this._editor != null && this._editor.actualXSector == this._sectorX && this._editor.actualYSector == this._sectorY && this._editor.changeMapTile && this._editor.layer == this._layer) 
			{
				var index:int = (this._editor.sectorYPos * this._numColumns) + this._editor.sectorXPos;
				_matrix[index] = _editor.tileToChange;
				if (this._editor.tileToChange != 0) 
				{
					this._tiles[index].visible = true;
					this._tiles[index].texture = Assets.getAtlas().getTexture(this._type + this._matrix[index]);
				}
				else 
				{
					this._tiles[index].visible = false;
					this._tiles[index].texture = Assets.getAtlas().getTexture(this._type + 1);
				}
				this._editor.changeMapTile = false;
			}
			
		}
		
		private function sendTrace():void {
			if (this._editor.sendTrace) 
			{
				trace("Layer " + this._layer + ": " + this._matrix);
				var index:int = (this._editor.Yposition * this._numColumns) / (this._sectorY + 1) + this._editor.Xposition / (this._sectorX + 1);
				trace();
				this._editor.sendTrace = false;
			}
		}
		private function loadLayer():void {
			for (var i:int = 0; i < _matrix.length; i++) 
			{
				if (_matrix[i] != 0) 
				{
					this._tiles[i].visible = true;
				}
			}
		}
		private function saveLayer():void {
			for (var i:int = 0; i < _tiles.length; i++) 
			{
				this._tiles[i].visible = false;
			}
		}
		
		public function get matrix():Array 
		{
			return _matrix;
		}
		
		public function set matrix(value:Array):void 
		{
			_matrix = value;
		}
	}
}