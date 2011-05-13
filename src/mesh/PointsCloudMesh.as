package mesh
{
	import aerys.minko.scene.graph.mesh.Mesh;
	import aerys.minko.scene.visitor.ISceneVisitor;
	import aerys.minko.type.Transform3D;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.stream.IndexStream;
	import aerys.minko.type.stream.VertexStream;
	import aerys.minko.type.stream.VertexStreamList;
	import aerys.minko.type.vertex.VertexIterator;
	import aerys.minko.type.vertex.VertexReference;
	import aerys.minko.type.vertex.format.VertexComponent;
	import aerys.minko.type.vertex.format.VertexFormat;

	public class PointsCloudMesh extends Mesh
	{
		private static const FORMAT			: VertexFormat		= new VertexFormat(VertexComponent.XYZ,
																				   VertexComponent.RGB);
		private static const TMP_VERTICES	: Vector.<Number>	= new Vector.<Number>();
		private static const INDICES		: Vector.<uint>		= Vector.<uint>([
			5, 7, 6, 5, 4, 7, 0, 4, 5, 0, 5, 1, 1, 5, 2, 5, 6, 2, 2, 6, 7, 2, 7, 3, 3, 7, 4, 3, 4, 0
		]);
		private static const VERTICES		: Vector.<Number> 	= Vector.<Number>([
			.5, .5, .5, -.5, .5, .5, -.5, .5, -.5, .5, .5, -.5,
			.5, -.5, .5, -.5, -.5, .5, -.5, -.5, -.5, .5, -.5, -.5
		]);
		
		private var _numPoints	: uint =	 0;
		
		public function get numPoints() : uint	{ return _numPoints; }
		
		public function PointsCloudMesh()
		{
			super(new VertexStreamList(new VertexStream(new Vector.<Number>(), FORMAT)),
				  new IndexStream(null, 0));
		}
		
		public function addPoint(lat	: Number,
								 lng	: Number,
								 size	: Number,
								 color 	: uint) : void
		{
			var stream 		: VertexStream 		= vertexStreamList.getVertexStream();
			var transform	: Transform3D		= new Transform3D();
			var phi			: Number			= (90. - lat) * Math.PI / 180.;
			var theta		: Number			= (180. - lng) * Math.PI / 180.;
			var radius		: int				= 100;
			var vertices 	: VertexIterator 	= new VertexIterator(stream, indexStream);
			
			transform.appendScale(.35, .35, size || .1)
					 .appendTranslation(radius * Math.sin(phi) * Math.cos(theta),
										radius * Math.cos(phi),
										-radius * Math.sin(phi) * Math.sin(theta))
					 .pointAt(ConstVector4.ZERO);
			
			TMP_VERTICES.length = 0;
			transform.multiplyRawVectors(VERTICES, TMP_VERTICES);
			
			for (var i : int = 0; i < 8; ++i)
			{
				// fast but unclear
				stream.push(TMP_VERTICES[int(i * 3)],
							TMP_VERTICES[int(i * 3 + 1)],
							TMP_VERTICES[int(i * 3 + 2)],
							((color >> 16) & 0xff) / 255.,
							((color >> 8) & 0xff) / 255.,
							(color & 0xff) / 255.);
				
				// slow but convenient
				/*var vertex : VertexReference = new VertexReference(stream);
				
				vertex.x = TMP_VERTICES[int(i * 3)];
				vertex.y = TMP_VERTICES[int(i * 3 + 1)];
				vertex.z = TMP_VERTICES[int(i * 3 + 2)];
				vertex.r = ((color >> 16) & 0xff) / 255.;
				vertex.g = ((color >> 8) & 0xff) / 255.;
				vertex.b = (color & 0xff) / 255.;*/
			}
			
			indexStream.pushIndices(INDICES, _numPoints * 8);
			
			++_numPoints;
		}
	}
}