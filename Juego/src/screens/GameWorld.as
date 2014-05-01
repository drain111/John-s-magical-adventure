package screens 
{
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
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
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import starling.utils.deg2rad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import objects.Monster;
	import starling.display.Image;
	import flash.net.*;
	import flash.text.TextField;

	
	


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
		private var XSectors:int;
		private var YSectors:int;
		private var camera:Camera;
		
		
		private var editor:Editor;
		private var lastSector:Point;
		
		/* trial */

		private var particle:PDParticleSystem;
		
		
		private var player:Player;
		
		private var magicParticlesToAnimate:Vector.<Particle>
		
		private var slime:Monster;
		
		private var file:FileReference = new FileReference;
		
		private var xml:XML = < data/>;

		private var savedi:int = 0;
		
		private var savedj:int = 0;
		
		private var onloop:Boolean = false;
		
		private var maxloops:int = 200;
	
		[Embed(source = "../../assets/map/map.xml", mimeType = "application/octet-stream")]
		public static const MapXmlClass:Class;

		


		
		public function GameWorld() 
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			XSectors = GlobalVariables.MAX_X_SECTORS;
			YSectors = GlobalVariables.MAX_Y_SECTORS;
			
			drawGame();
		}
		
		
		private function drawGame():void {
			backgroundMap = new Vector.<GameBackground>;
			foregroundMap = new Vector.<GameForeground>;
			
			/*Editado hoy*/
			loadedBackgroundMaps = new Vector.<GameBackground>;
			loadedForegroundMaps = new Vector.<GameForeground>;
			/*-----------*/
			
			editor = new Editor( GlobalVariables.ROWS, GlobalVariables.COLUMNS, XSectors, YSectors);
			
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
			
			//Create the vector for the particles.
			magicParticlesToAnimate = new Vector.<Particle>();
			
			//Create the player, camera and slime
			player = new Player();
			this.addChild(player);
			this.camera = new Camera(player);
			this.addChild(camera);
			slime = new Monster();
			slime.x = 40;
			slime.y = 40;
			this.addChild(slime);
			
			//Load maps for the first time.
			reloadMaps();
			
			this.addEventListener(KeyboardEvent.KEY_DOWN, attack);
			this.addEventListener(KeyboardEvent.KEY_UP, release);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			

		}
		
		private function close(e:Event):void 
		{
			
		}
		
		
		private function release(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.B)
			{
				if(player.obtainactualspell() != 3)
					createMagicParticles();
			}
			if (e.keyCode == Keyboard.U) {
				
				if(!GlobalVariables.LOADED_WORLD) loadxml();

				// once that data is loaded, the event will be passed to the do_XML function
				
	
				
				
			}
		}
		
	
		
		private function update(e:Event):void 
		{
			//Update camera
			this.x = camera.posX;
			this.y = camera.posY;
			
			//Animate particles.
			animatemagicParticles();
			
		
			if (attacking) {
				
			}
		
			//Check sector.
			var actualSector:Point = new Point(editor.actualXSector, editor.actualYSector);
			if (actualSector.x != lastSector.x || actualSector.y != lastSector.y){
				lastSector = actualSector;
				reloadMaps();
				
			}
			
			

			/*-----------*/	

			if (slime.health <= 0) this.removeChild(slime);
			
			if (onloop == true && !GlobalVariables.LOADED_WORLD) loadxml();
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
			
			this.addChild(player);

			this.addChild(slime);
			
			for (var k:int = 0; k < loadedForegroundMaps.length; k++) 
			{
				this.addChild(loadedForegroundMaps[k]);
			}

			
			this.addChild(editor);
			
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
			if (e.keyCode == Keyboard.Y) 
			{
				
				
				for (var j:int = 0; j < backgroundMap.length ; j++) 
				{
					this.addChild(backgroundMap[j]);
				xml.appendChild(<backgroundmap id = {j}><terrainMap>{backgroundMap[j].terrainMap.join()}</terrainMap><roadsMap>{backgroundMap[j].roadsMap.join()}</roadsMap><objectsandwallsmap>{backgroundMap[j].objectsAndWallsMap.join()}</objectsandwallsmap></backgroundmap>);
				this.removeChild(backgroundMap[j]);
				
				}
				reloadMaps();
				
				
				
				
				
				
			}
			if (e.keyCode == Keyboard.H) {
				for (var j:int = 0; j < backgroundMap.length ; j++) 
				{
					
				this.addChild(foregroundMap[j]);
				xml.appendChild(<foregroundmap id = {j}><objectsmap>{foregroundMap[j].objectsMap.join()}</objectsmap><treesMap>{foregroundMap[j].treesMap.join()}</treesMap><ceilingsMap>{foregroundMap[j].ceilingsMap.join()}</ceilingsMap></foregroundmap>);
				this.removeChild(foregroundMap[j]);
				
				}
			}
			if (e.keyCode == Keyboard.J) 
			{
				file.save(xml);
				file.addEventListener(Event.CLOSE, close );
			}
			
			
		}
		
		private function loadxml():void 
		{
			var xml_Loader:URLLoader = new URLLoader();
			xml_Loader.load(new URLRequest("../assets/map/map.xml"));
			xml_Loader.addEventListener(flash.events.Event.COMPLETE, doXML);
		}
		public function doXML(e:flash.events.Event):void {
			// data sits in the event's target (aka the load)'s data
			xml = new XML(e.target.data);
			var stringterrain:String = "";
			var stringobjectswalls:String = "";
			var stringroads:String = "";
			onloop = true;
			var actualoops:int = 0;
			
			for (var j:int = savedj; j <backgroundMap.length;j++) 
			{
				var k:int = 0;
				var l:int = 0;
				var m:int = 0;
				this.addChild(backgroundMap[j]);
				this.addChild(foregroundMap[j]);
				stringterrain = xml.backgroundmap.(@id == j).terrainMap;
				stringobjectswalls = xml.backgroundmap.(@id == j).objectsandwallsmap;
				stringroads = xml.backgroundmap.(@id == j).roadsMap;
			
				for (var i:int = 0;i < backgroundMap[0].terrainMap.length ; i++) 
				{
					if (stringobjectswalls.charAt(k) == ",") k++;
					if (stringroads.charAt(l) == ",") l++;
					if (stringterrain.charAt(m) == ",") m++;
					if (stringobjectswalls.charAt(k+1) == "," || l+1 >= stringobjectswalls.length)
					backgroundMap[j].objectsAndWallsMap[i] = int(stringobjectswalls.charAt(k));
					else{ backgroundMap[j].objectsAndWallsMap[i] = int(stringobjectswalls.charAt(k)) * 10 + int(stringobjectswalls.charAt(k + 1));
					k++
					}
					if (stringroads.charAt(l+1) == "," || l+1 >= stringroads.length)
					backgroundMap[j].roadsMap[i] = Number(stringroads.charAt(l));
					else { 
						backgroundMap[j].roadsMap[i] = int(stringroads.charAt(l)) * 10 + int(stringroads.charAt(l + 1));
						l++
					}
					if (stringterrain.charAt(m+1) == "," || l+1 >= stringterrain.length)
					backgroundMap[j].terrainMap[i] = int(stringterrain.charAt(m));
					else {
						backgroundMap[j].terrainMap[i] = int(stringterrain.charAt(m)) * 10 + int(stringterrain.charAt(m + 1));
						m++
					}
					k++;
					l++;
					m++;
					actualoops++;

					
				}
				backgroundMap[j].objectsAndWallsLayer.matrix = backgroundMap[j].objectsAndWallsMap;
				backgroundMap[j].roadsLayer.matrix = backgroundMap[j].roadsMap;
				backgroundMap[j].terrainLayer.matrix = backgroundMap[j].terrainMap;
				
				backgroundMap[j].objectsAndWallsLayer.selectLayerTiles();
				backgroundMap[j].roadsLayer.selectLayerTiles();
				backgroundMap[j].terrainLayer.selectLayerTiles();
				
				
				this.removeChild(backgroundMap[j]);
				this.removeChild(foregroundMap[j]);
				if (actualoops >= maxloops) {
					savedj = j;
					return;
				}
				this.removeEventListener(flash.events.Event.COMPLETE, doXML);

				
			}
			savedj = 0;
			actualoops = 0;
			onloop = false;
			slime.x = 500;
			GlobalVariables.LOADED_WORLD = true;
			reloadMaps();
			
				
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
