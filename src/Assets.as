

package 
{
    import flash.display.Bitmap;
    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;


    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

	public class Assets
	{
	
		
		[Embed(source="assets/control_base.png")]public static const control_base:Class;
		[Embed(source="assets/knob.png")]        public static const knob:Class;
		[Embed(source="assets/control_knob.png")]public static const control_knob:Class;
		
		
[Embed(source="assets/atlasxml.xml", mimeType="application/octet-stream")]public static const atlasxml:Class;
[Embed(source = "assets/atlas.png")]public static const atlas:Class;


[Embed(source = "assets/sewers.tmx", mimeType = "application/octet-stream")]public static var sewers:Class;
[Embed(source = "assets/sewer_tileset.png")] public static var sewer_tileset:Class;



//[Embed(source="assets/idle.xml", mimeType="application/octet-stream")]public static const idle:Class;
[Embed(source="assets/heroidle.PNG")]public static const heroidle:Class;
[Embed(source="assets/herowalk.PNG")]public static const herowalk:Class;
		
[Embed(source = "assets/sprite.PNG")] public static const sprite:Class;
[Embed(source = "assets/coin_particle.png")] public static const coin_particle:Class;





/*
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
	
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTexture");
				var xml:XML = XML(new atlasxml());
				gameTextureAtlas=new TextureAtlas(texture, xml);
			}
			
			return gameTextureAtlas;
		}
		
			public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name]=Texture.fromBitmap(bitmap);
			}
			
			return gameTextures[name];
		}
		*/
	}
}
