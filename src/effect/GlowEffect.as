package effect
{
	import aerys.minko.render.renderer.state.RendererState;
	import aerys.minko.render.renderer.state.TriangleCulling;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.scene.visitor.data.LocalData;
	import aerys.minko.scene.visitor.data.StyleStack;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	
	public class GlowEffect extends SinglePassEffect
	{
		private var _color	: Vector4	= null;
		private var _blur	: Number	= 0.;
		
		public function GlowEffect(blur		: Number	= 0.165,
								   red		: Number	= 1.,
								   green	: Number	= 1.,
								   blue		: Number	= 1.,
								   alpha	: Number	= 1.)
		{
			super();
			
			_blur = blur;
			_color = new Vector4(red, green, blue, alpha);
		}
		
		override public function fillRenderState(state	: RendererState,
						 						 style	: StyleStack, 
												 local	: LocalData,
												 world	: Dictionary) : Boolean
		{
			super.fillRenderState(state, style, local, world);
			
			state.triangleCulling = TriangleCulling.FRONT;
			state.priority = 0.;
			
			return true;
		}
		
		override protected function getOutputPosition() : SValue
		{
			var pos	: SValue	= vertexPosition.multiply4x4(localToViewMatrix);
			
			pos.scaleBy(vector3(1. + _blur, 1. + _blur, 1.));
			
			return pos.multiply4x4(projectionMatrix);
		}
		
		override protected function getOutputColor() : SValue
		{
			var normal 	: SValue	= interpolate(vertexNormal);
			var angle 	: SValue 	= normal.dotProduct3(cameraLocalDirection);
			
			return multiply(_color, (power(subtract(0.8, angle), 12.0)));
		}
	}
}