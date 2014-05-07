package events 
{
	import objects.Player;
	import starling.display.Image;
	/**
	 * ...
	 * @author ...
	 */
	public class Physics 
	{
		
		public function Physics() 
		{
			
		}
		
		public function calculatePlayerCollisionsWithWalls(character:Player, walls:Vector.<Image>, indexWalls:Array):void {
			
			
			for (var i:int = 0; i < walls.length; i++) 
			{
				if (character.hitbox.bounds.intersects(walls[i].bounds) && indexWalls[i] == 1) 
				{
					trace("COLLIDING!!!");
					character.colliding = true;
					
				}
			}
			
		}
		
	}

}