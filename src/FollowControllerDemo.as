package
{
	import away3d.bounds.AxisAlignedBoundingBox;
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.controllers.FollowController;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
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
	
	import flashx.textLayout.events.ModelChange;
	
	import mx.core.FlexTextField;
	
	[SWF(width="1024", height="768", frameRate="60")]
	public class FollowControllerDemo extends Sprite
	{
		private var _awStats:AwayStats;
		
		private var _view3D:View3D;
		private var _camController:FollowController;
		
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		
		private var _directLeft:Boolean = false;
		private var _directRight:Boolean = false;
		private var _directFront:Boolean = false;
		private var _directBack:Boolean = false;
		
//		[Embed(source="./back.jpg")]
//		private var back:Class;
		
		[Embed(source="./car.obj",  mimeType="application/octet-stream")]
		private var carModel:Class;
		
		private var lookAtMesh:ObjectContainer3D;
		
		public function FollowControllerDemo()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void
		{
			initEngine();
			initModels();
			initStats();
			//定义相机控制，等模型初始完成后再赋值lookAtObject属性
			_camController = new FollowController(this._view3D.camera, null, 30, 120);
			_camController.minTiltAngle = 2;
			initListeners();
		}
		
		public function initEngine():void
		{
			_view3D = new View3D();
			_view3D.width = this.width;
			_view3D.height = this.height;
			_view3D.backgroundColor = 0xffffff;
			_view3D.camera.z = -50;
			_view3D.camera.lens.near = 1;
			_view3D.camera.lens.far = 10000;
			addChild(_view3D);
		}
		
		public function initModels():void
		{
			//添加简单模型
			for(var i:int = 0; i < 20; i++)
			{
				var size:Number = Math.random()*20 + 5;
				var cube:CubeGeometry = new CubeGeometry(size, size, size);
				var material:ColorMaterial = new ColorMaterial(0x22ff77);
				var mesh:Mesh = new Mesh(cube, material);
				
				mesh.x = 150 - Math.random() *　300;
				mesh.z = 150 - Math.random() *　300;
				mesh.y = size/2;
				this._view3D.scene.addChild(mesh);
			}
			
			//添加底图
//			var backGeo:PlaneGeometry = new PlaneGeometry(300, 300, 1, 1, true);
//			var backMaterial:MaterialBase = new TextureMaterial(new BitmapTexture((new back() as Bitmap).bitmapData));
//			backMaterial.bothSides = true;
//			var backMesh:Mesh = new Mesh(backGeo, backMaterial);
//			this._view3D.scene.addChild(backMesh);
			
			//添加操作模型
			var loader3D:Loader3D = new Loader3D;
			AssetLibrary.enableParser(OBJParser);
			loader3D.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onComplete);
			loader3D.loadData(new carModel());
		}
		
		private function onComplete(event:LoaderEvent):void
		{
			if (event.target is ObjectContainer3D) {
				lookAtMesh = event.target as ObjectContainer3D;
				lookAtMesh.y = 0.5;
				_view3D.scene.addChild(lookAtMesh);
				if(_camController)
				{
					_camController.lookAtObject = lookAtMesh;
				}
			}
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
		
		private var _speed:Number = 0.3;
		public function onFrameHandler(e:Event):void
		{
			//修改观察角度
			if (move) {
				//因为是跟随物体，所以只能通过跟随物体的Y旋转来修改视角的水平旋转pan角度，区别于HoverControoler
				lookAtMesh.rotationY = (stage.mouseX - lastMouseX) > 0 ? (lookAtMesh.rotationY - 2) : (lookAtMesh.rotationY + 2);
				
				_camController.tiltAngle = (stage.mouseY - lastMouseY)/10 + lastTiltAngle;
			}
			
			//通过修改物体坐标来控制相机视角位置
			if(!lookAtMesh)
				return;
			//因为用户查看的视角是根据当前旋转角度来计算的，素以前进的速度也需要按照当前的坐标进行变化
			var xSpeed:Number;
			var zSpeed:Number;
			if(_directLeft)
			{
				xSpeed = Math.sin((lookAtMesh.rotationY - 90)/ 180 * Math.PI) * _speed;
				zSpeed = Math.cos((lookAtMesh.rotationY - 90)/ 180 * Math.PI) * _speed;
				lookAtMesh.z += zSpeed;
				lookAtMesh.x += xSpeed;
			}
			if(_directRight)
			{
				xSpeed = Math.sin((lookAtMesh.rotationY + 90)/ 180 * Math.PI) * _speed;
				zSpeed = Math.cos((lookAtMesh.rotationY + 90)/ 180 * Math.PI) * _speed;
				lookAtMesh.z += zSpeed;
				lookAtMesh.x += xSpeed;
			}
			if(_directFront)
			{
				xSpeed = Math.sin(lookAtMesh.rotationY / 180 * Math.PI) * _speed;
				zSpeed = Math.cos(lookAtMesh.rotationY / 180 * Math.PI) * _speed;
				lookAtMesh.z += zSpeed;
				lookAtMesh.x += xSpeed;
			}
			if(_directBack)
			{
				xSpeed = Math.sin((lookAtMesh.rotationY - 180)/ 180 * Math.PI) * _speed;
				zSpeed = Math.cos((lookAtMesh.rotationY -180)/ 180 * Math.PI) * _speed;
				lookAtMesh.z += zSpeed;
				lookAtMesh.x += xSpeed;
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
				if(_camController.distance > 8)
					_camController.distance -= 5;
			}
			else
			{
				if(_camController.distance <　120)
					_camController.distance += 5;
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