package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	
	/**
	 *  
	 * @author caozc
	 * 
	 */	
	public class Test7 extends Sprite
	{

		private var view3d:View3D;
		private var cameraController:FirstPersonController;
		
		[Embed(source="../assets/1.jpg")]
		private var back:Class;
		private var lastPanAngle:Object;
		private var move:Boolean;
		private var lastTiltAngle:Object;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var _speed:Number = 3;
		private var _key:Dictionary = new Dictionary();
		private var _directFront:Boolean;
		private var _directLeft:Boolean;
		private var _directRight:Boolean;
		private var _directBack:Boolean;
		
		public function Test7()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			initEngine();
			initObject3d();
			stage.addEventListener(Event.RESIZE,onResize,false,0,true);
			addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDwonHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			onResize();
		}
		
		private function initObject3d():void
		{
			this.view3d.scene.addChild(new Trident());
			//添加底图
			var backGeo:PlaneGeometry = new PlaneGeometry(1500, 1500, 1, 1, true);
			var backMaterial:MaterialBase = new TextureMaterial(new BitmapTexture((new back() as Bitmap).bitmapData));
			backMaterial.bothSides = true;
			var backMesh:Mesh = new Mesh(backGeo, backMaterial);
			//			backMesh.y = -10;
			this.view3d.scene.addChild(backMesh);
		}
		
		private function initEngine():void
		{
			view3d  = new View3D();
			view3d.backgroundColor = 0xffffff;
			view3d.camera.y = 60;
			view3d.camera.z = -120;
//			view3d.camera.lens.near = 5;
//			view3d.camera.lens.far = 10000;
			view3d.camera.lookAt(new Vector3D(0, 0, 0));
			cameraController = new FirstPersonController(this.view3d.camera,0,0,-90,90,8);
			addChild(view3d);
		}
		
		private function onResize(evt:Event=null):void
		{
			trace(stage.stageWidth,stage.stageHeight);
			view3d.width = stage.stageWidth;
			view3d.height = stage.stageHeight;
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			//记录原始值
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			
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
		
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		
		private function onFrame(evt:Event):void
		{
			
			trace(this.view3d.camera.position);
			
			//修改观察角度
			if (move) {
				cameraController.panAngle = (stage.mouseX - lastMouseX)/10 + lastPanAngle;
				cameraController.tiltAngle = (stage.mouseY - lastMouseY)/10 + lastTiltAngle;
			}
			
			if(_directLeft)
			{
				cameraController.incrementStrafe(-_speed);
			}
			if(_directRight)
			{
				cameraController.incrementStrafe(_speed);
			}
			if(_directFront)
			{
				cameraController.incrementWalk(_speed);
			}
			if(_directBack)
			{
				cameraController.incrementWalk(-_speed);
			}
			view3d.render();
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