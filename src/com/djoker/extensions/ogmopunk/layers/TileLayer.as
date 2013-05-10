package com.djoker.extensions.ogmopunk.layers
{
	import com.djoker.extensions.ogmopunk.OgmoLayer;
	import com.djoker.extensions.ogmopunk.OgmoProject;
	import com.djoker.extensions.ogmopunk.OgmoTileSet;
	import com.djoker.graphics.Tilemap;
	import com.djoker.Entity;
	/**
	 * ...
	 * @author Erin M Gunn
	 */
	public class TileLayer extends OgmoLayer
	{
		
		public var mExportMode:String;
		public function get exportMode():String 
		{
			return mExportMode;
		}
		
		override public function loadData():Vector.<Entity> 
		{
			var tileSet:OgmoTileSet = OgmoProject.tileSets[this.data.@tileset];
			var e:Entity = new Entity(0, 0, tileSet.name);
			var tilemap:Tilemap = new Tilemap(OgmoProject.levelDims.x, OgmoProject.levelDims.y, tileSet.tileSize.x, tileSet.tileSize.y)
			if (!OgmoProject.tileSetImages) throw new Error("You must first call the createTilesFromTextureAtlas method in the OgmoProject class");
			
			//passes the image vector to the tile class
			tilemap.createTilesFromVector(OgmoProject.getTileSet(tileSet.name));
			
			//e.graphic.scrollX = scrollFactor.x;
			//e.graphic.scrollY = scrollFactor.y;
			
			if (exportMode == "CSV")
			{
				var str:String = this.data.toString();
				str = str.replace(new RegExp('-1', 'g'), '');
				tilemap.loadFromString(str);
			}
			
			var es:Vector.<Entity> = new Vector.<Entity>();
			es.push(e);
			e.addChild(tilemap);
			
			return es;
		}
	}

}