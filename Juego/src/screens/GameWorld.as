package screens 
{
	import objects.Player;
	import flash.geom.Point;
	import objects.Camera;
	import objects.Editor;
	import objects.GameBackground;
	import objects.GameFrontground;
	import objects.Particle;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import starling.utils.deg2rad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;


	import starling.core.Starling;


	/**
	 * ...
	 * @author ...
	 */
	public class GameWorld extends Sprite 
	{
		private var backgroundMap:Vector.<GameBackground>;
		private var frontgroundMap:Vector.<GameFrontground>;
		/*Editado hoy*/
		private var loadedBackgroundMaps:Vector.<GameBackground>;
		private var loadedFrontgroundMaps:Vector.<GameFrontground>;
		/*-----------*/
		private var XSectors:int = 30;
		private var YSectors:int = 30;
		private var camera:Camera;
		
		
		private var editor:Editor;
		private var lastSector:Point;
		
		/* trial */

		private var particle:PDParticleSystem;
		private var magicParticlesToAnimate:Vector.<Particle>;
		
		private var player:Player;


		
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
			
			/*Editado hoy*/
			loadedBackgroundMaps = new Vector.<GameBackground>;
			loadedFrontgroundMaps = new Vector.<GameFrontground>;
			/*-----------*/
			
			editor = new Editor( 500 / 36 + 1, 500 / 36 + 1, XSectors, YSectors);
			/*Editado hoy*/
			lastSector = new Point(editor.actualXSector, editor.actualYSector);
			/*-----------*/
			createBackgroundMap(backgroundMap, XSectors, YSectors, editor);
			this.addChild(editor);
			createFrontgroundMap(frontgroundMap, XSectors, YSectors, editor);
			this.camera = new Camera(this.editor.image);
			this.addChild(camera);
			reloadMaps();
			/* todo */
			particle = new PDParticleSystem(XML(new AssetsParticles.ParticleXML()), Texture.fromBitmap(new AssetsParticles.ParticleTexture()));
			Starling.juggler.add(particle);
			particle.x = camera.x;
			particle.y = camera.y;
			particle.scaleX = 1.2;
			particle.scaleY = 1.2;
			this.addChild(particle);
			
			
			/* player  */
			player = new Player();
			player.x = 1;
			player.y = 1;
			this.addChild(player);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
		}
		
	
		
		private function update(e:Event):void 
		{
			this.x = camera.posX;
			this.y = camera.posY;
			
			player.x += 1;
			player.y += 1; 
		
			/*Editado hoy*/
			var actualSector:Point = new Point(editor.actualXSector, editor.actualYSector);
			
			if (actualSector.x != lastSector.x || actualSector.y != lastSector.y){
				lastSector = actualSector;
				reloadMaps();
			}
			/*-----------*/
			
			
			
			animatemagicParticles();
			
		}
		
		/*Editado hoy*/
		private function reloadMaps():void 
		{
			if (loadedBackgroundMaps.length > 0) 
			{
				removeBackground();
				removeFrontground();
				this.removeChild(editor);
				//this.removeChild(jugador);
				//this.removeChild(camera);
			}
			
			var sectors:Vector.<int> = new Vector.<int>;
			sectors.push(returnSectorIndex(lastSector.x - 1, lastSector.y - 1));
			sectors.push(returnSectorIndex(lastSector.x, lastSector.y - 1));
			sectors.push(returnSectorIndex(lastSector.x + 1, lastSector.y - 1));
			sectors.push(returnSectorIndex(lastSector.x - 1, lastSector.y));
			sectors.push(returnSectorIndex(lastSector.x, lastSector.y));
			sectors.push(returnSectorIndex(lastSector.x + 1, lastSector.y));
			sectors.push(returnSectorIndex(lastSector.x - 1, lastSector.y + 1));
			sectors.push(returnSectorIndex(lastSector.x, lastSector.y + 1));
			sectors.push(returnSectorIndex(lastSector.x + 1, lastSector.y + 1));
			
			for (var i:int = 0; i < sectors.length; i++) 
			{
				loadedBackgroundMaps.push(backgroundMap[sectors[i]]);
				loadedFrontgroundMaps.push(frontgroundMap[sectors[i]]);
			}
			for (var j:int = 0; j < loadedBackgroundMaps.length; j++) 
			{
				this.addChild(loadedBackgroundMaps[j]);
			}
			for (var k:int = 0; k < loadedFrontgroundMaps.length; k++) 
			{
				this.addChild(loadedFrontgroundMaps[k]);
			}

			this.addChild(editor);
			//this.addChild(jugador);
			//this.addChild(camera);
			
		}
		
		public function removeFrontground():void {
			for (var i:int = 0; i <loadedFrontgroundMaps.length; i++) 
			{
				this.removeChild(loadedFrontgroundMaps[i]);
			}
			loadedFrontgroundMaps.splice(0, loadedFrontgroundMaps.length);
		}
		
		public function removeBackground():void {
			for (var i:int = 0; i <loadedBackgroundMaps.length; i++) 
			{
				this.removeChild(loadedBackgroundMaps[i]);
			}
			loadedBackgroundMaps.splice(0, loadedBackgroundMaps.length);
		}
		
		private function returnSectorIndex(x:int, y:int):int {
			var XToCalculate:int;
			var YToCalculate:int;
			
			if (x <= 0) XToCalculate = 0;	
			else if (x >= XSectors)	XToCalculate = XSectors - 1;
			else XToCalculate = x;
			
			if (y<= 0) YToCalculate = 0;
			else if (y >= YSectors) YToCalculate = YSectors - 1;
			else YToCalculate = y;
			
			return XSectors * XToCalculate + YToCalculate;
		}
		/*-----------*/
		
		public function initialize():void {
			this.visible = true;
			
			
			magicParticlesToAnimate = new Vector.<Particle>();
			this.addEventListener(TouchEvent.TOUCH, createparticle);
			
		}
		
		private function createparticle(e:TouchEvent):void {
			var touch:Touch = e.getTouch(this);
			if (touch.phase == TouchPhase.MOVED)
			{

				var localPos:Point = touch.getLocation(this);
				createMagicParticles(localPos);
			}
			
		
			
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
					//this.addChild(map[cont]);
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
					//this.addChild(map[cont]);
					contY++;
					cont++;
				}
				contX++;
			}
		}
		
		private function createMagicParticles(itemToTrack:Point):void {
			
			var count:int = 5;
			
			while (count > 0)
			{
				count--;
				
				var MagicParticle:Particle = new Particle();
				this.addChild(MagicParticle);
				
				MagicParticle.x = itemToTrack.x;
				MagicParticle.y = itemToTrack.y;
				
				MagicParticle.speedX = Math.random() * 2 + 1;
				MagicParticle.speedY = Math.random() * 5;
				MagicParticle.spin = Math.random() * 15;
				MagicParticle.scaleX = MagicParticle.scaleY = Math.random() * 0.3 + 0.3;
				
				magicParticlesToAnimate.push(MagicParticle);
			}
		}
		
		private function animatemagicParticles():void {
			for (var i:uint = 0; i < magicParticlesToAnimate.length; i++ )
			{
				var magicParticleToTrack:Particle = magicParticlesToAnimate[i];
				
				if (magicParticleToTrack)
				{
					magicParticleToTrack.scaleX -= 0.03;
					magicParticleToTrack.scaleY = magicParticleToTrack.scaleX;
					
					magicParticleToTrack.y -= magicParticleToTrack.speedY;
					magicParticleToTrack.speedY -= magicParticleToTrack.speedY * 0.2;
					
					magicParticleToTrack.x += magicParticleToTrack.speedX;
					magicParticleToTrack.speedX--;
					
					magicParticleToTrack.rotation += deg2rad(magicParticleToTrack.spin);
					magicParticleToTrack.spin *= 1.1;
					
					if (magicParticleToTrack.scaleY <= 0.02)
					{
						magicParticlesToAnimate.splice(i, 1);
						this.removeChild(magicParticleToTrack);
						magicParticleToTrack = null;
					}
				}
			}
		}
		
	}

}