package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import away3d.containers.View3D;
	import away3d.debug.Trident;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.WireframePlane;
	import away3d.textures.BitmapTexture;
	
	import cutil.WindowScroll;
	
	[SWF(width="800",height="600")]
	public class Test11 extends Sprite
	{
		private var view3d:View3D;
		private var plane:WireframePlane;
		
		[Embed(source="../assets/map1.jpg")]
		public var BMP:Class;
		
		private var map:Bitmap;
		private var mapSpr:Sprite;

		private var plane_p2d:Vector3D;

		private var trident:Trident;

		private var trident_p2d:Vector3D;
		private var windowScroll:WindowScroll;
		
		[Embed(source="../assets/1.jpg")]
		private var MAP:Class;

		private var localX:int = 400;
		
		private var sx:Number;
		private var sy:Number;
		
		private var mapX:Number = 400;
		private var mapY:Number = 300;
		
		public function Test11()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			view3d = new View3D();
			addChild(view3d);
			trident = new Trident();
			view3d.scene.addChild(trident);
			view3d.rotationX = 45;
			plane = new WireframePlane(50,50,10,10,0xff0000,1,"xy");
//			plane.showBounds = true;
			
			view3d.scene.addChild(plane);
//			view3d.camera.lookAt(plane.position);
//			view3d.camera.lens = new OrthographicLens();
//			view3d.camera.x = 1000;
//			view3d.camera.lens.far = 10000;
			trace(view3d.camera.position);
			trace(plane.position);
			trace("--------------------------------");
			addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
			
			
			var cp:Vector3D = view3d.unproject(400,300,1000);
//			view3d.camera.lookAt(new Vector3D(cp.x,0,0));
			view3d.camera.lookAt(new Vector3D(cp.x,cp.y,cp.z));
//			stage.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
//			var backMaterial:MaterialBase = new TextureMaterial(new BitmapTexture((new MAP() as Bitmap).bitmapData));
//			backMaterial.bothSides = true;
//			plane.material = backMaterial;
			
			
			map = new BMP();
			mapSpr = new Sprite();
			map.alpha = 0.5;
			mapSpr.addChild(map);
			addChild(mapSpr);
			
//			mapSpr.addEventListener(MouseEvent.CLICK,onMapClick);
			stage.addEventListener(MouseEvent.CLICK,onMapClick);
			
			
			plane_p2d = view3d.project(plane.position);
			trident_p2d = view3d.project(trident.position);
			
			
			windowScroll = new WindowScroll();
			windowScroll.setWindowSize(800,600);
			windowScroll.setScrollWindowSize(map.width,map.height);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			plane.x += 10;
//			view3d.camera.x += 10;
//			view3d.camera.lookAt(plane.position);
			/*
			var p2d:Vector3D = view3d.project(trident.position);
			var offx:Number = p2d.x - trident_p2d.x;
			trident_p2d = p2d;
			mapSpr.x += offx;
			if(mapSpr.x < -(mapSpr.width - 800))
			{
				mapSpr.x = -(mapSpr.width - 800);
			} else 
			{
				view3d.camera.x += 10;
			}
			trace("offx:" + offx);
			trace("trident:" + trident.position + "s:" + view3d.project(trident.position));
			*/
			var pos:Point = p3dto2d2(plane.position);
			var p:Point = windowScroll.scroll(new Point(pos.x,pos.y));
			var mapIsMove:Boolean = false;
			if(int(map.x) != int(p.x))
			{
				map.x = p.x;
				map.y = p.y;
				mapIsMove = true;
			}
			if(mapIsMove)
			{
				view3d.camera.x += 10;
			}
//			trace(view3d.project(plane.position));
//			trace("p3dto2d2:" + pos);
//			trace("------------------------------------");
		}
		
		protected function onMapClick(evt:MouseEvent):void
		{
			//当前点屏幕坐标
			var sp2d:Vector3D = view3d.project(plane.position);
//			trace(evt.localX,evt.localY);
			//当前点击的舞台坐标  转换成3d坐标
			var p3d:Vector3D = view3d.unproject(evt.localX,evt.localY,1000);
//			trace("localX:" + evt.localX + " p3d:" + p3d);
			//设置当前点的3d坐标
			plane.x = p3d.x;
			plane.y = p3d.y;
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
			var coff:Vector3D = view3d.unproject(400 - cOffx,300 - coffy,1000)
			if(mapIsMove)
			{
				//设置相机的实际偏移量
				view3d.camera.x = coff.x;
				view3d.camera.y = coff.y;
				//调整相机位置  始终看向屏幕中间
				var cp:Vector3D = view3d.unproject(400,300,1000);
				view3d.camera.lookAt(new Vector3D(cp.x,cp.y,cp.z));
			}
			trace(view3d.camera.position);
		}
		
		private function p3dto2d2(p3d:Vector3D):Point
		{
			var tx:Number = 400 + p3d.x * 0.5196152210235;
			var ty:Number = 300 - p3d.y * 0.5196152329445;
			return new Point(tx,ty);
		}
		
		private function p2dto3d(p:Point):Vector3D
		{
			var p3d:Vector3D = new Vector3D();
			p3d.x = (p.x - 400) / 0.5196152210235;
			p3d.y = (300 - p.y) / 0.5196152329445;
			return p3d;
		}
		
		private function p3dto2d(p3d:Vector3D):Point
		{
			var p2d:Point = new Point();
			var f:Number = 1000/(1000+1000);
//			var v:Number = Math.sqrt(1000 * 1000 + p3d.x * p3d.x); 
//			var f:Number = v/(v+1000);
//			var f:Number = 20 * Math.tan(90 * Math.PI/360);
			var sx:Number = f * p3d.x + 400;
			var sy:Number = f * p3d.y + 300;
			p2d.x = sx;
			p2d.y = sy;
			return p2d;
		}
		protected function onFrame(event:Event):void
		{
			view3d.render();
		}
	}
}