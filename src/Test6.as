/**
 * Copyright whirlpower_ ( http://wonderfl.net/user/whirlpower_ )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/rHRB
 */

package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.events.Stage3DEvent;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.WireframePlane;
	import away3d.primitives.WireframeSphere;
	
	import cutil.WindowScroll;
	
	import starling.core.Starling;
	import starling.events.Event;
	
//	[SWF(width="465", height="465", frameRate="10")]
	public class Test6 extends flash.display.Sprite
	{
		// 共通で使用するstage管理
		private var _stage3DManager:Stage3DManager;
		private var _stage3DProxy:Stage3DProxy;
		
		// スターリンで使用するオブジェクト
		private var _starling:Starling;
		
		// away3Dで使用するオブジェクト
		private var _away3dView : View3D;
		private var _sphere : WireframeSphere;
		private var _plane:WireframePlane;
		private var mesh:Mesh;
		private var map:Sprite;
		private var _stepCount:Number;
		private var _speed:Number = 5;
		private var _stepX:Number;
		private var _stepY:Number;
		private var windowScroll:WindowScroll;

		private var game:SampleTexture;

		private var px:int;

		private var py:int;

		private var fx:int;
		private var fy:Number;
		
		public function Test6()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			initProxies();
		}
		
		private function initProxies():void
		{
			// away3D管理
			_stage3DManager = Stage3DManager.getInstance(stage);
			
			
			// 共有stage3Dの取得
			_stage3DProxy = _stage3DManager.getFreeStage3DProxy();
			_stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			_stage3DProxy.antiAlias = 8;
			_stage3DProxy.color = 0x222277;
		}
		
		private function onContextCreated(event:Stage3DEvent):void 
		{
			// away3D初期化
			_away3dView = new View3D();
			_away3dView.stage3DProxy = _stage3DProxy;
			_away3dView.shareContext = true;
			
			// ワイヤフレームの球体を置いておく
//			_sphere = new WireframeSphere(160, 20, 10, 0xFFFFFF, 1.0);
//			_plane = new WireframePlane(50,50);
			mesh = new Mesh(new PlaneGeometry(50,50,1,1,false));
//			_away3dView.scene.addChild(mesh);
			
			var t:Trident = new Trident();
			_away3dView.scene.addChild(t);
			
			// starling初期化
			_starling = new Starling(SampleTexture, stage, _stage3DProxy.viewPort, _stage3DProxy.stage3D);
			_stage3DProxy.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED,onStarlingRootCreated);
			addChild(_away3dView);
			
			_starling.stage.addEventListener(starling.events.Event.RESIZE,onResize);
			onResize();
			
			//test
			test();
		}
		
		private function onStarlingRootCreated(evt:starling.events.Event):void
		{
			trace(evt.data);
			game = evt.data as SampleTexture;
		}
		
		private function test():void
		{
			
			windowScroll = new WindowScroll();
			onResize(null);
			windowScroll.setScrollWindowSize(3000,2000);
			
			map = new Sprite();
			map.graphics.beginFill(0x00ff00,0);
			map.graphics.drawRect(0,0,3000,2000);
			map.graphics.endFill();
			//			map.addChild(bmp);
//			this.addChild(map);
			
//			p = new Sprite();
//			p.graphics.beginFill(0xff0000);
//			p.graphics.drawRect(0,0,10,10);
//			p.graphics.endFill();
//			map.addChild(p);
			
			
			var mesh2:Mesh = new Mesh(new PlaneGeometry(50000,50000,1,1,false));
//			mesh2.visible = false;
			mesh2.mouseEnabled = true;
			_away3dView.scene.addChild(mesh2);
			
			_away3dView.scene.addChild(mesh);
			
			mesh2.addEventListener(MouseEvent3D.MOUSE_DOWN,onMeshClick);
			function onMeshClick(evt:MouseEvent3D):void
			{
				var pos:Vector3D = evt.localPosition;
				trace(pos);
				var pPos:Vector3D = mesh.position;
				
				var angle : Number = Math.atan2(pos.y - pPos.y, pos.x - pPos.x);
				var ds : Number = Point.distance(new Point(pos.x,pos.y), new Point(pPos.x,pPos.y));
				_stepCount = ds / _speed;
				_stepX = _speed * Math.cos(angle);
				_stepY = _speed * Math.sin(angle);
			}
			
			_away3dView.mouseEnabled = true;
			_away3dView.mouseChildren = true;
			_away3dView.scene.addEventListener(MouseEvent3D.CLICK,on3dClick);
			
			function on3dClick(evt:MouseEvent3D):void
			{
				var pos:Vector3D = evt.localPosition;
				trace(pos);
			}
			
			map.addEventListener(MouseEvent.CLICK,onMapClick);
			function onMapClick(evt:MouseEvent):void
			{
				return;
				var pos:Vector3D = _away3dView.project(mesh.position);
				
//				trace(pos);
				
				if(fx == 0)
				{
					fx = pos.x;
					fy = pos.y;
				}
//				px = pos.x;
//				py = pos.y;
				
				
				
				var mouseX:int = map.mouseX;
				var mouseY:int = map.mouseY;
				var angle : Number = Math.atan2(mouseY - py, mouseX - px);
				var ds : Number = Point.distance(new Point(mouseX,mouseY), new Point(px,py));
				_stepCount = ds / _speed;
				_stepX = _speed * Math.cos(angle);
				_stepY = _speed * Math.sin(angle);
			}
			
		}
		
		private function setWindowSize():void
		{
			if(windowScroll)
			{
				windowScroll.setWindowSize(stage.stageWidth,stage.stageHeight);
			}
		}
		
			
		
		private function onResize(evt:starling.events.Event=null):void
		{
			_away3dView.width = stage.stageWidth;
			_away3dView.height = stage.stageHeight;
			//
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
			_starling.viewPort = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			
			setWindowSize();
		}
		
		private function onEnterFrame(event:flash.events.Event):void 
		{
			// 描画を更新。更新順で表示順が決まるっぽい。
			_starling.nextFrame();
			_away3dView.render();
			
			
			if(_stepCount > 0)
			{
				mesh.x += _stepX;
				mesh.y += _stepY;
				fx += _stepX;
				fy += _stepY;
				_stepCount--;
				
				_away3dView.camera.x += _stepX;
				_away3dView.camera.y += _stepY;
				_away3dView.camera.lookAt(mesh.position);
				
				
				
//				return;
//				var pos:Vector3D = _away3dView.project(mesh.position);
//				trace(pos);
				var mapPoint:Point = windowScroll.scroll(new Point(fx,fy));
//				map.x = mapPoint.x;
//				map.y = mapPoint.y;
//				if(mapPoint.x == 0 || mapPoint.y == 0)
//				{
//					_away3dView.camera.lookAt(new Vector3D());
//				} else 
//				{
//					_away3dView.camera.lookAt(mesh.position);
//				}
//				trace(mapPoint);
				
//				game.updateXY(mapPoint.x,mapPoint.y);
			}
		}        
	}
}

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

internal class SampleTexture extends starling.display.Sprite
{        
	[Embed(source="../assets/1.jpg")]
	private var Bg:Class;
	private var image:Image;
	public function SampleTexture()
	{
		var checkerTx:Texture = Texture.fromBitmap(new Bg());
		image = new Image(checkerTx);
		image.width = 3000;
		image.height = 2000;
		addChild(image);
	}
	
	public function updateXY(x:int,y:int):void
	{
		image.x = x;
		image.y = y;
	}
}

















