package effect
{
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.renderer.state.Blending;
	import aerys.minko.render.renderer.state.RendererState;
	import aerys.minko.render.shader.node.INode;
	import aerys.minko.render.shader.node.operation.builtin.Multiply4x4;
	import aerys.minko.scene.visitor.data.LocalData;
	import aerys.minko.scene.visitor.data.StyleStack;
	
	import flash.utils.Dictionary;
	
	[StyleParameter(name="basic diffuse map", type="texture")]
	[StyleParameter(name="basic normal map", type="texture")]
	
	public class EarthEffect extends SinglePassEffect
	{
		override protected function getOutputPosition() : INode
		{
			return vertexClipspacePosition;
		}
		
		override public function fillRenderState(state 	: RendererState,
												 style	: StyleStack,
												 local	: LocalData,
												 world	: Dictionary) : Boolean
		{
			super.fillRenderState(state, style, local, world);
			
			state.blending = Blending.NORMAL;
			
			return true;
		}
		
		override protected function getOutputColor() : INode
		{
			var diffuse : INode = sampleTexture(BasicStyle.DIFFUSE_MAP, interpolate(vertexUV));
			var normal	: INode = sampleTexture(BasicStyle.NORMAL_MAP, interpolate(vertexUV));
			
			// compute the normal in local space
			normal = combine(dotProduct3(interpolate(vertexTangent), normal),
							 dotProduct3(interpolate(vertexBinormal), normal),
							 dotProduct3(interpolate(vertexNormal), normal),
							 1.);
			
			//normal = multiply4x4(normal, localToWorldMatrix);
			
			var angle	: INode = dotProduct3(normal, cameraLocalDirection);
			
			//return multiply(cos(angle), diffuse);
			return interpolate(vertexTangent);
		}
	}
}