package
{
	import away3d.bounds.AxisAlignedBoundingBox;
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.loaders.parsers.OBJParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Vector3D;
	
	import mx.core.FlexTextField;
	
	[SWF(width="1024", height="768", frameRate="60")]
	public class FirstPersonControllerDemo extends Sprite
	{
		private var _awStats:AwayStats;
		
		private var _view3D:View3D;
		private var _camController:FirstPersonController;
		
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		
		private var _directLeft:Boolean = false;
		private var _directRight:Boolean = false;
		private var _directFront:Boolean = false;
		private var _directBack:Boolean = false;
		
		[Embed(source="./back.jpg")]
		private var back:Class;
		
		public function FirstPersonControllerDemo()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			initEngine();
			initModels();
			
			initStats();
			
			//定义相机控制位置
			_camController = new FirstPersonController(this._view3D.camera,0,0,-90,90,8);
			//是否支持直接修改Z值
			_camController.fly = false;
			initListeners();
		}
		
		public function initEngine():void
		{
			_view3D = new View3D();
			_view3D.width = this.width;
			_view3D.height = this.height;
			_view3D.backgroundColor = 0xffffff;
			_view3D.camera.z = -120;
			_view3D.camera.lens.near = 5;
			_view3D.camera.lens.far = 10000;
			addChild(_view3D);
		}
		
		public function initModels():void
		{
			//添加简单模型
			for(var i:int = 0; i < 20; i++)
			{
				var size:Number = Math.random()*80 + 20;
				var cube:CubeGeometry = new CubeGeometry(size, size, size);
				var material:ColorMaterial = new ColorMaterial(0x22ff77);
				var mesh:Mesh = new Mesh(cube, material);
				
				mesh.x = 500 - Math.random() *　1000;
				mesh.z = 500 - Math.random() *　1000;
				mesh.y = size/2;
				this._view3D.scene.addChild(mesh);
			}
			
			//添加底图
			var backGeo:PlaneGeometry = new PlaneGeometry(1500, 1500, 1, 1, true);
			var backMaterial:MaterialBase = new TextureMaterial(new BitmapTexture((new back() as Bitmap).bitmapData));
			backMaterial.bothSides = true;
			var backMesh:Mesh = new Mesh(backGeo, backMaterial);
//			backMesh.y = -10;
			this._view3D.scene.addChild(backMesh);
			
			_view3D.camera.lookAt(new Vector3D(0, 100, 50));
			_view3D.camera.y = 60;
		}
		
		/**
		 * 检测状态面板
		 * */
		public function initStats():void
		{
			_awStats = new AwayStats(_view3D);
			_awStats.y = 20;
			this.addChild(_awStats);
		}
		
		
		public function initListeners():void
		{
			this.addEventListener(Event.ENTER_FRAME, onFrameHandler);
			stage.addEventListener(Event.RESIZE, onResize);
			
			//这里用mouseDown和up来监听鼠标移动，实现视角旋转和拉远拉近的效果
			this.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			//监听键盘移动控制方向实现人物移动效果
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDwonHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			onResize();
		}
		
		private var _speed:int = 3;
		public function onFrameHandler(e:Event):void
		{
			//修改观察角度
			if (move) {
				_camController.panAngle = (stage.mouseX - lastMouseX)/10 + lastPanAngle;
				_camController.tiltAngle = (stage.mouseY - lastMouseY)/10 + lastTiltAngle;
			}
			
			//通过接口incrementStrafe和incrementWalk修改移动方向
			if(_directLeft)
			{
				_camController.incrementStrafe(-_speed);
			}
			if(_directRight)
			{
				_camController.incrementStrafe(_speed);
			}
			if(_directFront)
			{
				_camController.incrementWalk(_speed);
			}
			if(_directBack)
			{
				_camController.incrementWalk(-_speed);
			}
			_view3D.render();
		}
		
		public function onResize(e:Event = null):void
		{
			_view3D.width = stage.width;
			_view3D.height = stage.height;
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			//记录原始值
			lastPanAngle = _camController.panAngle;
			lastTiltAngle = _camController.tiltAngle;
			
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		
		//拉近相机
		private function wheelHandler(event:MouseEvent):void
		{
			if(event.delta > 0)
			{
				_view3D.camera.moveBackward(20);
			}
			else
			{
				_view3D.camera.moveForward(20);
			}
		}
		
		//设置移动方向
		private function keyDwonHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 38 || event.keyCode == 87)
			{
				_directFront = true;
			}
			else if(event.keyCode == 40 || event.keyCode == 83)
			{
				_directBack = true;
				
			}
			else if(event.keyCode == 39 || event.keyCode == 68)
			{
				_directRight = true;
			}
			else if(event.keyCode == 37 || event.keyCode == 65)
			{
				_directLeft = true;
			}
		}
		
		//清除移动方向
		private function keyUpHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 38 || event.keyCode == 87)
			{
				_directFront = false;
			}
			else if(event.keyCode == 40 || event.keyCode == 83)
			{
				_directBack = false;
			}
			else if(event.keyCode == 39 || event.keyCode == 68)
			{
				_directRight = false;
			}
			else if(event.keyCode == 37 || event.keyCode == 65)
			{
				_directLeft = false;
			}
		}
	}
}