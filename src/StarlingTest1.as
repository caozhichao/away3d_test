package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import cutil.WindowScroll;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	
//	[SWF(width="800",height="600"]
	public class StarlingTest1 extends Sprite
	{
		private var mStarling:Starling;
		private var windowScroll:WindowScroll;
		private var p:Sprite;
		private var map:Sprite;
		private var _stepCount:int;
		private var _stepX:Number;
		private var _stepY:Number;
		private var _speed:Number = 5;
		private var sGame:SGame;
		
		[Embed(source="../assets/1.jpg")]
		private var Bg:Class;
		
		public function StarlingTest1()
		{
			super();
			
			addEventListener(flash.events.Event.ADDED_TO_STAGE,onStage);
		}
		
		private function onStage(evt:flash.events.Event):void
		{
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			
			Starling.multitouchEnabled = true; // for Multitouch Scene
			Starling.handleLostContext = true; // required on Windows, needs more memory
			mStarling = new Starling(SGame, stage);
			mStarling.simulateMultitouch = true;
			mStarling.enableErrorChecking = Capabilities.isDebugger;
			mStarling.start();
			
			// this event is dispatched when stage3D is set up
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			mStarling.stage.addEventListener(starling.events.Event.RESIZE,onResize);
			windowScroll = new WindowScroll();
			onResize(null);
			windowScroll.setScrollWindowSize(3000,2000);
			
			var bmp:Bitmap = new Bg();
			bmp.width = 3000;
			bmp.height = 2000; 
			map = new Sprite();
			map.graphics.beginFill(0x00ff00,0);
			map.graphics.drawRect(0,0,3000,2000);
			map.graphics.endFill();
//			map.addChild(bmp);
			this.addChild(map);
			
			p = new Sprite();
			p.graphics.beginFill(0xff0000);
			p.graphics.drawRect(0,0,10,10);
			p.graphics.endFill();
			map.addChild(p);
			
//			_curMapBitmap = new Bitmap();
			//			_curMapBitmap.alpha = 0.5;
			//			this.addChild(_curMapBitmap);
			map.addEventListener(MouseEvent.CLICK,onMapClick);
			function onMapClick(evt:MouseEvent):void
			{
				var mouseX:int = map.mouseX;
				var mouseY:int = map.mouseY;
				var angle : Number = Math.atan2(mouseY - p.y, mouseX - p.x);
				var ds : Number = Point.distance(new Point(mouseX,mouseY), new Point(p.x,p.y));
				_stepCount = ds / _speed;
				_stepX = _speed * Math.cos(angle);
				_stepY = _speed * Math.sin(angle);
				
			}
			
			addEventListener(flash.events.Event.ENTER_FRAME,onFrame);
		}
		private function onFrame(evt:flash.events.Event):void
		{
			if(_stepCount > 0)
			{
				p.x += _stepX;
				p.y += _stepY;
				_stepCount--;
				
				var mapPoint:Point = windowScroll.scroll(new Point(p.x,p.y));
				map.x = mapPoint.x;
				map.y = mapPoint.y;
				trace(map.x,map.y);
				sGame.updateImageXY(mapPoint.x,mapPoint.y);
			}
		}
		
		private function setWindowSize():void
		{
			windowScroll.setWindowSize(stage.stageWidth,stage.stageHeight);
		}
		
		private function onResize(evt:starling.events.ResizeEvent):void
		{
			mStarling.stage.stageWidth = stage.stageWidth;
			mStarling.stage.stageHeight = stage.stageHeight;
			mStarling.viewPort = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			setWindowSize();
		}
		
		private function onRootCreated(evt:starling.events.Event,game:SGame):void
		{
			trace("onRootCreated");
			sGame = game;
//			game.addEventListener(flash.events.MouseEvent.CLICK,onMapClick);
//			function onMapClick(evt:flash.events.MouseEvent):void
//			{
//				trace(evt.localX,evt.localY);
//			}
		}
	}
}
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

class SGame extends Sprite
{
	[Embed(source="../assets/1.jpg")]
	private var Bg:Class;

	private var image:Image;
	
	public function SGame()
	{
		var texture:Texture = Texture.fromBitmap(new Bg());
		image = new Image(texture);
		image.width = 3000;
		image.height = 2000;
		addChild(image);
	}
	
	public function updateImageXY(x:int,y:int):void
	{
		image.x = x;
		image.y = y;
	}
}
