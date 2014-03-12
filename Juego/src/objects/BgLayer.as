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
		private var matrix:Array;
		private var tiles:Array;
		
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
			this.matrix = new Array();
			this.tiles = new Array();
			
			this._sectorX = sectorX;
			this._sectorY = sectorY;
			
			this._type = type + "_";
			
			this._numRows = rows;
			this._numColumns = columns;
			
			if (editable) this._editor = editor;
			else this._editor = null;
			
			this._dim = tileDimension;
			this._layer = layer;
			
			this.matrix = map;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var cont:int = 0;
			
			var actualRow:int = 0;
			var actualColumn:int = 0;
			
			while (cont < matrix.length) 
			{
				var i:int = matrix[cont];
				
				drawTile(i, cont, actualRow, actualColumn, _dim);
				
				actualColumn++;
				cont++;
				
				if (actualColumn == _numColumns ) 
				{
					actualColumn = 0;
					actualRow++;
				}
			}
			
			this.addEventListener(Event.ENTER_FRAME, refreshMap);
			this.addEventListener(Event.ENTER_FRAME, sendTrace);
		}
		
		private function drawTile(numTile:int, index:int, row:int, column:int, dim:int):void {
			this.tiles[index] = new Image(Assets.getAtlas().getTexture(this._type + numTile));
			
			this.tiles[index].x =(_sectorX * (_numColumns * (_dim))) + column * _dim;
			this.tiles[index].y =(_sectorY * (_numRows * (_dim))) + row * _dim;
			
			this.tiles[index].width = _dim + 1;
			this.tiles[index].height = _dim + 1;
			
			this.addChild(tiles[index]);
			
		}
		
		private function refreshMap():void {
			if (this._editor != null && this._editor.changeMapTile ) 
			{
				var index:int = this._editor.Yposition * this._numColumns + this._editor.Xposition;
				this.matrix[index] = this._editor.tileToChange;
				this.tiles[index].texture = Assets.getAtlas().getTexture(this._type + this.matrix[index]);
				this._editor.changeMapTile = false;
			}
			
		}
		
		private function sendTrace():void {
			if (this._editor.sendTrace) 
			{
				trace("Layer " + this._layer + ": " + this.matrix);
				this._editor.sendTrace = false;
			}
		}
		
	}

}