package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.MD2Parser;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	
	[SWF(width="1000",height="800",frameRate="60",backgroundColor="0xffffff")]
	public class Test extends Sprite
	{
		
		[Embed(source="../embeds/pknight/pknight1.png")]
		public static var PKnightTexture1:Class;
		
		[Embed(source="../embeds/rockbase_diffuse.jpg")]
		private var FloorDiffuse:Class;
		
		
		private var _view3d:View3D;
		private var _camera3d:Camera3D;
		private var controller:HoverController;
		private var stageMouseX:Number;
		private var stageMouseY:Number;

		private var mesh:Mesh;

		private var vertexAnimationSet:VertexAnimationSet;
		
		//背景
		private var ground:Mesh;
		private var groundMaterial:TextureMaterial;
		
		
		
		
		public function Test()
		{
			super();
			_view3d = new View3D();
			_view3d.width = 800;
			_view3d.height = 600;
			//窗口的背景颜色
			_view3d.backgroundColor = 0x0;
			addChild(_view3d);
			//相机设置
			_camera3d = _view3d.camera;
			_camera3d.lookAt(new Vector3D());
			//相机控制
			controller = new HoverController(_camera3d);
			//左右旋转角度设置
//			controller.minPanAngle = 0;
//			controller.maxPanAngle = 90;
			//上下选择角度设置
			controller.minTiltAngle = -45;
			controller.maxTiltAngle = 45;
			
			controller.panAngle = 180;
			controller.tiltAngle = 0;
			
//			cameraController.distance = 1000;
//			cameraController.minTiltAngle = 0;
//			cameraController.maxTiltAngle = 90;
//			cameraController.panAngle = 45;
//			cameraController.tiltAngle = 20;
			//加载一个3d模型
			Loader3D.enableParser(Max3DSParser);
			var loader3D:Loader3D = new Loader3D();
//			loader3D.addEventListener(
//			loader3D.load(new URLRequest("../assets/hero1.3ds"));
//			loader3D.scale(8);
//			_view3d.scene.addChild(loader3D);
			
			//md2模型
			testMD2();
			
			
			
			//添加坐标
			var trient:Trident = new Trident();
			_view3d.scene.addChild(trient);
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame,false,0,true);
			addEventListener(MouseEvent.MOUSE_WHEEL,onWheel,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
			
			init3D();
		}
		
		private function init3D():void
		{
			groundMaterial = new TextureMaterial(Cast.bitmapTexture(FloorDiffuse));
			groundMaterial.smooth = true;
			groundMaterial.repeat = true;
			groundMaterial.mipmap = true;
			ground = new Mesh(new PlaneGeometry(50000,50000,200,200),groundMaterial);
//			_view3d.scene.addChild(ground);
		}
		
		private function testMD2():void
		{
			Loader3D.enableParser(MD2Parser);
			AssetLibrary.load(new URLRequest("../embeds/pknight/pknight.md2"));
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE,onAssetComplete);
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE,onAllComplete);
			function onAssetComplete(evt:AssetEvent):void
			{
				var assetType:String = evt.asset.assetType;
				//模型网格
				if(assetType == AssetType.MESH)
				{
					mesh = evt.asset as Mesh;
//					mesh.showBounds = true;
					mesh.scale(10);
					mesh.mouseEnabled = true;
					//3d鼠标事件
					mesh.addEventListener(MouseEvent3D.MOUSE_OVER,onMouseOver);
					mesh.addEventListener(MouseEvent3D.MOUSE_OUT,onMouseOut);
					mesh.addEventListener(MouseEvent3D.MOUSE_DOWN,onMouseDown3D);
				} else if(assetType == AssetType.ANIMATION_SET)
				{ //顶点动画
					vertexAnimationSet = evt.asset as VertexAnimationSet;
				}
			}
			
			function onAllComplete(evt:LoaderEvent):void
			{
				trace("onAllComplete");
				var bitmapData:BitmapData = (new PKnightTexture1() as Bitmap).bitmapData;
				var textureMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(bitmapData));
				//设置皮肤
				mesh.material = textureMaterial;
				//设置动画
				var vertexAnimator:VertexAnimator = new VertexAnimator(vertexAnimationSet);
				mesh.animator = vertexAnimator;
				vertexAnimator.play("run");
				_view3d.scene.addChild(mesh);
			}
		}
		
		protected function onMouseDown3D(event:MouseEvent3D):void
		{
			var mesh:Mesh = event.object as Mesh;
			trace(mesh);
		}
		
		private function onMouseOver(evt:MouseEvent3D):void
		{
			var mesh:Mesh = evt.object as Mesh;
			mesh.showBounds = true;
		}
		
		private function onMouseOut(evt:MouseEvent3D):void
		{
			var mesh:Mesh = evt.object as Mesh;
			mesh.showBounds = false;
		}
		
		
		protected function onMouseDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stageMouseX = stage.mouseX;
			stageMouseY = stage.mouseY;
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			var deltaX:Number = stage.mouseX - stageMouseX;
			var deltaY:Number = stage.mouseY - stageMouseY;
			controller.panAngle  += 0.5 * deltaX;
			controller.tiltAngle += 0.5 * deltaY;
		}
		
		protected function onWheel(event:MouseEvent):void
		{
			controller.distance *= (1 + event.delta / 100);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			_view3d.render();
		}
	}
}