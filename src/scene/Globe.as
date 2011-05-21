package scene
{
	import aerys.minko.render.effect.basic.BasicEffect;
	import aerys.minko.scene.node.group.EffectGroup;
	
	import scene.mesh.PointsCloudMesh;

	public class Globe extends EffectGroup
	{
		private static const NUM_POINTS_PER_MESH	: uint		= 8000;
		private static const DEFAULT_SCALE			: Number	= 130.;
				
		private var _currentCloud	: PointsCloudMesh	= null;
		
		public function Globe()
		{
			effects[0] = new BasicEffect();
		}
		
		public function addPoint(latitude	: Number,
								 longitude	: Number,
								 value		: Number,
								 color		: uint) : void
		{
			if (!_currentCloud || _currentCloud.numPoints > NUM_POINTS_PER_MESH)
				addChild(_currentCloud = new PointsCloudMesh());
			
			_currentCloud.addPoint(latitude, longitude, value, color);
		}
	}
}