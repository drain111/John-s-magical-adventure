package  
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Yo
	 */
	public class Assets 
	{
		
		/*[Embed(source = "../assets/graphics/bgWelcome.jpg")]
		public static const BgWelcome:Class;
		
		[Embed(source = "../assets/graphics/bgLayer1.jpg")]
		public static const BgLayer1:Class;
		*/
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		//private static var gameTextureMage:TextureAtlas;
		
		[Embed(source = "../assets/map/map.xml", mimeType = "application/octet-stream")]
		public static const MapXmlGame:Class;
		
		[Embed(source = "../assets/graphics/myspritesheet.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source = "../assets/graphics/myspritesheet.xml", mimeType = "application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		
		
		/*[Embed(source = "../assets/graphics/magonspritesheet.png")]
		public static const MagonTextureGame:Class;
		
		[Embed(source = "../assets/graphics/magonspritesheet.xml", mimeType = "application/octet-stream")]
		public static const MagonXmlGame:Class;*/
		
		public static function getAtlas():TextureAtlas {
			if (gameTextureAtlas == null) 
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		/*public static function getAtlasmage():TextureAtlas {
			if (gameTextureMage == null) 
			{
				
				var texturemago:Texture = getTexture("MagonTextureGame");
				var xmlmagon:XML = XML(new MagonXmlGame());
				gameTextureMage = new TextureAtlas(texturemago, xmlmagon);
			}
			return gameTextureMage;
		}*/
		public static function getTexture(name:String):Texture {
			if (gameTextures[name] == undefined) 
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}