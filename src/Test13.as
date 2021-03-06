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
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.MD2Parser;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.WireframePlane;
	import away3d.utils.Cast;
	
	import cutil.WindowScroll;
	
	[SWF(width="800",height="600")]
	public class Test13 extends Sprite
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
		
		public function Test13()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			view3d = new View3D();
			addChild(view3d);
			stage.addEventListener(Event.RESIZE,onResize,false,0,true);
			
			//相机基本设置
//			lens = new OrthographicLens();
			lens = new OrthographicOffCenterLens(0,0,0,0);
			lens.near = 20;
			lens.far = 50000;
//			lens.projectionHeight = 100;
			
			view3d.camera.lens = lens;
//			view3d.camera.x = 0;
//			view3d.camera.y = 0;
//			view3d.camera.z = -Z;
			
//			view3d.camera.roll(45);
//			view3d.camera.lens.far = 50000;
			var textureMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(BMP));
			planeMesh = new Mesh(new PlaneGeometry(1600,1200,1,1,false,true),textureMaterial);
//			trace(planeMesh.pivotPoint);
//			planeMesh.pivotPoint.x = -200;
//			planeMesh.pivotPoint = new Vector3D(-200,150,0);
//			planeMesh.movePivot(-200,150,0);
//			planeMesh.roll(45);
			
			view3d.scene.addChild(planeMesh);
			trident = new Trident();
			view3d.scene.addChild(trident);
			plane = new WireframePlane(50,50,10,10,0xff0000,1,"xy");
			view3d.scene.addChild(plane);
//			view3d.camera.lookAt(new Vector3D());
//			trace(plane.position);
			trace("--------------------------------");
			addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
			testMD2();
			onResize(null);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
			test();
		}
		
		private function test():void
		{
			var p3d:Vector3D = p2dTo3d(0,0);
			planeMesh.x = p3d.x + (planeMesh.geometry as PlaneGeometry).width / 2;
			planeMesh.y = p3d.y - (planeMesh.geometry as PlaneGeometry).height / 2;
			trace(p3dTo2d(new Vector3D(p3d.x,p3d.y)));
		}
		
		private function p3dTo2d(p3d:Vector3D):Point
		{
			var p2d:Point = new Point();
			p2d.x = p3d.x + 400;
			p2d.y = 300 - p3d.y;
			return p2d;
		}
		
		private function p2dTo3d(x2d:int,y2d:int):Vector3D
		{
			var p3d:Vector3D = new Vector3D();
			p3d.x = x2d - 400;
			p3d.y = 300 - y2d;
			return p3d;
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			trace(event.keyCode);
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
			trace(view3d.project(new Vector3D()));
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
		
		/*
		protected function onMapClick(evt:MouseEvent):void
		{
			//当前点屏幕坐标
			var sp2d:Vector3D = view3d.project(plane.position);
//			var sp2d:Vector3D = view3d.project(mesh.position);
			//当前点击的舞台坐标  转换成3d坐标
			var p3d:Vector3D = view3d.unproject(evt.localX,evt.localY,Z);
			//设置当前点的3d坐标
			plane.x = p3d.x;
			plane.y = p3d.y;
//			mesh.x = p3d.x;
//			mesh.y = p3d.y;
			//计算点的坐标偏移量
			var offx:Number = evt.localX - sp2d.x;
			var offy:Number = evt.localY - sp2d.y;
			//记录地图的总偏移量
			mapX += offx;
			mapY += offy;
			var mapIsMove:Boolean = false;
			var cOffx:Number = 0;
			var coffy:Number = 0;
			//根据地图的偏移量滚屏
			var p:Point = windowScroll.scroll(new Point(mapX,mapY));
			if(int(map.x) != int(p.x))
			{
				//记录当前滚屏的实际偏移量x
				cOffx = p.x - map.x;
				map.x = p.x;
				mapIsMove = true;
			}
			if(int(map.y) != int(p.y))
			{
				//记录当前滚屏的实际偏移量y
				coffy = p.y - map.y;
				map.y = p.y;
				mapIsMove = true;
			}
			//计算实际偏移量的3d偏移量
			var coff:Vector3D = view3d.unproject(400 - cOffx,300 - coffy,Z)
			if(mapIsMove)
			{
				//设置相机的实际偏移量
				view3d.camera.x = coff.x;
				view3d.camera.y = coff.y;
				//调整相机位置  始终看向屏幕中间
				var cp:Vector3D = view3d.unproject(400,300,Z);
				view3d.camera.lookAt(new Vector3D(cp.x,cp.y,cp.z));
			}
		}
		*/
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
					mesh.scale(5);
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
		}
	}
}