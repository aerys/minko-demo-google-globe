package
{
	import aerys.minko.effect.basic.BasicEffect;
	import aerys.minko.scene.graph.Loader3D;
	import aerys.minko.scene.graph.Model;
	import aerys.minko.scene.graph.camera.ArcBallCamera;
	import aerys.minko.scene.graph.group.EffectGroup;
	import aerys.minko.scene.graph.group.Group;
	import aerys.minko.scene.graph.mesh.modifier.NormalMesh;
	import aerys.minko.scene.graph.mesh.primitive.SphereMesh;
	import aerys.minko.stage.Viewport;
	import aerys.minko.type.math.Vector4;
	import aerys.monitor.Monitor;
	import aerys.qark.Qark;
	
	import aze.motion.EazeTween;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	
	import render.AtmosphereEffect;
	import render.ColorEffect;
	import render.EarthEffect;
	
	[SWF(width=800,height=600)]
	
	public class Main extends Sprite
	{
		[Embed("../assets/world.jpg")]
		private static const ASSET_WORLD_DIFFUSE	: Class;
		/*[Embed("../assets/search.json",mimeType="application/octet-stream")]
		private static const ASSET_SEARCH_JSON		: Class;*/
		[Embed("../assets/search.qark",mimeType="application/octet-stream")]
		private static const ASSET_SEARCH_QARK		: Class;
		/*[Embed("../assets/population2000.json",mimeType="application/octet-stream")]
		private static const ASSET_POPULATION_JSON	: Class;*/
		
		private static const MOUSE_SENSITIVITY		: Number	= .0006;
		private static const SPEED_SCALE			: Number	= .9;
		private static const MAX_POINTS_PER_MESH	: uint		= 8000.;
		private static const MAX_ZOOM				: Number	= 200.;
		private static const MIN_ZOOM				: Number	= 320.;
		private static const COLORS					: Array		= [0xd9d9d9, 0xb6b4b5, 0x9966cc, 0x15adff, 0x3e66a3,
																   0x216288, 0xff7e7e, 0xff1f13, 0xc0120b, 0x5a1301,
																   0xffcc02, 0xedb113, 0x9fce66, 0x0c9a39, 0xfe9872,
																   0x7f3f98, 0xf26522, 0x2bb673, 0xd7df23, 0xe6b23a,
																   0x7ed3f7];
		
		private var _viewport		: Viewport			= null;
		private var _camera			: ArcBallCamera		= new ArcBallCamera();
		private var _cloud			: EffectGroup		= new EffectGroup();
		private var _scene			: Group				= new Group(_camera,
																	_cloud);
		
		private var _cursor			: Point				= new Point();
		private var _speed			: Vector4			= new Vector4();
		private var _initialized	: Boolean			= false;
	
		public function Main()
		{
			if (stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(event : Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			_viewport = Viewport.setupOnStage(stage, 8);
			_viewport.defaultEffect = null;
						
			var sphere : SphereMesh = new SphereMesh(40);
			var earth : Model = new Model(sphere,
										  Loader3D.loadAsset(ASSET_WORLD_DIFFUSE)[0]);
				
			earth.transform.appendUniformScale(200.);
			earth.effects[0] = new EarthEffect();
			_scene.addChild(earth);
		
			_cloud.effects[0] = new ColorEffect();
			
			loadSearchData();
			
			var atm : Model = new Model(sphere);
			
			atm.transform.appendUniformScale(233.);
			atm.effects[0] = new AtmosphereEffect();
			_scene.addChild(atm);
			
//			new FileReference().save(encodeSearchData(), "search.qark");

			_camera.distance = MIN_ZOOM;
			//_camera.farClipping = 2000.;
			//new EazeTween(_camera).from(1, {distance: 2000});
			new EazeTween(_camera.rotation).to(1, {y: Math.PI * 2.,
												   x: -.5})
										   .onComplete(cameraTweenComplete);
			
			//initializeMonitor();
			initializeUI();
			
			stage.frameRate = 60.;
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function cameraTweenComplete() : void
		{
			_initialized = true;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		private function initializeMonitor() : void
		{
			Monitor.monitor.watch(_viewport, ["numTriangles"]);
			addChild(Monitor.monitor);
		}
		
		private function initializeUI() : void
		{
			var textField : TextField = new TextField();
			
			textField.htmlText = '<font size="20px">Google Search Volume by Language</font>';
			textField.textColor = 0xffffffff;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.x = 30.;
			textField.y = 30.;
			addChild(textField);
		}
		
		private function loadSearchData() : void
		{
			var data		: Array				= Qark.decode(new ASSET_SEARCH_QARK());
			var points		: PointsCloudMesh	= new PointsCloudMesh();
			var numPoints 	: int 				= data.length;
			var j			: int				= 0;
			
			for (var i : int = 0; i < numPoints; ++i, j++)
			{
				var color : uint = COLORS[data[i][3]];

				if (!color)
				{
					COLORS[data[i][3]] = color = ((Math.random() * 255) << 16)
											  	 + ((Math.random() * 255) << 8)
												 + (Math.random() * 255);
				}
				
				if (j >= MAX_POINTS_PER_MESH)
				{
					_cloud.addChild(points);
					points = new PointsCloudMesh();
					
					j = 0;
				}
				
				points.addPoint(
					data[i][0],
					data[i][1],
					data[i][2] * 130,
					color
				);
			}
			
			_cloud.addChild(points);
		}
		
		private function encodeSearchData(searchData : String) : ByteArray
		{
			var data 		: Array = searchData.match(/([\-0-9.]+)/g);
			var numPoints 	: int 	= data.length / 4;
			var j			: int	= 0;
			var output		: Array	= new Array();

			for (var i : int = 0; i < numPoints; ++i, j++)
			{
				output.push([parseFloat(data[int(i * 4)]),
							 parseFloat(data[int(i * 4 + 1)]),
							 parseFloat(data[int(i * 4 + 2)]),
							 parseInt(data[int(i * 4 + 3)])]);
			}
			
			return Qark.encode(output);
		}
		
		private function enterFrameHandler(event : Event) : void
		{
			if (_initialized)
			{
				_camera.rotation.add(_speed);
				_camera.distance += _speed.z;
				_speed.scaleBy(SPEED_SCALE);
				
				if (_camera.distance < MAX_ZOOM)
					_camera.distance = MAX_ZOOM;
				else if (_camera.distance > MIN_ZOOM)
					_camera.distance = MIN_ZOOM;
			}
				
			_viewport.render(_scene);
		}
		
		private function mouseMoveHandler(event : MouseEvent) : void
		{
			if (event.buttonDown)
			{
				_speed.y -= (event.stageX - _cursor.x) * MOUSE_SENSITIVITY;
				_speed.x -= (event.stageY - _cursor.y) * MOUSE_SENSITIVITY;
			}		
			
			_cursor.x = event.stageX;
			_cursor.y = event.stageY;
		}
		
		private function mouseWheelHandler(event : MouseEvent) : void
		{
			_speed.z -= event.delta * .5;
		}
	}
}