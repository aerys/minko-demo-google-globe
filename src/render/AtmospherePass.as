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
	import aerys.minko.render.state.TriangleCulling;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	public class AtmospherePass implements IEffectPass
	{
		private static const DEFAULT_SHADER	: Shader	= new AtmosphereShader();
		private static const DEPTH_TEST		: int		= CompareMode.LESS;
		
		private static const VIEW_INVERT	: Matrix4x4	= new Matrix4x4();
		
		public function AtmospherePass()
		{
		}
		
		public function begin(renderer:IRenderer, style:StyleStack):Boolean
		{
			var state 		: RenderState 	= renderer.state;
			var toScreen	: Matrix4x4		= style.get(BasicStyle.LOCAL_TO_SCREEN_MATRIX)
											  as Matrix4x4;
			var blending	: uint			= style.get(BasicStyle.BLENDING, Blending.NORMAL)
											  as uint;
			var viewMatrix	: Matrix4x4		= style.get(BasicStyle.VIEW_MATRIX) as Matrix4x4;
			
			Matrix4x4.invert(viewMatrix, VIEW_INVERT);
			var direction : Vector4 = VIEW_INVERT.multiplyVector(ConstVector4.Z_AXIS);
		
			direction.normalize();
			
			state.shader = DEFAULT_SHADER;
			state.blending = Blending.ALPHA;
			state.depthMask = DEPTH_TEST;
			state.triangleCulling = TriangleCulling.FRONT;
			
			state.setFragmentConstant(0, 1., 1., 1., 1.);
			state.setFragmentConstant(1, 0.8, 12., 2.);
			state.setFragmentConstant(2, direction.x, direction.y, direction.z);
			
			state.setVertexConstantMatrix(0, toScreen);
			
			return true;
		}
		
		public function end(renderer:IRenderer, style:StyleStack):void
		{
			// NOTHING
		}
	}
}