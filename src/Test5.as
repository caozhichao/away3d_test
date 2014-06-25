package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import away3d.containers.View3D;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.primitives.PlaneGeometry;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	[SWF(width="800",height="600"]
	public class Test5 extends flash.display.Sprite
	{
		private var _view3d:View3D;

		private var mesh:Mesh;
		private var mStarling:Starling;
		private var _stage:Stage;
		
		public function Test5()
		{
			super();
			_stage = stage;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			_view3d = new View3D();
			_view3d.width = 800;
			_view3d.height = 600;
			addChild(_view3d);
			mesh = new Mesh(new PlaneGeometry(100,100,1,1,false));
			mesh.y = 10;
			_view3d.scene.addChild(mesh);
			var trident:Trident = new Trident();
			_view3d.scene.addChild(trident);
			addEventListener(flash.events.Event.ENTER_FRAME,onFrame);
			
			
			Starling.multitouchEnabled = true; // for Multitouch Scene
			Starling.handleLostContext = true; // required on Windows, needs more memory
			
			mStarling = new Starling(StarlingGame, _stage);
			mStarling.simulateMultitouch = true;
			mStarling.enableErrorChecking = Capabilities.isDebugger;
			mStarling.start();
			// this event is dispatched when stage3D is set up
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		}
		
		private function onRootCreated(event:starling.events.Event, game:StarlingGame):void
		{
			var spr:starling.display.Sprite = new starling.display.Sprite();
			
		}
		
		protected function onFrame(event:flash.events.Event):void
		{
			_view3d.render();
//			var pos:Vector3D = _view3d.project(mesh.position); 
//			trace("屏幕位置:" + pos);
		}
	}
}
import starling.display.Sprite;

class StarlingGame extends Sprite
{
	public function StarlingGame()
	{
		
	}
}

