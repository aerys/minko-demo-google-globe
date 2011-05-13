package
{
	import aerys.minko.scene.graph.group.EffectGroup;
	
	import mesh.PointsCloudMesh;
	
	import render.SinglePassEffect;
	import render.shader.ColorShader;

	public class Globe extends EffectGroup
	{
		private static const NUM_POINTS_PER_MESH	: uint		= 8000;
		private static const DEFAULT_SCALE			: Number	= 130.;
				
		private var _currentCloud	: PointsCloudMesh	= null;
		
		public function Globe()
		{
			effects[0] = new SinglePassEffect(new ColorShader());
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