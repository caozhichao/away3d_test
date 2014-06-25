package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import away3d.animators.VertexAnimationSet;
	import away3d.animators.VertexAnimator;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.OrthographicOffCenterLens;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.MD2Parser;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.WireframePlane;
	import away3d.utils.Cast;
	
	import cutil.WindowScroll;
	
	[SWF(width="800",height="600",frameRate="60")]
	public class Test15 extends Sprite
	{
		private var view3d:View3D;
		private var plane:WireframePlane;
		[Embed(source="../assets/2.jpg")]
		public var BMP:Class;
		private var map:Bitmap;
		private var mapSpr:Sprite;
		private var plane_p2d:Vector3D;
		private var trident:Trident;
		private var trident_p2d:Vector3D;
		private var windowScroll:WindowScroll;
		private var mapX:Number = 400;
		private var mapY:Number = 300;
//		private var lens:OrthographicLens;
		private var lens:OrthographicOffCenterLens;
		private static const Z:int = 1000;
		private var vertexAnimationSet:VertexAnimationSet;
		private var mesh:Mesh;
		[Embed(source="../embeds/pknight/pknight1.png")]
		public static var PKnightTexture1:Class;
		private var planeMesh:Mesh;
		private var pMapX:Number = 400;
		private var pMaxpY:Number = 300;

		private var windowScroll2:WindowScroll;
		private var pMap:Point = new Point(0,0);
		
		private var _speed:int = 5;
		private var _stepCount:int;
		private var _stepX:Number = 0;
		private var _stepY:Number = 0;

		private var p2d:Point = new Point(pMapX,pMaxpY);

		private var offX:int;

		private var offY:int;
		private var planePos:Vector3D;
		
		public function Test15()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			view3d = new View3D();
			addChild(view3d);
			stage.addEventListener(Event.RESIZE,onResize,false,0,true);
			
			//相机基本设置
			lens = new OrthographicOffCenterLens(0,0,0,0);
			lens.near = 20;
			lens.far = 50000;
			view3d.camera.lens = lens;
			var textureMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(BMP));
			planeMesh = new Mesh(new PlaneGeometry(1600,1200,1,1,false,true),textureMaterial);
			view3d.scene.addChild(planeMesh);
			trident = new Trident();
			view3d.scene.addChild(trident);
			plane = new WireframePlane(50,50,10,10,0xff0000,1,"xy");
			view3d.scene.addChild(plane);
			
			addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
//			testMD2();
			onResize(null);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
			
			windowScroll2 = new WindowScroll();
			windowScroll2.setWindowSize(800,600);
			windowScroll2.setScrollWindowSize(1600,1200);
			
			planeMesh.addEventListener(MouseEvent3D.MOUSE_DOWN,onMapClick,false,0,true);
			planeMesh.mouseEnabled = true;
			
			test();
		}
		
		private function onMapClick(evt:MouseEvent3D):void
		{
			//计算2d坐标
			p2d = p3dTo2d(evt.scenePosition);
			trace(p2d);
//			/*
			var angle : Number = Math.atan2(p2d.y - pMaxpY, p2d.x - pMapX);
			var ds : Number = Point.distance(new Point(p2d.x,p2d.y), new Point(pMapX,pMaxpY));
			_stepCount = ds / _speed;
			_stepX = _speed * Math.cos(angle);
			_stepY = _speed * Math.sin(angle);
//			*/
			
			/*
			pMapX = p2d.x;
			pMaxpY = p2d.y;
			//移动人物
			var p3d:Vector3D = p2dTo3d(pMapX,pMaxpY);
			plane.moveTo(p3d.x,p3d.y,plane.z);
			trace(p3dTo2d(plane.position) + "pMapX: " + pMapX + " pMaxpY: " + pMaxpY);
			//计算滚屏
			var p:Point = windowScroll2.scroll(new Point(pMapX,pMaxpY));
			//设置相机位置
			view3d.camera.x = -p.x;
			view3d.camera.y = p.y;
			*/
		}
		
		private function updateXY():void
		{
			if(_stepCount > 0)
			{
				pMapX += _stepX;
				pMaxpY += _stepY;
				/*
				var p3d:Vector3D = p2dTo3d(pMapX,pMaxpY);
				plane.moveTo(p3d.x,p3d.y,plane.z);
				mesh.moveTo(p3d.x,p3d.y,mesh.z);
				var p:Point = windowScroll2.scroll(new Point(pMapX,pMaxpY));
				//设置相机位置
				view3d.camera.x = -p.x;
				view3d.camera.y = p.y;
				*/
				setXY();
				_stepCount--;
			} 
		}
		
		private function setXY():void
		{
			var p3d:Vector3D = p2dTo3d(pMapX,pMaxpY);
			plane.moveTo(p3d.x,p3d.y,plane.z);
//			mesh.moveTo(p3d.x,p3d.y,mesh.z);
			var p:Point = windowScroll2.scroll(new Point(pMapX,pMaxpY));
			//设置相机位置
			view3d.camera.x = -p.x;
			view3d.camera.y = p.y;
		}
		
		private function test():void
		{
			var p3d:Vector3D = p2dTo3d(0,0);
			planeMesh.x = p3d.x + (planeMesh.geometry as PlaneGeometry).width / 2;
			planeMesh.y = p3d.y - (planeMesh.geometry as PlaneGeometry).height / 2;
			trace(p3dTo2d(new Vector3D(p3d.x,p3d.y)));
			
			pMapX = 500;
			pMaxpY = 300;
			setXY();
		}
		
		private function p3dTo2d(p3d:Vector3D):Point
		{
			var p2d:Point = new Point();
			p2d.x = p3d.x + 400;
			p2d.y = 300 - p3d.y;
			return p2d;
		}
		
		private function p2dTo3d(x2d:Number,y2d:Number):Vector3D
		{
			var p3d:Vector3D = new Vector3D();
			p3d.x = x2d - 400;
			p3d.y = 300 - y2d;
			return p3d;
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			var code:int = event.keyCode;
			var dis:int = 5;
			switch(code)
			{
				case 37:
					view3d.camera.moveLeft(dis);
					plane.moveLeft(dis);
					break;
				case 38:
					view3d.camera.moveUp(dis);
					break;
				case 39:
					view3d.camera.moveRight(dis);
					plane.moveRight(dis);
					break;
				case 40:
					view3d.camera.moveDown(dis);
					break;
			}
//			trace(view3d.project(plane.position));
			trace(view3d.camera.position);
			trace(planeMesh.scenePosition);
		}
		
		protected function onResize(event:Event):void
		{
			view3d.width = stage.stageWidth;
			view3d.height = stage.stageHeight;
			lens.minX = -view3d.width / 2
			lens.maxX = view3d.width / 2;
			lens.minY = - view3d.height / 2;
			lens.maxY = view3d.height / 2;
			trace(planeMesh.position);
			trace(view3d.camera.position);
			trace(view3d.project(view3d.camera.position));
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
					mesh.scale(3);
					mesh.mouseEnabled = true;
					//3d鼠标事件
					//					mesh.addEventListener(MouseEvent3D.MOUSE_OVER,onMouseOver);
					//					mesh.addEventListener(MouseEvent3D.MOUSE_OUT,onMouseOut);
					//					mesh.addEventListener(MouseEvent3D.MOUSE_DOWN,onMouseDown3D);
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
				view3d.scene.addChild(mesh);
			}
		}
		
		
		protected function onFrame(event:Event):void
		{
			view3d.render();
			updateXY();
		}
	}
}