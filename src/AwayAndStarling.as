/**
 * Copyright whirlpower_ ( http://wonderfl.net/user/whirlpower_ )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/rHRB
 */

package
{
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import away3d.containers.View3D;
    import away3d.core.managers.Stage3DManager;
    import away3d.core.managers.Stage3DProxy;
    import away3d.events.Stage3DEvent;
    import away3d.primitives.WireframeSphere;
    
    import starling.core.Starling;

//    [SWF(width="465", height="465", frameRate="10")]
    public class AwayAndStarling extends flash.display.Sprite
    {
        // 共通で使用するstage管理
        private var _stage3DManager:Stage3DManager;
        private var _stage3DProxy:Stage3DProxy;
        
        // スターリンで使用するオブジェクト
        private var _starling:Starling;

        // away3Dで使用するオブジェクト
        private var _away3dView : View3D;
        private var _sphere : WireframeSphere;
        
        public function AwayAndStarling()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,onResize,false,0,true);
            initProxies();
        }
		
		protected function onResize(event:Event=null):void
		{
			_away3dView.width = stage.stageWidth;
			_away3dView.height = stage.stageHeight;
			/*
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
			_starling.viewPort = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
			*/
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
            addChild(_away3dView);
            
            // ワイヤフレームの球体を置いておく
            _sphere = new WireframeSphere(160, 20, 10, 0xFFFFFF, 1.0);
            _away3dView.scene.addChild(_sphere);            
            
            // starling初期化
            _starling = new Starling(SampleTexture, stage, _stage3DProxy.viewPort, _stage3DProxy.stage3D);
            
            _stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			onResize();
        }
        
        private function onEnterFrame(event:Event):void 
        {
            // 描画を更新。更新順で表示順が決まるっぽい。
//            _starling.nextFrame();
            _away3dView.render();
        }        
    }
}

    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    internal class SampleTexture extends Sprite
    {        
        private var _container:Sprite;
        public function SampleTexture()
        {
            var checkers:BitmapData = new BitmapData(512, 512, true, 0xFF880000);
            
            for (var yP:int = 0; yP < 16; yP++) {
                for (var xP:int = 0; xP < 16; xP++) {
                    if ((yP + xP) % 2 == 0) {
                        checkers.fillRect(new Rectangle(xP * 32, yP * 32, 32, 32), 0x0);
                    }
                }
            }
            
            var checkerTx:Texture = Texture.fromBitmapData(checkers);
            addChild(new Image(checkerTx));
        }
    }

















