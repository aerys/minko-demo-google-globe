package render
{
	import aerys.minko.effect.IEffectPass;
	import aerys.minko.effect.StyleStack;
	import aerys.minko.effect.basic.BasicStyle;
	import aerys.minko.render.IRenderer;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.state.Blending;
	import aerys.minko.render.state.CompareMode;
	import aerys.minko.render.state.RenderState;
	import aerys.minko.type.math.Matrix4x4;
	
	public class ColorPass implements IEffectPass
	{
		private static const DEFAULT_SHADER	: Shader	= new ColorShader();
		private static const DEPTH_TEST		: int		= CompareMode.LESS;
		
		public function ColorPass()
		{
		}
		
		public function begin(renderer:IRenderer, style:StyleStack):Boolean
		{
			var state 		: RenderState 	= renderer.state;
			var toScreen	: Matrix4x4		= style.get(BasicStyle.LOCAL_TO_SCREEN_MATRIX)
											  as Matrix4x4;
			var blending	: uint			= style.get(BasicStyle.BLENDING, Blending.NORMAL)
											  as uint;
			
			state.shader = DEFAULT_SHADER;
			state.blending = blending;
			state.depthMask = DEPTH_TEST;
			
			state.setFragmentConstant(0, 1.);		
			state.setVertexConstantMatrix(0, toScreen);
			
			return true;
		}
		
		public function end(renderer:IRenderer, style:StyleStack):void
		{
			// NOTHING
		}
	}
}