package render
{
	import aerys.minko.effect.AbstractEffect;
	
	public class AtmosphereEffect extends AbstractEffect
	{
		public function AtmosphereEffect()
		{
			super();
			
			passes[0] = new AtmospherePass();
		}
	}
}