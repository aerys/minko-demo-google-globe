package
{
	import aerys.minko.scene.graph.Model;
	import aerys.minko.scene.graph.mesh.primitive.SphereMesh;
	
	import render.SinglePassEffect;
	import render.shader.AtmosphereShader;
	
	public class Atmosphere extends Model
	{
		private static const DEFAULT_SCALE	: Number	= 233.;
		
		public function Atmosphere(scale : Number = DEFAULT_SCALE)
		{
			super(new SphereMesh(40));
			
			transform.appendUniformScale(DEFAULT_SCALE);
			effects[0] = new SinglePassEffect(new AtmosphereShader());
		}
	}
}