package render
{
	import aerys.minko.effect.AbstractEffect;
	
	public class EarthEffect extends AbstractEffect
	{
		public function EarthEffect()
		{
			super();
			
			passes[0] = new EarthPass();
		}
	}
}