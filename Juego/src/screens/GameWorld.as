package screens 
{
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


	import starling.core.Starling;


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
		
		
		/* trial */

		private var particle:PDParticleSystem;
		private var magicParticlesToAnimate:Vector.<Particle>;


		
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
			
			/* todo */
			particle = new PDParticleSystem(XML(new AssetsParticles.ParticleXML()), Texture.fromBitmap(new AssetsParticles.ParticleTexture()));
			Starling.juggler.add(particle);
			particle.x = camera.x;
			particle.y = camera.y;
			particle.scaleX = 1.2;
			particle.scaleY = 1.2;
			this.addChild(particle);
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void 
		{
			this.x = GlobalVariables.posCameraX;
			this.y = GlobalVariables.posCameraY;
			
			animatemagicParticles();
			
		}
		
		public function initialize():void {
			this.visible = true;
			
			
			magicParticlesToAnimate = new Vector.<Particle>();
			this.addEventListener(TouchEvent.TOUCH, createparticle);
			
		}
		
		private function createparticle(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this)
			if (touch)
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
		private function createMagicParticles(itemToTrack:Point):void 
		{
			
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
		private function animatemagicParticles():void 
		{
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