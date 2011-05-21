package effect
{
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.shader.node.INode;
	import aerys.minko.render.shader.node.operation.builtin.Texture;
	import aerys.minko.scene.visitor.data.StyleStack;
	import aerys.minko.scene.visitor.data.TransformData;
	import aerys.minko.type.math.ConstVector4;
	
	import flash.utils.Dictionary;
	
	
	public class EarthEffect extends SinglePassEffect
	{
		override protected function getOutputPosition(style	: StyleStack, 
													  local	: TransformData, 
													  world	: Dictionary) : INode
		{
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor(style	: StyleStack, 
												   local	: TransformData, 
												   world	: Dictionary) : INode
		{
			var texture : Texture = sampleTexture(BasicStyle.DIFFUSE_MAP, interpolate(vertexUV));
			
			var normal	: INode = multiply(interpolate(vertexPosition), 2.);
			var angle	: INode = dotProduct3(normal, cameraLocalDirection);
			
			var coeff	: INode = power(substract(1.05, angle), 3.);
			
			return add(texture, multiply(coeff, ConstVector4.ONE));
		}
	}
}