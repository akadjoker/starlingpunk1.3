package starling.display 
{
{
    import flash.geom.Rectangle;
 
    import starling.display.Image;
    import starling.textures.SubTexture;
    import starling.textures.Texture;
 
    public class ClipImage extends Image
    {
        private var subTexture:ClipTexture;
 
        public function ClipImage(texture:Texture, region:Rectangle=null, frame:Rectangle=null):void
        {
            this.subTexture = new ClipTexture(texture,
                                                region,
                                                frame ? frame : new Rectangle(0, 0, texture.width, texture.height));
 
            super(subTexture);
        }
 
        public function setClippingRegion(region:Rectangle):void
        {
            this.subTexture.setClippingRegion(region);
            onVertexDataChanged();
        }
    }
}