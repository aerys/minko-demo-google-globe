package
{
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.node.camera.ArcBallCamera;
	import aerys.minko.scene.node.group.Group;
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
	import scene.Atmosphere;
	import scene.Earth;
	import scene.Globe;
	
//	[SWF(width=800,height=600)]
	
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
		[Embed("../assets/population2000.qark",mimeType="application/octet-stream")]
		private static const ASSET_POPULATION_QARK	: Class;
		
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
		
		private var _viewport		: Viewport			= new Viewport(0., 0., 2);
		private var _camera			: ArcBallCamera		= new ArcBallCamera();
		private var _globe			: Globe				= new Globe();
		private var _scene			: Group				= new Group(_camera,
																	_globe,
																	new Earth(),
																	new Atmosphere());
		
		private var _cursor			: Point				= new Point();
		private var _speed			: Vector4			= new Vector4();
		private var _initialized	: Boolean			= false;
		
		private var _text			: TextField			= new TextField();
	
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
			
//			initializeMonitor();
			initializeUI();
			initializeScene();
			
			stage.frameRate = 60.;
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function initializeScene() : void
		{
			_viewport.defaultEffect = null;
			addChild(_viewport);
			
			loadPopulationData();
			//loadSearchData();
			
			_camera.distance = MIN_ZOOM;
			new EazeTween(_camera.rotation).to(1, {y: Math.PI * 2., x: -.5})
										   .onComplete(cameraTweenComplete);
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
			_text.textColor = 0xffffffff;
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.x = 30.;
			_text.y = 30.;
			addChild(_text);
		}
		
		private function loadPopulationData() : void
		{
			var data		: Array	= Qark.decode(new ASSET_POPULATION_QARK());
			var numPoints 	: int 	= data.length;
			
			_text.htmlText = '<font size="20px">World Population</font>';
			
			for (var i : int = 0; i < numPoints; ++i)
			{				
				_globe.addPoint(
					data[i][0],
					data[i][1],
					data[i][2] * 130,
					ColorUtils.hsvToRgb(.6 - (data[i][2] * .5), 1., 1.)
				);
			}
		}
		
		private function loadSearchData() : void
		{
			var data		: Array	= Qark.decode(new ASSET_SEARCH_QARK());
			var numPoints 	: int 	= data.length;
			var j			: int	= 0;

			_text.htmlText = '<font size="20px">Google Search Volume by Language</font>';
			
			for (var i : int = 0; i < numPoints; ++i, j++)
			{
				var color : uint = COLORS[data[i][3]];

				if (!color)
				{
					COLORS[data[i][3]] = color = ((Math.random() * 255) << 16)
											  	 + ((Math.random() * 255) << 8)
												 + (Math.random() * 255);
				}
				
				_globe.addPoint(
					data[i][0],
					data[i][1],
					data[i][2] * 130,
					color
				);
			}
		}
		
		private function encodePopulationData(populationData : String) : ByteArray
		{
			var data 		: Array = populationData.match(/([\-0-9.]+)/g);
			var numPoints 	: int 	= data.length / 3;
			var j			: int	= 0;
			var output		: Array	= new Array();

			for (var i : int = 0; i < numPoints; ++i)
			{
				output.push([parseFloat(data[int(i * 3)]),
							 parseFloat(data[int(i * 3 + 1)]),
							 parseFloat(data[int(i * 3 + 2)])]);
			}
			
			return Qark.encode(output);
		}
		
		private function encodeSearchData(searchData : String) : ByteArray
		{
			var data 		: Array = searchData.match(/([\-0-9.]+)/g);
			var numPoints 	: int 	= data.length / 4;
			var output		: Array	= new Array();

			for (var i : int = 0; i < numPoints; ++i)
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