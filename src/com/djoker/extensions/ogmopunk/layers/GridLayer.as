package com.djoker.extensions.ogmopunk.layers
{
	import com.djoker.extensions.ogmopunk.OgmoLayer;
	import com.djoker.extensions.ogmopunk.OgmoProject;
	import com.djoker.masks.Grid;
	import com.djoker.Entity;
	/**
	 * ...
	 * @author Erin M Gunn
	 */
	public class GridLayer extends OgmoLayer
	{
		public var mExportMode:String;
		public function get exportMode():String
		{
			return mExportMode;
		}
		
		override public function loadData():Vector.<Entity> 
		{
			
			var e:Entity = new Entity(0, 0, name);
			e.setHitWidth(OgmoProject.levelDims.x);
			e.setHitHeight(OgmoProject.levelDims.y);
			var grid:Grid = new Grid(OgmoProject.levelDims.x, OgmoProject.levelDims.y, grid.x, grid.y);
			if (exportMode == "Bitstring")
			{
				grid.loadFromString(data.toString(), '', '\n');
			}
			e.mask = grid;
			
			var es:Vector.<Entity> = new Vector.<Entity>();
			es.push(e);
			return es;
			
			return null;
		}
		
	}

}