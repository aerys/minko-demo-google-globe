package render
{
	import aerys.minko.ns.minko;
	import aerys.minko.render.shader.DynamicShader;
	import aerys.minko.render.shader.node.IShaderNode;
	import aerys.minko.render.shader.node.leaf.Attribute;
	import aerys.minko.render.shader.node.leaf.Constant;
	import aerys.minko.render.shader.node.leaf.Sampler;
	import aerys.minko.render.shader.node.leaf.TransformParameter;
	import aerys.minko.render.shader.node.leaf.WorldParameter;
	import aerys.minko.render.shader.node.operation.other.Texture;
	import aerys.minko.render.shader.node.operation.scalar.Add;
	import aerys.minko.render.shader.node.operation.scalar.Multiply;
	import aerys.minko.render.shader.node.operation.scalar.Power;
	import aerys.minko.render.shader.node.operation.scalar.Substract;
	import aerys.minko.render.shader.node.operation.vector.DotProduct3;
	import aerys.minko.render.shader.node.operation.vector.DotProduct4;
	import aerys.minko.render.shader.node.operation.vector.Multiply4x4;
	import aerys.minko.render.shader.node.operation.virtual.Combine;
	import aerys.minko.render.shader.node.operation.virtual.Interpolate;
	import aerys.minko.scene.visitor.data.CameraData;
	import aerys.minko.scene.visitor.data.TransformData;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	import aerys.minko.type.vertex.format.VertexComponent;
	
	import flash.geom.Point;

	public class AbstractShader extends DynamicShader
	{
		use namespace minko;
		
		public function AbstractShader()
		{
			super(getOutputPosition(), getOutputColor());
		}
		
		protected function getOutputPosition() : IShaderNode
		{
			throw new Error();
		}
		
		protected function getOutputColor() : IShaderNode
		{
			throw new Error();
		}
		
		protected final function interpolate(value : IShaderNode) : IShaderNode
		{
			return new Interpolate(value);
		}
		
		protected final function combine(value1	: Object,
									     mask1	: uint,
									     value2	: Object,
									     mask2	: uint) : IShaderNode
		{
			return new Combine(getShaderNode(value1), mask1, getShaderNode(value2), mask2);
		}
		
		protected final function sampleTexture(styleName : String, uv : Object) : Texture
		{
			return new Texture(getShaderNode(uv), new Sampler(styleName));
		}
		
		protected final function multiply(value1 : Object, value2 : Object) : IShaderNode
		{
			return new Multiply(getShaderNode(value1), getShaderNode(value2));
		}
		
		protected final function power(base : Object, exp : Object) : IShaderNode
		{
			return new Power(getShaderNode(base), getShaderNode(exp));
		}
		
		protected final function add(value1 : Object, value2 : Object) : IShaderNode
		{
			return new Add(getShaderNode(value1), getShaderNode(value2));
		}
		
		protected final function substract(value1 : Object, value2 : Object) : IShaderNode
		{
			return new Substract(getShaderNode(value1), getShaderNode(value2));
		}
		
		protected final function dotProduct3(u : Object, v : Object) : IShaderNode
		{
			return new DotProduct3(getShaderNode(u), getShaderNode(v));
		}
		
		protected final function dotProduct4(u : Object, v : Object) : IShaderNode
		{
			return new DotProduct4(getShaderNode(u), getShaderNode(v));
		}
		
		protected final function multiply4x4(a : Object, b : Object) : IShaderNode
		{
			return new Multiply4x4(getShaderNode(a), getShaderNode(b));
		}
		
		protected final function getWorldParameter(size		: uint, 
											 	   key		: Class,
												   field	: String	= null, 
												   index	: int		= -1) : IShaderNode
		{
			return new WorldParameter(size, key, field, index);
		}
		
		protected final function get vertexClipspacePosition() : IShaderNode
		{
			return multiply4x4(vertexPosition, localToScreenMatrix);
		}
		
		protected final function get vertexPosition() : IShaderNode
		{
			return new Attribute(VertexComponent.XYZ);
		}
		
		protected final function get vertexColor() : IShaderNode
		{
			return new Attribute(VertexComponent.RGB);
		}
		
		protected final function get vertexUV() : IShaderNode
		{
			return new Attribute(VertexComponent.UV);
		}
		
		protected final function get cameraLocalDirection() : IShaderNode
		{
			return new WorldParameter(3, CameraData, CameraData.LOCAL_DIRECTION);
		}
		
		protected final function get localToScreenMatrix() : IShaderNode
		{
			return new TransformParameter(16, TransformData.LOCAL_TO_SCREEN);
		}
		
		private function getShaderNode(value : Object) : IShaderNode
		{
			if (value is IShaderNode)
				return value as IShaderNode;
			
			var c	: Constant	= new Constant();
			
			if (value is int || value is Number)
			{
				c.constants[0] = value as Number;
			}
			if (value is Point)
			{
				var point	: Point	= value as Point;
				
				c.constants[0] = point.x;
				c.constants[1] = point.y;
			}
			else if (value is Vector4)
			{
				var vector 	: Vector4 	= value as Vector4;
				
				c.constants[0] = vector.x;
				c.constants[1] = vector.y;
				c.constants[2] = vector.z;
				if (!isNaN(vector.w))
					c.constants[3] = vector.w;
			}
			else if (value is Matrix4x4)
			{
				(value as Matrix4x4).getRawData(c.constants);
			}
			
			if (!c)
				throw new Error("Constants can only be int, uint, Number, Point, Vector4 or Matrix4x4 values.");
			
			return c;
		}
	}
}