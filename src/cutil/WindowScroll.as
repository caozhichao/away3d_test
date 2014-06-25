package cutil
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *		
	 * @author caozhichao
	 * 创建时间：2013-8-6 下午4:12:10
	 * 第一步设置好窗口的大小 setWindowSize();
	 * 第二步设置滚动界面的大小 setScrollWindowSize();
	 * 
	 * 根据目标点滚动 scroll(targetpoint);
	 * 
	 */
	public class WindowScroll
	{
		//窗口尺寸
		protected var windowWidth:int;
		protected var windowHeight:int;
		//窗口滚动点
		protected var scrollPoint:Point;
		//滚动界面的尺寸
		protected var scrollWindowWidth:int;
		protected var scrollWindowHeight:int;
		//滚动界面的当前位置
		protected var scrollWindowPoint:Point;
		//滚动范围
		protected var scrollRange:Rectangle;
		
		public function WindowScroll()
		{
			scrollPoint = new Point();
			scrollWindowPoint = new Point();
			scrollRange = new Rectangle();
		}
		
		/**
		 * 设置窗口尺寸 
		 * @param w
		 * @param h
		 * 
		 */		
		public function setWindowSize(w:int,h:int):void
		{
			windowWidth = w;
			windowHeight = h;
			//默认是中心点
			scrollPoint.x = windowWidth >> 1;
			scrollPoint.y = windowHeight >> 1;
			//窗口发生变化重新设置滚动范围
			setScrollRange();
		}
		/**
		 * 设置滚动界面尺寸 
		 * @param w
		 * @param h
		 * 
		 */		
		public function setScrollWindowSize(w:int,h:int):void
		{
			scrollWindowWidth = w;
			scrollWindowHeight = h;
			
			setScrollRange();
		}
		
		/**
		 * 设置滚动范围 
		 * 
		 */		
		private function setScrollRange():void
		{
			scrollRange.width = scrollWindowWidth - windowWidth;
			scrollRange.height = scrollWindowHeight - windowHeight;
		}
		/**
		 * 滚动函数 
		 * @param targetPoint
		 * @return 返回滚动窗口的位置 
		 * 
		 */		
		public function scroll(targetPoint:Point):Point
		{
			var tx:int = targetPoint.x - scrollPoint.x;
			var ty:int = targetPoint.y - scrollPoint.y;
			tx = FyMath.rangeInt(tx,scrollRange.x,scrollRange.width);
			ty = FyMath.rangeInt(ty,scrollRange.y,scrollRange.height);
			scrollWindowPoint.x = -tx;
			scrollWindowPoint.y = -ty;
			return scrollWindowPoint;
		}
	}
}