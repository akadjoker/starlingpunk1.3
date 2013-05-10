package starling.display 
{
 import flash.display3D.textures.TextureBase;
    import flash.geom.Point;
    import flash.geom.Rectangle;
 
    import starling.textures.SubTexture;
    import starling.textures.Texture;
    import starling.utils.VertexData;
 
    /** A SubTexture represents a section of another texture. This is achieved solely by
     *  manipulation of texture coordinates, making the class very efficient.
     *
     *  <p><em>Note that it is OK to create subtextures of subtextures.</em></p>
     */
    public class ClipTexture extends Texture
    {
        private var mParent:Texture;
        private var mClipping:Rectangle;
        private var mRootClipping:Rectangle;
        private var mOwnsParent:Boolean;
        private var subFrame:Rectangle;
 
        /** Helper object. */
        private static var sTexCoords:Point = new Point();
 
        /** Creates a new subtexture containing the specified region (in points) of a parent
         *  texture. If 'ownsParent' is true, the parent texture will be disposed automatically
         *  when the subtexture is disposed. */
        public function ClipTexture(parentTexture:Texture, region:Rectangle, frame:Rectangle=null,
                                      ownsParent:Boolean=false)
        {
            //super(parentTexture, region, ownsParent);
 
            mParent = parentTexture;
            mOwnsParent = ownsParent;
 
            if (region == null)
            {
                //setClippingRegion(new Rectangle(0, 0, parentTexture.width, parentTexture.height));
                setClipping(new Rectangle(0, 0, 1, 1));
            }
            else
            {
                setClippingRegion(region);
            }
 
            if (frame)
            {
                this.subFrame = frame.clone();
            }
        }
 
        /** Disposes the parent texture if this texture owns it. */
        public override function dispose():void
        {
            if (mOwnsParent) mParent.dispose();
            super.dispose();
        }
 
        public function setClippingRegion(region:Rectangle):void
        {
            this.setClipping(new Rectangle(region.x / this.mParent.width,
                                           region.y / this.mParent.height,
                                           region.width / this.mParent.width,
                                           region.height / this.mParent.height));
 
        }
 
        private function setClipping(value:Rectangle):void
        {
            mClipping = value;
            mRootClipping = value.clone();
 
            var parentTexture:SubTexture = mParent as SubTexture;
            while (parentTexture)
            {
                // TODO this line still causes a new Rectangle to be created
                var parentClipping:Rectangle = parentTexture.clipping;
                mRootClipping.x = parentClipping.x + mRootClipping.x * parentClipping.width;
                mRootClipping.y = parentClipping.y + mRootClipping.y * parentClipping.height;
                mRootClipping.width  *= parentClipping.width;
                mRootClipping.height *= parentClipping.height;
                parentTexture = parentTexture.parent as SubTexture;
            }
        }
 
        /** @inheritDoc */
        public override function adjustVertexData(vertexData:VertexData, vertexID:int, count:int):void
        {
            // Copied up here because it's private in Texture. I'll be good with it, I promise...
            //super.adjustVertexData(vertexData, vertexID, count);
 
            if (this.subFrame)
            {
                if (count != 4)
                    throw new ArgumentError("Textures with a frame can only be used on quads");
 
                var deltaRight:Number  = this.subFrame.width  + this.subFrame.x - width;
                var deltaBottom:Number = this.subFrame.height + this.subFrame.y - height;
 
                vertexData.translateVertex(vertexID,     -this.subFrame.x, -this.subFrame.y);
                vertexData.translateVertex(vertexID + 1, -deltaRight, -this.subFrame.y);
                vertexData.translateVertex(vertexID + 2, -this.subFrame.x, -deltaBottom);
                vertexData.translateVertex(vertexID + 3, -deltaRight, -deltaBottom);
            }
 
            var clipX:Number = mRootClipping.x;
            var clipY:Number = mRootClipping.y;
            var clipWidth:Number  = mRootClipping.width;
            var clipHeight:Number = mRootClipping.height;
            var endIndex:int = vertexID + count;
 
            for (var i:int=vertexID; i<endIndex; ++i)
            {
                vertexData.getTexCoords(i, sTexCoords);
                vertexData.setTexCoords(i, clipX + sTexCoords.x * clipWidth,
                                           clipY + sTexCoords.y * clipHeight);
            }
        }
 
        /** The texture which the subtexture is based on. */
        public function get parent():Texture { return mParent; }
 
        /** Indicates if the parent texture is disposed when this object is disposed. */
        public function get ownsParent():Boolean { return mOwnsParent; }
 
        /** The clipping rectangle, which is the region provided on initialization
         *  scaled into [0.0, 1.0]. */
        public function get clipping():Rectangle { return mClipping.clone(); }
 
        /** @inheritDoc */
        public override function get base():TextureBase { return mParent.base; }
 
        /** @inheritDoc */
        public override function get format():String { return mParent.format; }
 
        /** @inheritDoc */
        public override function get width():Number { return mParent.width * mClipping.width; }
 
        /** @inheritDoc */
        public override function get height():Number { return mParent.height * mClipping.height; }
 
        /** @inheritDoc */
        public override function get mipMapping():Boolean { return mParent.mipMapping; }
 
        /** @inheritDoc */
        public override function get premultipliedAlpha():Boolean { return mParent.premultipliedAlpha; }
 
        /** @inheritDoc */
        public override function get scale():Number { return mParent.scale; } 
 
        public override function get frame():Rectangle
        {
            return this.subFrame ? this.subFrame.clone() : new Rectangle(0, 0, width, height);
        }
 
    }
}