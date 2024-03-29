// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================
package starling.extensions
{
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    /** A texture atlas is a collection of many smaller textures in one big image. This class
     *  is used to access textures from such an atlas.
     *  
     *  <p>Using a texture atlas for your textures solves two problems:</p>
     *  
     *  <ul>
     *    <li>There is always one texture active at a given moment. Whenever you change the active
     *        texture, a "texture-switch" has to be executed, and that switch takes time.</li>
     *    <li>Any Stage3D texture has to have side lengths that are powers of two. Starling hides 
     *        this limitation from you, but at the cost of additional graphics memory.</li>
     *  </ul>
     *  
     *  <p>By using a texture atlas, you avoid both texture switches and the power-of-two 
     *  limitation. All textures are within one big "super-texture", and Starling takes care that 
     *  the correct part of this texture is displayed.</p>
     *  
     *  <p>There are several ways to create a texture atlas. One is to use the atlas generator 
     *  script that is bundled with Starling's sibling, the <a href="http://www.sparrow-framework.org">
     *  Sparrow framework</a>. It was only tested in Mac OS X, though. A great multi-platform 
     *  alternative is the commercial tool <a href="http://www.texturepacker.com">
     *  Texture Packer</a>.</p>
     *  
     *  <p>Whatever tool you use, Starling expects the following file format:</p>
     * 
     *  <listing>
     * 	&lt;TextureAtlas imagePath='atlas.png'&gt;
     * 	  &lt;SubTexture name='texture_1' x='0'  y='0' width='50' height='50'/&gt;
     * 	  &lt;SubTexture name='texture_2' x='50' y='0' width='20' height='30'/&gt; 
     * 	&lt;/TextureAtlas&gt;
     *  </listing>
     *  
     *  <p>If your images have transparent areas at their edges, you can make use of the 
     *  <code>frame</code> property of the Texture class. Trim the texture by removing the 
     *  transparent edges and specify the original texture size like this:</p>
     * 
     *  <listing>
     * 	&lt;SubTexture name='trimmed' x='0' y='0' height='10' width='10'
     * 	    frameX='-10' frameY='-10' frameWidth='30' frameHeight='30'/&gt;
     *  </listing>
     */
    public class BigTextureAtlas extends TextureAtlas
    {
        private var mTextureRegions:Dictionary;
        private var mTextureFrames:Dictionary;
        private var mTextures:Array = [];
		private var mTextureIndexes:Dictionary;
        
        /** Create a texture atlas from a texture by parsing the regions from an XML file. */
        public function BigTextureAtlas(textures:Array = null, atlasXmls:Array = null) 
        {
			super(null,null);
			if (textures.length !== atlasXmls.length) return;
			
            mTextureRegions = new Dictionary();
            mTextureFrames  = new Dictionary();
			mTextureIndexes = new Dictionary();
            mTextures = textures;
			
			for (var i:uint = 0; i < textures.length; i++)
			{
				var atlasXml:XML = atlasXmls[i];
				if (atlasXml){
					
					parseAtlasXmlBig(atlasXml,i);
				}
			}
			
        }
        
        /** Disposes the atlas texture. */
        override public function dispose():void
        {
            for each (var i:Texture in mTextures) {
            	i.dispose();
            }
        }
        
        private function parseAtlasXmlBig(atlasXml:XML,textureIndex:Number):void
        {
            for each (var subTexture:XML in atlasXml.SubTexture)
            {                
                var name:String        = subTexture.attribute("name");
                var x:Number           = parseFloat(subTexture.attribute("x"));
                var y:Number           = parseFloat(subTexture.attribute("y"));
                var width:Number       = parseFloat(subTexture.attribute("width"));
                var height:Number      = parseFloat(subTexture.attribute("height"));
                var frameX:Number      = parseFloat(subTexture.attribute("frameX"));
                var frameY:Number      = parseFloat(subTexture.attribute("frameY"));
                var frameWidth:Number  = parseFloat(subTexture.attribute("frameWidth"));
                var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight"));
                
                var region:Rectangle = new Rectangle(x, y, width, height);
                var frame:Rectangle  = frameWidth > 0 && frameHeight > 0 ?
                        new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
                
                addRegionWithIndex(name, region, frame, textureIndex);
            }
        }
        
        /** Retrieves a subtexture by name. Returns <code>null</code> if it is not found. */
        override public function getTexture(name:String):Texture
        {
            var region:Rectangle = mTextureRegions[name];
            
			
            if (region == null) return null;
            else
            {
				var mAtlasTexture:Texture = mTextures[mTextureIndexes[name]];
                var texture:Texture = Texture.fromTexture(mAtlasTexture, region);
                texture.frame = mTextureFrames[name];
                return texture;
            }
        }
        
        /** Returns all textures that start with a certain string, sorted alphabetically
         *  (especially useful for "MovieClip"). */
        override public function getTextures(prefix:String=""):Vector.<Texture>
        {
            var textures:Vector.<Texture> = new <Texture>[];
            var names:Vector.<String> = new <String>[];
            var name:String;
            
            for (name in mTextureRegions)
                if (name.indexOf(prefix) == 0)                
                    names.push(name);                
            
            names.sort(Array.CASEINSENSITIVE);
            
            for each (name in names) 
                textures.push(getTexture(name)); 
            
            return textures;
        }
        
        /** Creates a region for a subtexture and gives it a name. */
        public function addRegionWithIndex(name:String, region:Rectangle, frame:Rectangle=null, textureIndex:Number = 0):void
        {
            mTextureRegions[name] = region;
            mTextureIndexes[name] = textureIndex;
            if (frame) mTextureFrames[name] = frame;
        }
        
        /** Removes a region with a certain name. */
        override public function removeRegion(name:String):void
        {
            delete mTextureRegions[name];
            delete mTextureIndexes[name];
        }
    }
}