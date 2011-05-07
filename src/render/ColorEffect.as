package render
{
	import aerys.minko.effect.AbstractEffect;
	import aerys.minko.effect.StyleStack;
	import aerys.minko.effect.basic.BasicStyle;
	import aerys.minko.render.IRenderer;
	import aerys.minko.render.state.TriangleCulling;
	
	public class ColorEffect extends AbstractEffect
	{
		public function ColorEffect()
		{
			super();
			
			passes[0] = new ColorPass();
		}
		
		override public function begin(renderer:IRenderer, style:StyleStack):void
		{
			super.begin(renderer, style);
			
			renderer.state.triangleCulling = style.get(BasicStyle.TRIANGLE_CULLING,
													   TriangleCulling.BACK) as uint;
		}
	}
}