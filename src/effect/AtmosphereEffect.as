package effect
{
	import aerys.minko.render.renderer.state.RendererState;
	import aerys.minko.render.renderer.state.TriangleCulling;
	import aerys.minko.render.shader.node.INode;
	import aerys.minko.scene.visitor.data.LocalData;
	import aerys.minko.scene.visitor.data.StyleStack;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	
	public class AtmosphereEffect extends SinglePassEffect
	{
		private var _color	: Vector4	= null;
		
		public function AtmosphereEffect(red	: Number	= 1.,
										 green	: Number	= 1.,
										 blue	: Number	= 1.,
										 alpha	: Number	= 1.)
		{
			_color = new Vector4(red, green, blue, alpha);
			
			super();
		}
		
		override public function fillRenderState(state	: RendererState,
						 						 style	: StyleStack, 
												 local	: LocalData, 
												 world	: Dictionary) : Boolean
		{
			super.fillRenderState(state, style, local, world);
			
			state.triangleCulling = TriangleCulling.FRONT;
			
			return true;
		}
		
		override protected function getOutputPosition() : INode
		{
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor() : INode
		{
			var normal	: INode = multiply(interpolate(vertexPosition), 2.);
			var angle	: INode = dotProduct3(normal, cameraLocalDirection);
			var c		: INode = power(substract(0.8, angle), 12.);
			
			return multiply(_color, c);
		}
	}
}