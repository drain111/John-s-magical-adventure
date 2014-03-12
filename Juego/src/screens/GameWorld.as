package screens 
{
	import objects.Camera;
	import objects.Editor;
	import objects.GameBackground;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class GameWorld extends Sprite 
	{
		private var sector_0_0:GameBackground;
		private var sector_1_0:GameBackground;
		private var sector_0_1:GameBackground;
		private var sector_1_1:GameBackground;
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
			editor = new Editor();
			sector_0_0 = new GameBackground(0, 0, editor);
			this.addChild(sector_0_0);
			sector_1_0 = new GameBackground(1, 0, editor);
			this.addChild(sector_1_0);
			sector_0_1 = new GameBackground(0, 1, editor);
			this.addChild(sector_0_1);
			sector_1_1 = new GameBackground(1, 1, editor);
			this.addChild(sector_1_1);
			this.addChild(editor);
			this.camera = new Camera(sector_0_0.editor.image);
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
	}

}