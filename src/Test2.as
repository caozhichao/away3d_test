package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SphereGeometry;
	import away3d.utils.Cast;
	
	[SWF(width="1000",height="800")]
	public class Test2 extends Sprite
	{
		
		[Embed(source="../assets/texture.jpg")]
		public var Earth:Class;
		
		private var _view3d:View3D;

		private var sphere1:Mesh;
		private var sphere2:Mesh;
		
		public function Test2()
		{
			super();
			init3DEngine();
			init3DObject();
			addEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		private function init3DObject():void
		{
			var textureMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(Earth));
			var sphereGeometry:SphereGeometry = new SphereGeometry(200);
			sphere1 = new Mesh(sphereGeometry,textureMaterial);
//			sphereGeometry.segmentsW *= 2;
//			sphereGeometry.segmentsH *= 2;
			sphere2 = new Mesh(sphereGeometry);
			_view3d.scene.addChild(sphere1);
			_view3d.scene.addChild(sphere2);
			
			sphere2.x += 450;
			
		}
		
		private function init3DEngine():void
		{
			_view3d = new View3D();
//			_view3d.background = Cast.bitmapTexture(Earth);
			
			_view3d.width = 1000;
			_view3d.height = 800;
			_view3d.backgroundColor = 0x0;
			addChild(_view3d);
		}
		
		protected function onFrame(event:Event):void
		{
			_view3d.render();
			sphere1.rotationY += 1;
			sphere2.rotationY += 1;
		}
	}
}