package effect
{
	import aerys.minko.render.effect.IEffect;
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.renderer.state.Blending;
	import aerys.minko.render.renderer.state.CompareMode;
	import aerys.minko.render.renderer.state.RendererState;
	import aerys.minko.render.renderer.state.TriangleCulling;
	import aerys.minko.render.shader.ParametricShader;
	import aerys.minko.scene.visitor.data.LocalData;
	import aerys.minko.scene.visitor.data.StyleStack;
	
	import flash.utils.Dictionary;
	
	public class SinglePassEffect extends ParametricShader implements IEffect, IEffectPass
	{
		private var _passes	: Vector.<IEffectPass>	= new Vector.<IEffectPass>(1, true);
		
		public function SinglePassEffect()
		{
			super();
			
			_passes[0] = this;
		}
		
		public function getPasses(styleStack	: StyleStack, 
								  local			: LocalData, 
								  world			: Dictionary) : Vector.<IEffectPass>
		{
			return _passes;
		}
		
		override public function fillRenderState(state	: RendererState,
												 style	: StyleStack,
												 local	: LocalData,
												 world	: Dictionary) : Boolean
		{
			super.fillRenderState(state, style, local, world);
			
			state.blending = Blending.ALPHA;
			state.depthTest = CompareMode.LESS;
			state.triangleCulling = TriangleCulling.BACK;
			
			return true;
		}
	}
}