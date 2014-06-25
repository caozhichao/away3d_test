package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.FollowController;
	import away3d.core.math.Matrix3DUtils;
	import away3d.debug.Trident;
	import away3d.events.MouseEvent3D;
	import away3d.primitives.WireframePlane;
	
	import cutil.WindowScroll;
	
//	[SWF(width="800",height="600")]
	public class Test10 extends Sprite
	{
		private var view3d:View3D;
		private var plane:WireframePlane;
		private var planeX:Number;
		private var planeY:Number;
		private var planeZ:Number;
		
		[Embed(source="../assets/map1.jpg")]
		public var BMP:Class;

		private var map:Bitmap;

		private var windowScroll:WindowScroll;

		private var mapSpr:Sprite;

		private var p3d:Vector3D;

		private var mapX:int = 400;

		private var p2d:Vector3D;

		private var sceneMatrix3D:Matrix3D;
		
		public function Test10()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			view3d = new View3D();
			addChild(view3d);
			
			view3d.camera.lens.far = 100000;
			
			trace(view3d.camera.position);
			trace(view3d.camera.lens.far,view3d.camera.lens.near);
			
			view3d.scene.addChild(new Trident());
			addEventListener(Event.ENTER_FRAME,onFrame);
			addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			
			plane = new WireframePlane(50,50,10,10,0xffffff,1,"xy");
			var plane2d:Vector3D = view3d.project(plane.position);
			
			planeX = plane2d.x;
			planeY = plane2d.y;
			planeZ = plane2d.z;
			
			view3d.scene.addChild(plane);
			trace("plane2d坐标: ",view3d.project(plane.position));
			trace(view3d.project(new Vector3D(800,600)));
			
//			new FollowController(view3d.camera,plane);
			
			map = new BMP();
			mapSpr = new Sprite();
			
			map.alpha = 0.5;
			mapSpr.addChild(map);
			addChild(mapSpr);
			windowScroll = new WindowScroll();
			windowScroll.setWindowSize(800,600);
			windowScroll.setScrollWindowSize(map.width,map.height);
			
			stage.addEventListener(MouseEvent.CLICK,onClick);
			
//			view3d.scene.addEventListener(MouseEvent3D.CLICK,onSceneClick);
//			mapSpr.addEventListener(MouseEvent.CLICK,onMapClick);
			
//			view3d.camera.x = 100;
			
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(0xff0000);
			spr.graphics.drawCircle(0,0,10);
			spr.graphics.endFill();
			spr.x = 400;
			spr.y = 300;
			addChild(spr);
			
			//
			p2d = view3d.project(new Vector3D());
			
			sceneMatrix3D = view3d.camera.sceneTransform.clone();
		}
		
		private function onSceneClick(evt:MouseEvent3D):void
		{
			trace(evt.localPosition);
//			evt.scenePosition
		}
		
		/*
		public function unproject(sX:Number, sY:Number, sZ:Number, v:Vector3D = null):Vector3D
		{
			return unproject2((sX*2 - 800)/800, (sY*2 - 600)/600, sZ, v);
		}
		
		public function unproject2(nX:Number, nY:Number, sZ:Number, v:Vector3D = null):Vector3D
		{
			return Matrix3DUtils.transformVector(sceneMatrix3D, unproject3(nX, nY, sZ, v), v)
			return null;
		}
		
		public function unproject3(nX:Number, nY:Number, sZ:Number, v:Vector3D = null):Vector3D
		{
			if(!v) v = new Vector3D();
			v.x = nX;
			v.y = -nY;
			v.z = sZ;
			v.w = 1;
			
			v.x *= sZ;
			v.y *= sZ;
			
			Matrix3DUtils.transformVector(view3d.camera.lens.matrix, v, v);
			
			//z is unaffected by transform
			v.z = sZ;
			return v;
		}
		*/
		
		protected function onMapClick(evt:MouseEvent):void
		{
			
			var p3d:Vector3D;
			trace("localX:" + evt.localX + " p3d:" + (p3d = view3d.unproject(evt.localX,evt.localY,1000)));
//			trace("localX:" + evt.localX + " p3d:" + (p3d = unproject(evt.localX,evt.localY,1000)));
			
			plane.x = p3d.x;
			plane.y = p3d.y;
			view3d.camera.x = plane.x;
//			trace(view3d.camera.x);
			return;
			
			var tp2d:Vector3D = view3d.project(new Vector3D(0,0,0));
			var tx:int = tp2d.x - p2d.x;
//			var ty:int = tp2d.y - p2d.y;
//			p2d = tp2d;
			trace("tp2d:" + tp2d.x  + "-p2d:" + p2d.x + " =tx:" + tx);
			mapSpr.x = tx;
//			mapSpr.y += ty;
//			var p:Point = windowScroll.scroll(new Point(pos.x,pos.y));
			return;
			/*
//			trace(view3d.unproject(400,300,1000));
//			trace(view3d.unproject(401,301,1000));
//			trace(p2dto3d2(new Point(400,300)));
//			trace(p2dto3d2(new Point(401,301)));
//			return;
			mapX = evt.localX;
			var mapY:int = evt.localY;
//			mapX += 5;
//			mapY = 300;
			var p3d:Vector3D;
			p3d = view3d.unproject(mapX,mapY,1000);
////			trace(p3d);
//			p3d = p2dto3d2(new Point(mapX,mapY));
//			trace(p3d);
			var disx:Number = p3d.x - plane.x;
			plane.x = p3d.x;
			plane.y = p3d.y;
			var pos:Point = p3dto2d2(plane.position);
			trace(pos);
			var mapIsMove:Boolean = false;
			var p:Point = windowScroll.scroll(new Point(pos.x,pos.y));
			if(mapSpr.x != p.x)
			{
//				mapSpr.x = p.x;
//				mapSpr.y = p.y;
				mapIsMove = true;
			}
			if(mapIsMove)
			{
//				view3d.camera.x += disx;
			}
//			view3d.camera.lookAt(plane.position);
			*/
			/*
			var tx:Number = plane.x;
			p3d = view3d.unproject(mapX,mapY,1000);
			trace("mapX:" + mapX + " mapY:" + mapY + "3d: " + p3d);
			plane.x = p3d.x;
			var disx:Number = plane.x - tx;
//			plane.y = p3d.y;
//			return;
			var changeX:int = mapX - planeX;
			planeX = mapX;
			var mapIsMove:Boolean = false;
			var p:Point = windowScroll.scroll(new Point(planeX,planeY));
			if(mapSpr.x != p.x)
			{
				mapSpr.x = p.x;
//				mapSpr.y = p.y;
				mapIsMove = true;
			}
			if(mapIsMove)
			{
//				view3d.camera.x += disx;
			}
			*/
		}
		
		protected function onClick(event:MouseEvent):void
		{
			view3d.unproject(400,300,1000);
			plane.x += 10;
//			plane.y += 1;
//			view3d.camera.lookAt(plane.position);
//			view3d.camera.x += 10;
			var pos2d:Vector3D = view3d.project(plane.position);
//			var pos2d:Vector3D = view3d.project(new Vector3D());
			trace(pos2d);
			var pos:Point = p3dto2d2(plane.position);
			trace(pos);
			
//			return;
//			var p2d:Point = p3dto2d(plane.position);
//			trace(p2d);
			/*
			planeX += 10;
//			trace("plane3d:" + plane.position + " plane2d坐标: ",view3d.project(plane.position) + " width: " + plane.width + " height: " + plane.height);
			trace("plane3d:" + plane.position + " plane2d坐标: " + view3d.project(new Vector3D(planeX,planeY,planeZ)) + " width: " + plane.width + " height: " + plane.height);
			*/
			var mapIsMove:Boolean = false;
//			var p:Point = windowScroll.scroll(new Point(400 + (400 - pos2d.x),pos2d.y));
//			var p:Point = windowScroll.scroll(new Point(planeX,planeY));
//			var p:Point = windowScroll.scroll(new Point(p2d.x,p2d.y));
			var p:Point = windowScroll.scroll(new Point(pos.x,pos.y));
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
		}
		
		private function p2dto3d(p:Point):Vector3D
		{
			var p3d:Vector3D = new Vector3D();
			p3d.x = p.x - 400;
			p3d.y = 300 - p.y;
			return p3d;
		}
		
		private function p3dto2d(p3d:Vector3D):Point
		{
			var tx:int = p3d.x * 1 + 400;
			var ty:int = 300 - p3d.y * 1;
			return new Point(tx,ty);
		}
		
		private function p2dto3d2(p:Point):Vector3D
		{
			var p3d:Vector3D = new Vector3D();
			p3d.x = (p.x - 400) * 1.9245009124279022;
			p3d.y = (p.y - 300) * -1.924500862757365;
			return p3d;
		}
		
		private function p3dto2d2(p3d:Vector3D):Point
		{
			var tx:Number = 400 + p3d.x * 0.5196152210235;
			var ty:Number = 300 - p3d.y * 0.5196152329445;
			return new Point(tx,ty);
		}
		
		private function onWheel(evt:MouseEvent):void
		{
			view3d.camera.z += evt.delta / Math.abs(evt.delta) * 10;
			trace(view3d.camera.position);
		}
		
		protected function onFrame(event:Event):void
		{
			view3d.render();
		}
	}
}