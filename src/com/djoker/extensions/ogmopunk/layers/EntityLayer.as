package com.djoker.extensions.ogmopunk.layers 
{
	import com.djoker.extensions.ogmopunk.OgmoEntityDefinition;
	import com.djoker.extensions.ogmopunk.OgmoLayer;
	import com.djoker.extensions.ogmopunk.OgmoProject;
	import com.djoker.Entity;
	/**
	 * ...
	 * @author Erin M Gunn
	 */
	public class EntityLayer extends OgmoLayer 
	{
		
		override public function loadData():Vector.<Entity> 
		{
			var entities:Vector.<Entity> = new Vector.<Entity>();
			
			var xml:XML;
			for each(xml in this.data.children())
			{
				var eDef:OgmoEntityDefinition = OgmoProject.entities[xml.localName().toString()];
				var e:Entity = eDef.loadData(xml);
				entities.push(e);
			}
			return entities;
		}
	}
}