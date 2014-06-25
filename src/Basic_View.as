/*

Basic View example in Away3d
 
Demonstrates:
 
How to create a 3D environment for your objects
How to add a new textured object to your world
How to rotate an object in your world

Code by Rob Bateman
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk

This code is distributed under the MIT License

Copyright (c) The Away Foundation http://www.theawayfoundation.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;

//	[SWF(backgroundColor="#000000", frameRate="60", quality="LOW",width="800",height="800")]
	
	public class Basic_View extends Sprite
	{
		[Embed(source="../assets/1.jpg")]
		public var Background:Class;
		//plane texture
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
		
		//engine variables
		private var _view:View3D;
		
		//scene objects
		private var _plane:Mesh;
		private var _plane2:Mesh;

		private var sprite3D:Sprite3D;
		
		/**
		 * Constructor
		 */
		public function Basic_View()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//setup the view
			_view = new View3D();
			addChild(_view);
			
			//setup the camera
			_view.camera.x = 300
			_view.camera.y = 400;
			_view.camera.z = -300;
//			_view.camera.lens.near = 20;
//			_view.camera.lens.far = 10000;
			_view.camera.lookAt(new Vector3D());
			var trident:Trident = new Trident();
			_view.scene.addChild(trident);
			
			var objectContainer3D:ObjectContainer3D = new ObjectContainer3D();
			_view.scene.addChild(objectContainer3D);
			
//			var ground:Mesh = new Mesh(new PlaneGeometry(4000,4000,1,1,true),new TextureMaterial(Cast.bitmapTexture(Background)));
//			ground.rotationX = -90;
//			ground.z = 1000;
//			_view.scene.addChild(ground);
			
			var textureMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(FloorDiffuse));
			//setup the scene
			_plane = new Mesh(new PlaneGeometry(100, 100,1,1,true,false), new TextureMaterial(Cast.bitmapTexture(FloorDiffuse)));
			_plane.rotationX = -90;
			_plane.showBounds = true;
			_view.scene.addChild(_plane);
			
			textureMaterial.repeat = true;
			_plane2 = new Mesh(new PlaneGeometry(100,100,2,2,true,true),textureMaterial);
			_plane2.geometry.scaleUV(2,2);
			_plane2.rotationX = 90;
			_plane2.showBounds = true;
			_plane2.x += 100;
//			_plane2.moveRight(50);
//			_view.scene.addChild(_plane2);
			
//			objectContainer3D.addChild(_plane);
//			objectContainer3D.addChild(_plane2);
			sprite3D = new Sprite3D(new TextureMaterial(Cast.bitmapTexture(Background)),1000,1000);
			sprite3D.z = 1;
//			sprite3D.rotationX = -90;
			_view.scene.addChild(sprite3D);
			
//			_view.background = Cast.bitmapTexture(Background);
			
			
//			_view.addEventListener(MouseEvent3D.CLICK,onView3DClick);
//			_view.mouseEnabled = true;
			stage.addEventListener(MouseEvent.CLICK,onClick);
			//setup the render loop
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function onClick(evt:MouseEvent):void
		{
			_plane.x += 50;
			_view.camera.x += 50;
		}
		
		protected function onView3DClick(event:MouseEvent3D):void
		{
//			trace(event.localPosition);
		}
		
		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{
//			_plane.rotationY += 1;
//			_plane.rotationX += 1;
//			_plane.rotationZ += 1;
			_view.camera.lookAt(new Vector3D(_plane.x,_plane.y,_plane.z));
			_view.render();
//			trace("plan坐标:" + _plane.position);
//			trace("相机坐标:" + _view.camera.position);
//			_view.renderer.backgroundImageRenderer
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
//			trace(stage.stageWidth,stage.stageHeight);
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
			trace(_view.scaleX,_view.scaleY,_view.scaleZ);
		}
	}
}
