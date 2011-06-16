package scene
{
	import aerys.minko.scene.node.Model;
	import aerys.minko.scene.node.mesh.primitive.SphereMesh;
	
	import effect.GlowEffect;
	
	public class Atmosphere extends Model
	{
		private static const DEFAULT_SCALE	: Number	= 200.;//233.;
		
		public function Atmosphere(scale : Number = DEFAULT_SCALE)
		{
			super(new SphereMesh(40, 40, true));
			
			transform.appendUniformScale(DEFAULT_SCALE);
			effect = new GlowEffect(0.15, .6, .9, 1.);
		}
	}
}