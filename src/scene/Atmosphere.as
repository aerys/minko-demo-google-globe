package scene
{
	import aerys.minko.scene.node.Model;
	import aerys.minko.scene.node.mesh.primitive.SphereMesh;
	
	import effect.SinglePassEffect;
	import effect.AtmosphereEffect;
	
	public class Atmosphere extends Model
	{
		private static const DEFAULT_SCALE	: Number	= 233.;
		
		public function Atmosphere(scale : Number = DEFAULT_SCALE)
		{
			super(new SphereMesh(40));
			
			transform.appendUniformScale(DEFAULT_SCALE);
			effect = new AtmosphereEffect();
		}
	}
}