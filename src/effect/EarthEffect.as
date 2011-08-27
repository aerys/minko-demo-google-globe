package effect
{
	import aerys.minko.render.effect.SinglePassEffect;
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.type.math.Vector4;
	
	[StyleParameter(name="basic diffuse map", type="texture")]
	[StyleParameter(name="basic normal map", type="texture")]
	
	public class EarthEffect extends SinglePassEffect
	{
		private static const ATMOSPHERE			: Boolean	= true;
		private static const ATMOSPHERE_COLOR	: Vector4	= new Vector4(.5, .5, .5);
		
		override protected function getOutputPosition() : SValue
		{
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor() : SValue
		{
			// bump mapping
			var uv				: SValue	= interpolate(vertexUV);
			var diffuseMaterial	: SValue	= sampleTexture(BasicStyle.DIFFUSE, uv);
			var diffuse 		: SValue 	= diffuseMaterial.rgb;
			
			// atmosphere
			if (ATMOSPHERE)
			{
				var atmosphere	: SValue	= negate(dotProduct3(interpolate(vertexNormal),
																 cameraLocalDirection));
				
				atmosphere = subtract(1.4, atmosphere).pow(4.);
				atmosphere.scaleBy(ATMOSPHERE_COLOR);
				
				diffuse.incrementBy(atmosphere);
			}
			
			return float4(diffuse, 1.);
		}
	}
}