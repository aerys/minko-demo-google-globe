package render.shader
{
	import aerys.minko.effect.IEffectPass;
	import aerys.minko.render.shader.compiler.register.RegisterMask;
	import aerys.minko.render.shader.node.IShaderNode;
	import aerys.minko.render.state.CompareMode;
	import aerys.minko.render.state.RenderState;
	import aerys.minko.render.state.TriangleCulling;
	import aerys.minko.scene.visitor.data.StyleStack;
	import aerys.minko.scene.visitor.data.TransformData;
	
	import flash.utils.Dictionary;
	
	import render.AbstractShader;

	public class ColorShader extends AbstractShader implements IEffectPass
	{
		public function fillRenderState(state	: RenderState,
										style	: StyleStack, 
										local	: TransformData, 
										world	: Dictionary) : Boolean
		{
			setConstants(style, local, world, state);
			setTextures(style, local, world, state);
			
			state.shader = this;
			state.depthMask = CompareMode.LESS;
			state.triangleCulling = TriangleCulling.BACK;
			
			return true;
		}
		
		override protected function getOutputPosition() : IShaderNode
		{
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor() : IShaderNode
		{
			return combine(interpolate(vertexColor), RegisterMask.XYZ, 1., RegisterMask.W);
		}
	}
}