package scene
{
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.scene.node.group.EffectGroup;
	import aerys.minko.scene.node.group.LoaderGroup;
	import aerys.minko.scene.node.group.TransformGroup;
	import aerys.minko.scene.node.mesh.IMesh;
	import aerys.minko.scene.node.mesh.modifier.TangentSpaceMeshModifier;
	import aerys.minko.scene.node.mesh.primitive.SphereMesh;
	import aerys.minko.scene.node.texture.BitmapTexture;
	
	import effect.EarthEffect;
	
	public class Earth extends TransformGroup
	{
		[Embed("../assets/world_diffuse.jpg")]
//		[Embed("../assets/world_diffuse_2.jpg")]
		private static const ASSET_WORLD_DIFFUSE	: Class;

		private static const DEFAULT_SCALE	: Number	= 200.;
		
		public function Earth(scale : Number = DEFAULT_SCALE)
		{
			var diffuse : BitmapTexture	= LoaderGroup.loadClass(ASSET_WORLD_DIFFUSE)[0];
			var mesh	: IMesh			= new TangentSpaceMeshModifier(new SphereMesh(40));
			var eg		: EffectGroup	= new EffectGroup(new EarthEffect(), diffuse, mesh);
			
			super(eg);
			
			transform.appendUniformScale(scale);
		}
	}
}