package render.shader
{
	import aerys.minko.effect.IEffectPass;
	import aerys.minko.render.shader.node.IShaderNode;
	import aerys.minko.render.state.Blending;
	import aerys.minko.render.state.CompareMode;
	import aerys.minko.render.state.RenderState;
	import aerys.minko.render.state.TriangleCulling;
	import aerys.minko.scene.visitor.data.StyleStack;
	import aerys.minko.scene.visitor.data.TransformData;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	import mx.utils.NameUtil;
	
	import render.AbstractShader;
	
	public class AtmosphereShader extends AbstractShader implements IEffectPass
	{
		private var _color	: Vector4	= null;
		
		public function AtmosphereShader(red	: Number	= 1.,
										 green	: Number	= 1.,
										 blue	: Number	= 1.,
										 alpha	: Number	= 1.)
		{
			_color = new Vector4(red, green, blue, alpha);
			
			super();
		}
		
		public function fillRenderState(state	: RenderState,
										style	: StyleStack, 
										local	: TransformData, 
										world	: Dictionary) : Boolean
		{
			setConstants(style, local, world, state);
			setTextures(style, local, world, state);
			
			state.shader = this;
			state.blending = Blending.ALPHA;
			state.depthMask = CompareMode.LESS;
			state.triangleCulling = TriangleCulling.FRONT;
			
			return true;
		}
		
		override protected function getOutputPosition() : IShaderNode
		{
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor() : IShaderNode
		{
			var normal	: * = multiply(interpolate(vertexPosition), 2.);
			var angle	: * = dotProduct3(normal, cameraLocalDirection);
			var c		: * = power(substract(0.8, angle), 12.);
			
			return multiply(_color, c);
		}
	}
}