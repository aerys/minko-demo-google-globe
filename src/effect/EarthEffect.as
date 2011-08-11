package effect
{
	import aerys.minko.render.effect.SinglePassEffect;
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.renderer.state.Blending;
	import aerys.minko.render.renderer.state.RendererState;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.scene.data.LocalData;
	import aerys.minko.scene.data.StyleStack;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	[StyleParameter(name="basic diffuse map", type="texture")]
	[StyleParameter(name="basic normal map", type="texture")]
	
	public class EarthEffect extends SinglePassEffect
	{
		private static const BUMP_MAPPING	: Boolean	= true;
		private static const SPECULAR		: Boolean	= true;
		private static const ATMOSPHERE		: Boolean	= true;

		private static const LIGHT_POSITION		: Vector4	= new Vector4(0., 0., 500.);
		private static const LIGHT_DIFFUSE		: Vector4	= new Vector4(.8, .8, .8);
		private static const LIGHT_SPECULAR		: Vector4	= new Vector4(.3, .3, .3);
		private static const LIGHT_AMBIENT		: Vector4	= new Vector4(.1, .1, .1);
		private static const LIGHT_SHININESS	: Number	= 8.;
		
		private var _lightVec		: SValue	= null;
		private var _eyeVec			: SValue	= null;
		private var _halfVector		: SValue	= null;
		
		override protected function getOutputPosition() : SValue
		{
			var vertexBitangent	: SValue	= cross(vertexNormal, vertexTangent);
			var lightPosition	: SValue	= cameraLocalPosition;
			var lightDirection	: SValue	= normalize(subtract(lightPosition, vertexPosition));
			
			_lightVec = float3(
				dotProduct3(lightDirection, vertexTangent),
				dotProduct3(lightDirection, vertexBitangent),
				dotProduct3(lightDirection, vertexNormal)
			);
			
			_eyeVec = normalize(subtract(vertexPosition, cameraLocalPosition));
			_eyeVec = float3(
				dotProduct3(_eyeVec, vertexTangent),
				dotProduct3(_eyeVec, vertexBitangent),
				dotProduct3(_eyeVec, vertexNormal)
			);
			
			var vertexPos : SValue = normalize(vertexPosition);
			
			_halfVector = normalize(add(vertexPos, lightDirection));
			_halfVector = float3(
				dotProduct3(_halfVector, vertexTangent),
				dotProduct3(_halfVector, vertexBitangent),
				dotProduct3(_halfVector, vertexNormal)
			);
			
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor() : SValue
		{
			// bump mapping
			var lightVec		: SValue	= interpolate(_lightVec);
			var uv				: SValue	= interpolate(vertexUV);
			var diffuseMaterial	: SValue	= sampleTexture(BasicStyle.DIFFUSE, uv);
			var diffuse 		: SValue 	= diffuseMaterial.rgb;
			var illumination	: SValue	= float3(LIGHT_AMBIENT);
			
			if (BUMP_MAPPING)
			{
				var normal	: SValue 	= sampleTexture(BasicStyle.NORMAL_MAP, uv);
				
				normal = subtract(normal.multiply(2.), 1.);
				normal.normalize();
				
				var lamberFactor	: SValue	= max(dotProduct3(lightVec, normal), 0.);
				
				illumination.incrementBy(multiply(LIGHT_DIFFUSE, lamberFactor));
				
				if (SPECULAR)
				{
					var ref			: SValue	= getReflectedVector(lightVec, normal);
					var halfVector	: SValue	= interpolate(_halfVector);
					var shininess	: SValue	= power(max(dotProduct3(ref, halfVector), 0.),
													  	LIGHT_SHININESS);
					
					illumination.incrementBy(shininess.multiply(LIGHT_SPECULAR));
				}
			}
			
			diffuse.scaleBy(illumination);
			
			// atmosphere
			if (ATMOSPHERE)
			{
				var atmosphere	: SValue	= negate(dotProduct3(interpolate(vertexNormal),
																 cameraLocalDirection));
				
				atmosphere = subtract(1.4, atmosphere).pow(4.);
				atmosphere.scaleBy(new Vector4(.6, .9, 1.));
				
				diffuse.incrementBy(atmosphere);
			}
			
			return float4(diffuse, 1.);
		}
	}
}