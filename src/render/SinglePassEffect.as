package render
{
	import aerys.minko.effect.AbstractEffect;
	import aerys.minko.effect.IEffectPass;
	
	public class SinglePassEffect extends AbstractEffect
	{
		public function SinglePassEffect(pass : IEffectPass)
		{
			super();
			
			passes[0] = pass;
		}
	}
}