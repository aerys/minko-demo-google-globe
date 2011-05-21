package effect
{
	import aerys.minko.render.effect.IEffect;
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.shader.ParametricShader;
	import aerys.minko.render.state.Blending;
	import aerys.minko.render.state.CompareMode;
	import aerys.minko.render.state.RenderState;
	import aerys.minko.render.state.TriangleCulling;
	import aerys.minko.scene.visitor.data.StyleStack;
	import aerys.minko.scene.visitor.data.TransformData;
	
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
								  local			: TransformData, 
								  world			: Dictionary) : Vector.<IEffectPass>
		{
			return _passes;
		}
		
		override public function fillRenderState(state	: RenderState,
												 style	: StyleStack,
												 local	: TransformData,
												 world	: Dictionary) : Boolean
		{
			super.fillRenderState(state, style, local, world);
			
			state.blending = Blending.ALPHA;
			state.depthMask = CompareMode.LESS;
			state.triangleCulling = TriangleCulling.BACK;
			
			return true;
		}
	}
}