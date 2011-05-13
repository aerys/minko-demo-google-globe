package
{
	import aerys.minko.scene.graph.Loader3D;
	import aerys.minko.scene.graph.Model;
	import aerys.minko.scene.graph.mesh.primitive.SphereMesh;
	
	import render.SinglePassEffect;
	import render.shader.EarthShader;
	
	public class Earth extends Model
	{
		[Embed("../assets/world.jpg")]
		private static const ASSET_WORLD_DIFFUSE	: Class;
		
		private static const DEFAULT_SCALE	: Number	= 200.;
		
		public function Earth(scale : Number = DEFAULT_SCALE)
		{
			super(new SphereMesh(40), Loader3D.loadAsset(ASSET_WORLD_DIFFUSE)[0]);
			
			transform.appendUniformScale(scale);
			effects[0] = new SinglePassEffect(new EarthShader());
		}
	}
}