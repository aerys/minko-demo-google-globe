package effect
{
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.SinglePassEffect;
	import aerys.minko.render.shader.IShader;
	
	public class EarthEffect extends SinglePassEffect implements IRenderingEffect
	{
		private static const SHADER	: IShader	= new EarthShader();
		
		public function EarthEffect()
		{
			super(SHADER);
		}
	}
}