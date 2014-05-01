

package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class GlobalVariables 
	{
		
		public static var posCameraX:Number = 0;
		public static var posCameraY:Number = 0;
		
		public static var LOADED_WORLD:Boolean = false;

		public static const TILE_DIMENSIONS:int = 36;
		
		public static const ROWS:int = 500 / TILE_DIMENSIONS + 1;
		public static const COLUMNS:int = 500 / TILE_DIMENSIONS + 1;
		
		public static const MAX_X_SECTORS:int = 10;
		public static const MAX_Y_SECTORS:int = 10;
		
		public function GlobalVariables() 
		{
			
		}
		
	}

}