package screens 
{
	import flash.geom.Rectangle;
	import objects.Player;
	import flash.geom.Point;
	import objects.Camera;
	import objects.Editor;
	import objects.GameBackground;
	import objects.GameForeground;
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
	import starling.display.Image;

	
	


	import starling.core.Starling;


	/**
	 * ...
	 * @author ...
	 */
	public class GameWorld extends Sprite 
	{
		public var attacking:Boolean;
		private var backgroundMap:Vector.<GameBackground>;
		private var foregroundMap:Vector.<GameForeground>;
		/*Editado hoy*/
		private var loadedBackgroundMaps:Vector.<GameBackground>;
		private var loadedForegroundMaps:Vector.<GameForeground>;
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
		
		private var iss:Boolean;

		private var isRight:Boolean = false;
        private var isLeft:Boolean = false;
        private var isUp:Boolean = false;
        private var isDown:Boolean = false;

		
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
			foregroundMap = new Vector.<GameForeground>;
			
			/*Editado hoy*/
			loadedBackgroundMaps = new Vector.<GameBackground>;
			loadedForegroundMaps = new Vector.<GameForeground>;
			/*-----------*/
			
			editor = new Editor( 500 / 36 + 1, 500 / 36 + 1, XSectors, YSectors);
			/*Editado hoy*/
			lastSector = new Point(editor.actualXSector, editor.actualYSector);
			/*-----------*/
			createBackgroundMap(backgroundMap, XSectors, YSectors, editor);
			this.addChild(editor);
			createForegroundMap(foregroundMap, XSectors, YSectors, editor);
			
			
			/* todo */
			
			var particles:PDParticleSystem = new PDParticleSystem(XML(new AssetsParticles.ParticleXML()), Texture.fromBitmap(new AssetsParticles.Particle1Texture()));
			Starling.juggler.add(particle);
			particles.x = -100;
			particles.y = -100;
			particles.scaleX = 1.2;
			particles.scaleY = 1.2;
			this.addChild(particles);
			
			
			magicParticlesToAnimate = new Vector.<Particle>();
			
			
			iss = true;
			
			/* player  */
			player = new Player();
			this.addChild(player);
			this.camera = new Camera(player);
			this.addChild(camera);
			slime = new Monster();
			this.addChild(slime);
			
			
			//circle
			
			
			reloadMaps();
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, attack);
			this.addEventListener(KeyboardEvent.KEY_UP, release);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		private function puzzles(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			if (touch)
			{
				var localpos:Point = touch.getLocation(this);
				slime.x = localpos.x;
				slime.y = localpos.y;
			}
			touch = e.getTouch(this, TouchPhase.ENDED);
			
		}
		
		private function release(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.B)
			{
				if(player.obtainactualspell() != 3)
					createMagicParticles();
			}
			if (e.keyCode == Keyboard.X)
			{
				player.pushtheactualspell();
				
			}
			if (e.keyCode == Keyboard.N ) 
			{
				isUp = false;
			}
			else{
			if (e.keyCode == Keyboard.M) 
			{
				isDown = false;
			}
			else{
			if (e.keyCode == Keyboard.V) 
			{
				isLeft = false;
			}
			else{
			if (e.keyCode == Keyboard.C) 
			{
				isRight = false;
			}
			}
			}
			}
		}
		
	
		
		private function update(e:Event):void 
		{
			
			
			
			this.x = camera.posX;
			this.y = camera.posY;
			
			animatemagicParticles();
			
			if (isUp) player.y -= 5;
			else if(isDown) player.y += 5;
			else if(isLeft) player.x -= 5;
			else if (isRight) player.x += 5;
			if (attacking) {
				
			}
			
			
			slime.x = 40;
			slime.y = 40;
		
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
				removeForeground();
				this.removeChild(editor);
				this.removeChild(player);
				this.removeChild(slime);
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
				loadedForegroundMaps.push(foregroundMap[sectors[i]]);
			}
			for (var j:int = 0; j < loadedBackgroundMaps.length; j++) 
			{
				this.addChild(loadedBackgroundMaps[j]);
			}
			for (var k:int = 0; k < loadedForegroundMaps.length; k++) 
			{
				this.addChild(loadedForegroundMaps[k]);
			}

			
			this.addChild(editor);
			this.addChild(player);

			this.addChild(slime);
			//this.addChild(camera);
		}
		
		public function removeForeground():void {
			for (var i:int = 0; i <loadedForegroundMaps.length; i++) 
			{
				this.removeChild(loadedForegroundMaps[i]);
			}
			loadedForegroundMaps.splice(0, loadedForegroundMaps.length);
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
			
			this.addEventListener(TouchEvent.TOUCH, puzzles);

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
		
		public function createForegroundMap(map:Vector.<GameForeground>,numXSectors:int, numberYSectors:int, editor:Editor):void {
			
			var cont:int = 0;
			var contX:int = 0;
			
			while (cont < numXSectors * numberYSectors) 
			{
				var contY:int = 0;
				
				while (contY < numberYSectors) 
				{
					map.push(new GameForeground(contX, contY, editor));
					//this.addChild(map[cont]);
					contY++;
					cont++;
				}
				contX++;
			}
		}
		
		
		public function attack(e:KeyboardEvent):void
		{
			
			
			
			
			
			
			//PRUEBAS
			
			if (e.keyCode == Keyboard.N ) 
			{
				isUp = true;
			}
			else{
			if (e.keyCode == Keyboard.M) 
			{
				isDown = true;
			}
			else{
			if (e.keyCode == Keyboard.V) 
			{
				isLeft = true;
			}
			else{
			if (e.keyCode == Keyboard.C) 
			{
				isRight = true;
			}
			}
			}
			}
			
		
		}
		
		public function createMagicParticles():void {
			
			var count:int = 100;
			var x:int = 0;
			var oscilation:int = 1;
			while (count > 0)
			{
				count--;
				
				var particle:Particle = new Particle();
				particle.image.texture = Assets.getAtlas().getTexture("magicparticle" + player.obtainactualspell());
				particle.x = player.x;
				particle.y = player.y;
				this.addChild(particle);
				if(player.obtainactualspell() == 0) {
				particle.x = player.x + 50*Math.cos(x);
				particle.y = player.y + 50 * Math.sin(x++);
				}
				else if (player.obtainactualspell() == 2) {
					particle.x += x * player.directionx;
					particle.y += x++ * player.directiony;
				}
				else {
					particle.x +=  x  * (player.directionx==1 || player.directionx==-1?player.directionx:oscilation);
					particle.y += x++ * (player.directiony==1 || player.directiony==-1?player.directiony:oscilation);
					oscilation *= -1;

				}
				
				particle.speedX = Math.random() * 2 + 1;
				particle.speedY = Math.random() * 5;
				particle.spin = Math.random() * 15;
				particle.scaleX = particle.scaleY = Math.random() * 0.5 + 0.3;
				
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
					
					
					
					//magicParticleToTrack.y = (magicParticleToTrack.y - 10) ^2;
					rectangle.y = magicParticleToTrack.y;
					magicParticleToTrack.speedY -= magicParticleToTrack.speedY * 0.2;
					
					//magicParticleToTrack.x = (magicParticleToTrack.x - 10) ^ 2;
					rectangle.x = magicParticleToTrack.x;
					magicParticleToTrack.speedX--;
					
					magicParticleToTrack.rotation += deg2rad(magicParticleToTrack.spin);
					magicParticleToTrack.spin *= 1.1;
					if (rectangle.intersects(slime.bounds) && slime.alreadyhit == false) //PQ no funciona esto??? 
					{
						slime.health -= player.strength;
						slime.alreadyhit = true;
					
					}
										
					if (magicParticleToTrack.scaleY <= 0.01)
					{
						magicParticlesToAnimate.splice(i, 1);
						this.removeChild(magicParticleToTrack);
						magicParticleToTrack = null;
					}
				}
				
			}
			slime.alreadyhit = false;
			
		}
		
	}
	}
