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
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.display3D.textures.Texture;
	import flash.utils.setTimeout;
	
	public class EarthPass implements IEffectPass
	{
		private static const DEFAULT_SHADER	: Shader	= new EarthShader();
		private static const DEPTH_TEST		: int		= CompareMode.LESS;
		
		private static const VIEW_INVERT	: Matrix4x4	= new Matrix4x4();
		
		public function EarthPass()
		{
		}
		
		public function begin(renderer : IRenderer, style : StyleStack) : Boolean
		{
			var state 		: RenderState 	= renderer.state;
			var toScreen	: Matrix4x4		= style.get(BasicStyle.LOCAL_TO_SCREEN_MATRIX)
											  as Matrix4x4;
			var blending	: uint			= style.get(BasicStyle.BLENDING, Blending.NORMAL)
											  as uint;
			var viewMatrix	: Matrix4x4		= style.get(BasicStyle.VIEW_MATRIX) as Matrix4x4;
			var diffuse		: Texture		= style.get(BasicStyle.DIFFUSE_MAP, null)
											  as Texture;
			
			Matrix4x4.invert(viewMatrix, VIEW_INVERT);
			var direction : Vector4 = VIEW_INVERT.multiplyVector(ConstVector4.Z_AXIS);
			
			direction.normalize();
	
			state.shader = DEFAULT_SHADER;
			state.blending = Blending.NORMAL;
			state.depthMask = DEPTH_TEST;
			
			state.setTextureAt(0, diffuse);
		
			state.setFragmentConstant(0, direction.x, direction.y, direction.z);
			state.setFragmentConstant(1, 1.05, 3., 2.);
			state.setFragmentConstant(2, 1., 1., 1., 1.);
			
			state.setVertexConstantMatrix(0, toScreen);
			
			return true;
		}
		
		public function end(renderer:IRenderer, style:StyleStack):void
		{
		}
	}
}