package
{
	/**
	 * @author caozc
	 * @version 1.0.0
	 * 创建时间：2014-5-4 上午10:48:57
	 * 
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	
	[SWF(width="640",height="480",frameRate="60",backgroundColor="#FFFFFF")]
	public class away3dTest extends Sprite
	{
		[Embed(source="/../assets/texture.jpg")]
		private var _textureBmp:Class;
		private var _stage3D:Stage3D;
		private var _context3D:Context3D;
		private var _texture:Texture;
		
		private var _meshIndexData:Vector.<uint>;
		private var _meshVertexData:Vector.<Number>;
		
		
		
		public function away3dTest()
		{
			if(stage != null)
			{
				init();
			} else 
			{
				addEventListener(Event.ADDED_TO_STAGE,onStage);
			}
		}
		
		private function onStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onStage);
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage3D = stage.stage3Ds[0];
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE,onContext3D);
			_stage3D.requestContext3D();
			
		}
		
		protected function onContext3D(event:Event):void
		{
			var bmd:BitmapData = (new _textureBmp() as Bitmap).bitmapData;
			_context3D = _stage3D.context3D;
			
			_context3D.enableErrorChecking = true;
			
			_texture = _context3D.createTexture(512,512,Context3DTextureFormat.BGRA,true);
			_texture.uploadFromBitmapData(bmd);
			_meshIndexData = new Vector.<uint>([0,1,2,0,2,3]);
			
			_meshVertexData = new Vector.<Number>(
												 [
													-1,-1,1,0,0,0,0,1,
													1,-1,1,1,0,0,0,1,
													1,1,1,1,1,0,0,1,
													-1,1,1,0,1,0,0,1
												 ]);
			_context3D.configureBackBuffer(640,480,0);
			
			
			
		}
	}
}