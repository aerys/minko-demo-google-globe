package effect
{
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.type.math.Vector4;
	
	public class GlowShader extends ActionScriptShader
	{
		private var _color	: Vector4	= null;
		private var _blur	: Number	= 0.;
		
		public function GlowShader(blur		: Number	= 0.165,
								   red		: Number	= 1.,
								   green	: Number	= 1.,
								   blue		: Number	= 1.,
								   alpha	: Number	= 1.)
		{
			super();
			
			_blur = blur;
			_color = new Vector4(red, green, blue, alpha);
		}
		
		override protected function getOutputPosition() : SValue
		{
			var pos	: SValue	= vertexPosition.multiply4x4(localToViewMatrix);
			
			pos.scaleBy(float3(1. + _blur, 1. + _blur, 1.));
			
			return pos.multiply4x4(projectionMatrix);
		}
		
		override protected function getOutputColor() : SValue
		{
			var normal 	: SValue	= interpolate(vertexNormal);
			var angle 	: SValue 	= negate(normal.dotProduct3(cameraLocalDirection));
			
			return multiply(_color, power(subtract(0.8, angle), 12.0));
		}
	}
}