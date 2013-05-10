package starling.display {
	
import starling.display.TilesBatch;
	/**
	 * A class describing a single tile in a tilemap. Each tilemap will have one of these for each different
	 * type of tile in the map, not for each actual tile.
	 */
	public class STile {
		
			public var width:Number;
		/**
		 * The height of this object in pixels.
		 * @default 0
		 */
		public var height:Number;
		
		/**
		 * The tilemap this tile type belongs to.
		 */
		public var map:TilesBatch;
		/**
		 * The possible collision directions for this tile.
		 * TODO: Currently if you set it to NONE it is not solid, anything else is fully solid. Must support partially solid
		 * in the future.
		 */
		public var collision:uint;
		/**
		 * The callback function that should be called if this tile is collided against.
		 */
		public var callback:Function;
		/**
		 * The tile type index that this tile represents.
		 */
		private var index:uint;

		/**
		 * Creates a new AxTile.
		 * 
		 * @param map The tilemap this tile type belongs to.
		 * @param index The tile type index that this tile represents.
		 * @param width The width of this tile.
		 * @param height The height of this tile.
		 */
		public function STile(map:TilesBatch, index:uint, width:uint, height:uint)
		{

			this.map = map;
			this.index = index;
			this.width = width;
			this.height = height;
	    	this.callback = null;
		}
	}
}
