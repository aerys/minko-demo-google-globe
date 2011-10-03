package effect
{
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.SinglePassEffect;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;
	
	import flash.utils.Dictionary;
	
	
	public class GlowEffect extends SinglePassEffect implements IRenderingEffect
	{
		
		public function GlowEffect(blur		: Number	= 0.165,
								   red		: Number	= 1.,
								   green	: Number	= 1.,
								   blue		: Number	= 1.,
								   alpha	: Number	= 1.)
		{
			super(new GlowShader(blur, red, green, blue, alpha));
		}
		
		override public function fillRenderState(state		: RendererState,
						 						 style		: StyleData, 
												 transform	: TransformData,
												 world		: Dictionary) : Boolean
		{
			super.fillRenderState(state, style, transform, world);
			
			state.triangleCulling = TriangleCulling.FRONT;
			state.blending = Blending.ALPHA;
			state.priority = -1.;
						
			return true;
		}
		
	}
}