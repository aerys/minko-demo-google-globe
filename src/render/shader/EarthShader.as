package render.shader
{
	import aerys.minko.effect.IEffectPass;
	import aerys.minko.effect.basic.BasicStyle;
	import aerys.minko.render.shader.node.IShaderNode;
	import aerys.minko.render.shader.node.operation.other.Texture;
	import aerys.minko.render.state.Blending;
	import aerys.minko.render.state.CompareMode;
	import aerys.minko.render.state.RenderState;
	import aerys.minko.render.state.TriangleCulling;
	import aerys.minko.scene.visitor.data.CameraData;
	import aerys.minko.scene.visitor.data.StyleStack;
	import aerys.minko.scene.visitor.data.TransformData;
	import aerys.minko.type.math.ConstVector4;
	
	import flash.utils.Dictionary;
	
	import render.AbstractShader;
	
	public class EarthShader extends AbstractShader implements IEffectPass
	{
		public function fillRenderState(state	: RenderState,
										style	: StyleStack, 
										local	: TransformData, 
										world	: Dictionary) : Boolean
		{
			setConstants(style, local, world, state);
			setTextures(style, local, world, state);
			
			state.shader = this;
			state.blending = Blending.NORMAL;
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
			var texture : Texture = sampleTexture(BasicStyle.DIFFUSE_MAP, interpolate(vertexUV));
			
			var normal	: * = multiply(interpolate(vertexPosition), 2.);
			var angle	: * = dotProduct3(normal, cameraLocalDirection);
			
			var coeff	: * = power(substract(1.05, angle), 3.);
			
			return add(texture, multiply(coeff, ConstVector4.ONE));
		}
	}
}