package effect
{
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.renderer.state.Blending;
	import aerys.minko.render.renderer.state.RendererState;
	import aerys.minko.render.shader.node.INode;
	import aerys.minko.scene.visitor.data.LocalData;
	import aerys.minko.scene.visitor.data.StyleStack;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.Dictionary;
	
	[StyleParameter(name="basic diffuse map", type="texture")]
	[StyleParameter(name="basic normal map", type="texture")]
	
	public class EarthEffect extends SinglePassEffect
	{
		private var _lightPosition	: Vector4	= new Vector4(0., 0., 500.);
		private var _lightDiffuse	: Vector4	= new Vector4(1., 1., 1.);
		private var _lightAmbient	: Vector4	= new Vector4();
		
		private var _lightVec		: INode	= null;
		private var _eyeVec			: INode	= null;
		private var _halfVector		: INode	= null;
		
		override public function fillRenderState(state 	: RendererState,
												 style	: StyleStack,
												 local	: LocalData,
												 world	: Dictionary) : Boolean
		{
			super.fillRenderState(state, style, local, world);
			
			state.blending = Blending.NORMAL;
	
			return true;
		}
		
		override protected function getOutputPosition() : INode
		{
			var t				: INode	= vertexTangent;
			var n				: INode	= vertexNormal;
			var b				: INode	= cross(n, t);
			var vertexPos 		: INode = vertexPosition;
			var lightPosition	: INode	= cameraLocalPosition;//multiply4x4(combine(0., 0., -5000.), worldToLocalMatrix);
			var lightDirection	: INode	= normalize(subtract(lightPosition, vertexPos));
			
			_lightVec = combine(
				dotProduct3(lightDirection, t),
				dotProduct3(lightDirection, b),
				dotProduct3(lightDirection, n)
			);
			
			/*_eyeVec = combine(
				dotProduct3(lightDirection, t),
				dotProduct3(lightDirection, b),
				dotProduct3(lightDirection, n)
			);
			
			vertexPos = normalize(vertexPos);
			
			_halfVector = normalize(add(vertexPos, lightDirection));
			_halfVector = combine(
				dotProduct3(_halfVector, t),
				dotProduct3(_halfVector, b),
				dotProduct3(_halfVector, n)
			);*/
			
			return vertexClipspacePosition;
		}
	
		override protected function getOutputColor() : INode
		{
			// bump mapping
			var lightVec		: INode		= interpolate(_lightVec);
			
			var uv				: INode		= interpolate(vertexUV);
			var diffuseMaterial	: INode		= sampleTexture(BasicStyle.DIFFUSE_MAP, uv);
			var normal			: INode 	= sampleTexture(BasicStyle.NORMAL_MAP, uv);
			
			normal = subtract(multiply(normal, 2.), 1.);
			normal = normalize(normal);
			
			var lamberFactor	: INode		= max(dotProduct3(lightVec, normal), 0.);
			var illumination	: INode		= multiply(_lightDiffuse, lamberFactor);
			
			illumination = add(_lightAmbient, illumination);
			illumination = pow(illumination, 2.);
			
			// atmosphere
			var atmosphere		: INode		= dotProduct3(interpolate(vertexNormal), cameraLocalDirection);
			
			atmosphere = subtract(1.3, atmosphere);
			atmosphere = pow(atmosphere, 3.);
			atmosphere = multiply(atmosphere, new Vector4(.6, .9, 1.));
			
			//return diffuseMaterial;
			return add(atmosphere, multiply(diffuseMaterial, illumination));
			//return multiply(diffuseMaterial, illumination);
			//return illumination;
			//return lightVec;
		}
	}
}