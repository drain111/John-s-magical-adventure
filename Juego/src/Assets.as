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
		
		[Embed(source = "../assets/graphics/myspritesheet.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source = "../assets/graphics/myspritesheet.xml", mimeType = "application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		public static function getAtlas():TextureAtlas {
			if (gameTextureAtlas == null) 
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
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