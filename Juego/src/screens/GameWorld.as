package screens 
{
	import flash.geom.Rectangle;
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
	import objects.Monster;


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
		
		
		private var player:Player;
		
		private var magicParticlesToAnimate:Vector.<Particle>
		
		private var slime:Monster;
		



		
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
			
			var particles:PDParticleSystem = new PDParticleSystem(XML(new AssetsParticles.ParticleXML()), Texture.fromBitmap(new AssetsParticles.ParticleTexture()));
			Starling.juggler.add(particle);
			particles.x = -100;
			particles.y = -100;
			particles.scaleX = 1.2;
			particles.scaleY = 1.2;
			this.addChild(particles);
			
			
			magicParticlesToAnimate = new Vector.<Particle>();
			
			
			
			
			/* player  */
			player = new Player();
			player.x = 1;
			player.y = 1;
			this.addChild(player);
			
			slime = new Monster();
			slime.x = player.x + 40;
			slime.y = player.y + 100;
			this.addChild(slime);
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, attack);

			this.addEventListener(Event.ENTER_FRAME, update);
			
		}
		
	
		
		private function update(e:Event):void 
		{
			this.x = camera.posX;
			this.y = camera.posY;
			
			animatemagicParticles();
			
			 
			
			slime.x = player.x + 40;
			slime.y = player.y + 100;
		
			/*Editado hoy*/
			var actualSector:Point = new Point(editor.actualXSector, editor.actualYSector);
			
			if (actualSector.x != lastSector.x || actualSector.y != lastSector.y){
				lastSector = actualSector;
				reloadMaps();
			}
			if (slime.health <= 0) this.removeChild(slime);
			
			/*-----------*/
						
		}
		
		/*Editado hoy*/
		private function reloadMaps():void 
		{
			if (loadedBackgroundMaps.length > 0) 
			{
				removeBackground();
				removeFrontground();
				this.removeChild(editor);
				//this.removeChild(player);
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
			//this.addChild(player);
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
		
		
		public function attack(e:KeyboardEvent):void
		{
			
			if (e.keyCode == Keyboard.B) {
				var localPos:Point = new Point(((player.width + player.pivotX) / 2 + 100)* player.directionx, ((player.height + player.pivotY)+100)*player.directiony);
				createMagicParticles(localPos);
			}
			
		
		}
		
		public function createMagicParticles(itemToTrack:Point):void {
			
			var count:int = 100;
			
			while (count > 0)
			{
				count--;
				
				var particle:Particle = new Particle();
				this.addChild(particle);
				particle.x = itemToTrack.x;
				particle.y = itemToTrack.y;
				
				particle.speedX = Math.random() * 2 + 1;
				particle.speedY = Math.random() * 5;
				particle.spin = Math.random() * 15;
				particle.scaleX = particle.scaleY = Math.random() * 0.3 + 0.3;
				
				magicParticlesToAnimate.push(particle);
			}
		}
		
		private function animatemagicParticles():void {
			for (var i:uint = 0; i < magicParticlesToAnimate.length; i++ )
			{
				var magicParticleToTrack:Particle = magicParticlesToAnimate[i];
				
				
				if (magicParticleToTrack)
				{
					var rectangle:Rectangle = new Rectangle(magicParticleToTrack.x, magicParticleToTrack.y, magicParticleToTrack.width, magicParticleToTrack.height);
					magicParticleToTrack.scaleX -= 0.01;
					magicParticleToTrack.scaleY = magicParticleToTrack.scaleX;
					
					magicParticleToTrack.y = magicParticleToTrack.y;
					rectangle.y = magicParticleToTrack.y;
					magicParticleToTrack.speedY -= magicParticleToTrack.speedY * 0.2;
					
					magicParticleToTrack.x = (magicParticleToTrack.x - 10) ^ 2 ;
					rectangle.x = magicParticleToTrack.x;
					magicParticleToTrack.speedX--;
					
					magicParticleToTrack.rotation += deg2rad(magicParticleToTrack.spin);
					magicParticleToTrack.spin *= 1.1;
					if (rectangle.intersects(slime.bounds)) slime.health -= player.strength;
										
					if (magicParticleToTrack.scaleY <= 0.01)
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
