package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import away3d.containers.View3D;
	
	public class Test3 extends Sprite
	{
		private var _view3d:View3D;
		
		public function Test3()
		{
			super();
			if(stage)
			{
				init();
			} else 
			{
				addEventListener(Event.ADDED_TO_STAGE,onStage,false,0,true);
			}
		}
		
		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onStage);
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			init3d();
			stage.addEventListener(Event.RESIZE,onResize,false,0,true);
			addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
			onResize(null);
		}
		
		protected function onFrame(event:Event):void
		{
			_view3d.render();
		}
		
		protected function onResize(event:Event):void
		{
			_view3d.width = stage.stageWidth;
			_view3d.height = stage.stageHeight;
		}
		
		private function init3d():void
		{
			_view3d = new View3D();
			addChild(_view3d);
		}
	}
}