package screens 
{
	import objects.Camera;
	import objects.Editor;
	import objects.GameBackground;
	import objects.GameFrontground;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class GameWorld extends Sprite 
	{
		private var backgroundMap:Vector.<GameBackground>;
		private var frontgroundMap:Vector.<GameFrontground>;
		private var XSectors:int = 2;
		private var YSectors:int = 2;
		private var camera:Camera;
		
		private var editor:Editor;
		
		public function GameWorld() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawGame();
		}
		
		private function drawGame():void {
			backgroundMap = new Vector.<GameBackground>;
			frontgroundMap = new Vector.<GameFrontground>;
			editor = new Editor( 500 / 36 + 1, 500 / 36 + 1, XSectors, YSectors);
			createBackgroundMap(backgroundMap, XSectors, YSectors, editor);
			this.addChild(editor);
			createFrontgroundMap(frontgroundMap, XSectors, YSectors, editor);
			this.camera = new Camera(this.editor.image);
			this.addChild(camera);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void 
		{
			this.x = GlobalVariables.posCameraX;
			this.y = GlobalVariables.posCameraY;
		}
		
		public function initialize():void {
			this.visible = true;
		}
		
		public function disposeTemporarily():void {
			this.visible = false;
		}
		
		public function createBackgroundMap(map:Vector.<GameBackground>,numXSectors:int, numberYSectors:int, editor:Editor):void {
			
			var cont:int = 0;
			var contX:int = 0;
			
			while (cont < numXSectors * numberYSectors) 
			{
				var contY:int = 0;
				
				while (contY < numberYSectors) 
				{
					map.push(new GameBackground(contX, contY, editor));
					this.addChild(map[cont]);
					contY++;
					cont++;
				}
				contX++;
			}
		}
		
		public function createFrontgroundMap(map:Vector.<GameFrontground>,numXSectors:int, numberYSectors:int, editor:Editor):void {
			
			var cont:int = 0;
			var contX:int = 0;
			
			while (cont < numXSectors * numberYSectors) 
			{
				var contY:int = 0;
				
				while (contY < numberYSectors) 
				{
					map.push(new GameFrontground(contX, contY, editor));
					this.addChild(map[cont]);
					contY++;
					cont++;
				}
				contX++;
			}
		}
	}

}