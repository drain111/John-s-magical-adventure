package objects 
{
	import flash.geom.Point;
	import objects.Particle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import screens.GameWorld;
	import objects.Particle;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.extensions.PDParticle;
	import starling.utils.deg2rad;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Adri
	 */
	public class Player extends Sprite 
	{
		private var healt:int;
		private var magic:Vector.<int>;
		private var directionx:int;
		private var directiony:int;
		private var heroArt:MovieClip;
		private var magicParticlesToAnimate:Vector.<Particle>;
		import starling.extensions.PDParticleSystem;

		
		public function Player() 
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createHeroArt();
		}
		
		private function createHeroArt():void
		{
			heroArt = new MovieClip(Assets.getAtlas().getTextures("mage_" ), 20);
			heroArt.x = Math.ceil(-heroArt.width/2);
			heroArt.y = Math.ceil(-heroArt.height/2);
			//starling.core.Starling.juggler.add(heroArt);
			directionx = 1;
			directiony = 1;
			magic = new Vector.<int>;
			magic.push(2);
			magic.push(1);
			magic.push(0);
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, changeside);
			
			this.addChild(heroArt);
			magicParticlesToAnimate = new Vector.<Particle>();
			animatemagicParticles();
			
			
		}
		public function changeside(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.N) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("mage_2");
				directiony = 1;
			}
			else{
			if (e.keyCode == Keyboard.M) 
			{
				heroArt.texture = Assets.getAtlas().getTexture("mage_1");
				directiony = -1;
			}
			else{
			if (e.keyCode == Keyboard.B) {
				var localPos:Point = new Point((this.x + 20)* directionx, (this.y+20)*directiony);
				createMagicParticles(localPos)
			}
			}
			}
		}
		
		public function createMagicParticles(itemToTrack:Point):void {
			
			var count:int = 5;
			
			while (count > 0)
			{
				count--;
				var magicParticle:Particle = new Particle();
				this.addChild(magicParticle);
				
				magicParticle.x = itemToTrack.x;
				magicParticle.y = itemToTrack.y;
				
				magicParticle.speedX = Math.random() * 2 + 1;
				magicParticle.speedY = Math.random() * 5;
				magicParticle.spin = Math.random() * 15;
				magicParticle.scaleX = this.scaleY = Math.random() * 0.3 + 0.3;
				
				magicParticlesToAnimate.push(this);
			}
		}
		public function animatemagicParticles():void {
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