package effect
{
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.renderer.state.Blending;
	import aerys.minko.render.renderer.state.RendererState;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.render.shader.node.Components;
	import aerys.minko.render.shader.node.INode;
	import aerys.minko.render.shader.node.operation.manipulation.Extract;
	import aerys.minko.scene.visitor.data.LocalData;
	import aerys.minko.scene.visitor.data.StyleStack;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	[StyleParameter(name="basic diffuse map", type="texture")]
	[StyleParameter(name="basic normal map", type="texture")]
	
	public class EarthEffect extends SinglePassEffect
	{
		private static const SPECULAR	: Boolean	= true;
		private static const ATMOSPHERE	: Boolean	= true;
		
		private var _lightPosition	: Vector4	= new Vector4(0., 0., 500.);
		private var _lightDiffuse	: Vector4	= new Vector4(1., 1., 1.);
		private var _lightAmbient	: Vector4	= new Vector4();
		
		private var _lightVec		: SValue	= null;
		private var _eyeVec			: SValue	= null;
		private var _halfVector		: SValue	= null;
		
		override public function fillRenderState(state 	: RendererState,
												 style	: StyleStack,
												 local	: LocalData,
												 world	: Dictionary) : Boolean
		{
			super.fillRenderState(state, style, local, world);
			
			state.blending = Blending.NORMAL;
	
			return true;
		}
		
		override protected function getOutputPosition() : SValue
		{
			var vertexBitangent	: SValue	= cross(vertexNormal, vertexTangent);
			var lightPosition	: SValue	= cameraLocalPosition;
			var lightDirection	: SValue	= normalize(subtract(lightPosition, vertexPosition));
			
			_lightVec = vector3(
				dotProduct3(lightDirection, vertexTangent),
				dotProduct3(lightDirection, vertexBitangent),
				dotProduct3(lightDirection, vertexNormal)
			);
			
			_eyeVec = normalize(subtract(vertexPosition, cameraLocalPosition));
			_eyeVec = vector3(
				dotProduct3(_eyeVec, vertexTangent),
				dotProduct3(_eyeVec, vertexBitangent),
				dotProduct3(_eyeVec, vertexNormal)
			);
			
			var vertexPos : SValue = normalize(vertexPosition);
			
			_halfVector = normalize(add(vertexPos, lightDirection));
			_halfVector = vector3(
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
			var diffuseMaterial	: SValue	= sampleTexture(BasicStyle.DIFFUSE_MAP, uv);
			var normal			: SValue 	= sampleTexture(BasicStyle.NORMAL_MAP, uv);
			
			normal = subtract(normal.multiply(2.), 1.);
			normal.normalize();
			
			var lamberFactor	: SValue	= max(dotProduct3(lightVec, normal), 0.);
			var illumination	: SValue	= multiply(_lightDiffuse, lamberFactor);
			
			illumination.add(_lightAmbient);
			illumination = illumination.pow(2.);
			
			if (SPECULAR)
			{
				var ref			: SValue	= planarReflection(lightVec, normal);
				var halfVector	: SValue	= interpolate(_halfVector);
				var shininess	: SValue	= pow(max(dotProduct3(ref, interpolate(_eyeVec)), 0.0), 2.0);

				illumination.increment(shininess);
			}
			
			var diffuse : SValue = multiply(diffuseMaterial, illumination);
			
			// atmosphere
			if (ATMOSPHERE)
			{
				var atmosphere	: SValue	= dotProduct3(interpolate(vertexNormal), cameraLocalDirection);
				
				atmosphere = subtract(1.3, atmosphere).pow(3.);
				atmosphere.scale(new Vector4(.6, .9, 1.));
				
				diffuse.increment(atmosphere);
			}
			
			return diffuse;
		}
	}
}