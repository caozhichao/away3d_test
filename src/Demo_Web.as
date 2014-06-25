package 
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.system.Capabilities;
    
    import away3d.containers.View3D;
    import away3d.entities.Mesh;
    import away3d.primitives.PlaneGeometry;
    
    import starling.core.Starling;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
    
    // If you set this class as your 'default application', it will run without a preloader.
    // To use a preloader, see 'Demo_Web_Preloader.as'.
    
    [SWF(width="800", height="600", frameRate="60", backgroundColor="#222222")]
    public class Demo_Web extends Sprite
    {
        [Embed(source = "../assets/startup.jpg")]
        private var Background:Class;
        
        private var mStarling:Starling;
        private var _view3d:View3D;
        private var mesh:Mesh;
        
        public function Demo_Web()
        {
            if (stage) start();
            else addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        private function start():void
        {
            Starling.multitouchEnabled = true; // for Multitouch Scene
            Starling.handleLostContext = true; // required on Windows, needs more memory
            
            mStarling = new Starling(StarlingGame, stage);
            mStarling.simulateMultitouch = true;
            mStarling.enableErrorChecking = Capabilities.isDebugger;
            mStarling.start();
            
            // this event is dispatched when stage3D is set up
            mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			
			initAway3d();	
        }
        
        private function onAddedToStage(event:Object):void
        {
            removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
            start();
        }
		
		private function onFrame(evt:flash.events.Event):void
		{
			_view3d.render();
		}
        
        private function onRootCreated(event:starling.events.Event, game:StarlingGame):void
        {
            // set framerate to 30 in software mode
            if (mStarling.context.driverInfo.toLowerCase().indexOf("software") != -1)
                mStarling.nativeStage.frameRate = 30;
            
            // define which resources to load
            var assets:AssetManager = new AssetManager();
            assets.verbose = Capabilities.isDebugger;
//            assets.enqueue(EmbeddedAssets);
            // background texture is embedded, because we need it right away!
            var bgTexture:Texture = Texture.fromEmbeddedAsset(Background, false);
            
            // game will first load resources, then start menu
//            game.start(bgTexture, assets);
        }
		
		private function initAway3d():void
		{
			//away 3d;
			_view3d = new View3D();
			_view3d.width = 800;
			_view3d.height = 600;
			mesh = new Mesh(new PlaneGeometry(100,100,1,1,false));
			_view3d.scene.addChild(mesh);
			addChild(_view3d);
			addEventListener(flash.events.Event.ENTER_FRAME,onFrame);
		}
    }
}

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

class StarlingGame extends Sprite
{
	[Embed(source="../assets/1.jpg")]
	private var Bg:Class;
	public function StarlingGame()
	{
		init();
	}
	
	private function init():void
	{
		var texture:Texture = Texture.fromBitmap(new Bg());
		var image:Image = new Image(texture);
//		this.addChildAt(image,0);
	}
}
