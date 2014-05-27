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
	import flash.net.URLRequest;
	
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.library.assets.AssetType;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;

	[SWF(backgroundColor="#000000", frameRate="60", quality="LOW",width="800",height="600")]
	
	public class Basic_View_bk extends Sprite
	{
		//plane texture
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
		
		//engine variables
		private var _view:View3D;
		
		//scene objects
		private var _plane:Mesh;

		private var loader:Loader3D;
		
		/**
		 * Constructor
		 */
		public function Basic_View_bk()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//setup the view
			_view = new View3D();
			addChild(_view);
			
			//setup the camera
			_view.camera.z = -600;
			_view.camera.y = 1500;
//			_view.camera.x = -300;
			
			_view.camera.lookAt(new Vector3D());
			
			//setup the scene
			_plane = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture(FloorDiffuse)));
//			_plane = new Mesh(new PlaneGeometry(700, 700));
//			_plane.z = 1500;
			
			_view.scene.addChild(_plane);
			var trident:Trident = new Trident();
			_view.scene.addChild(trident);
			init3D();
			
			var light:PointLight = new PointLight();
			light.y = 500;
			_view.scene.addChild(light);
			
			
			var status:AwayStats = new AwayStats(_view);
			addChild(status);
			
			//setup the render loop
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			onResize();
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			_view.camera.z += event.delta * 10;
		}
		
		private function init3D():void
		{
			loader = new Loader3D();
			Loader3D.enableParser(Max3DSParser);
			loader.addEventListener(AssetEvent.ASSET_COMPLETE,onAssetComplete);
			var assetLoaderContext:AssetLoaderContext = new AssetLoaderContext();
			assetLoaderContext.mapUrl("texture.jpg","../embeds/soldier_ant.jpg");
			loader.load(new URLRequest("../embeds/soldier_ant.3ds"),assetLoaderContext);
			_view.scene.addChild(loader);
			loader.scale(300);
//			loader.z = -200;
		}
		
		private function onAssetComplete(evt:AssetEvent):void
		{
			if (evt.asset.assetType == AssetType.MESH) {
				var mesh:Mesh = evt.asset as Mesh;
				trace(mesh.pivotPoint.toString());
			}
//			trace(evt.toString());
//			trace(loader.pivotPoint.toString());
//			trace(loader.position.toString());
		}
		
		
		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{
			_plane.rotationY += 1;
			
			_view.render();
//			trace(_plane.x,_plane.y,_plane.z);
//			trace(loader.x,loader.y,loader.z);
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
	}
}
