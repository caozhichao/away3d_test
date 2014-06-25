package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import away3d.animators.SpriteSheetAnimationSet;
	import away3d.animators.SpriteSheetAnimator;
	import away3d.animators.nodes.SpriteSheetClipNode;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.SpriteSheetHelper;
	import away3d.utils.Cast;
	
	public class Test4 extends Sprite
	{
		private var _view3d:View3D;
		
		[Embed(source="../embeds/spritesheets/testSheet1.jpg")]
		private var TextureMaterial1:Class;
		
		public function Test4()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_view3d = new View3D();
			addChild(_view3d);
			testSpreetAnimation();
			addEventListener(Event.ENTER_FRAME,onFrame);
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}
		
		private function testSpreetAnimation():void
		{
			var textureMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(TextureMaterial1));
			var mesh:Mesh = new Mesh(new PlaneGeometry(500,500,1,1,false),textureMaterial);
			//动画帧帮助类
			var spriteSheetHelper:SpriteSheetHelper = new SpriteSheetHelper();
			//动画帧处理
			var spriteSheetClipNode:SpriteSheetClipNode = spriteSheetHelper.generateSpriteSheetClipNode("animation1",2,2);
			//关联一个动画设置
			var spriteSheetAnimationSet:SpriteSheetAnimationSet = new SpriteSheetAnimationSet();
			//创建一个动画对象
			var spriteSheetAnimator:SpriteSheetAnimator = new SpriteSheetAnimator(spriteSheetAnimationSet);
			
			//test
			var spriteSheetClipNode1:SpriteSheetClipNode = spriteSheetHelper.generateSpriteSheetClipNode("animation2",3,3);
			
			spriteSheetAnimationSet.addAnimation(spriteSheetClipNode1);
			spriteSheetAnimationSet.addAnimation(spriteSheetClipNode);
			spriteSheetAnimator.fps = 1;
			mesh.animator = spriteSheetAnimator;
			spriteSheetAnimator.play("animation1");
			
			_view3d.scene.addChild(mesh);
		}
		
		private function onResize(evt:Event=null):void
		{
			_view3d.width = stage.stageWidth;
			_view3d.height = stage.stageHeight;
		}
		private function onFrame(evt:Event):void
		{
			_view3d.render();
		}
	}
}