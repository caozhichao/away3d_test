package cutil {
	import flash.geom.Point;
	
	
	/**
	 * @author fireyang
	 */
	public class FyMath {
		public static function round(m : Number) : int {
			return (m + 0.5) >> 0;
		}
		
		public static function ceil(m : Number) : int {
			var t : int = m >> 0;
			t = m > t ? t + 1 : t;
			return t;
		}
		
		public static function floor(m : Number) : int {
			return m >> 0;
		}
		
		public static function rangeInt(value : int, min : int = 0, max : int = 100) : int {
			if (value < min) {
				value = min;
			} else if (value > max) {
				value = max;
			}
			return value;
		}
		
		public static function checkRound(value : Number, min : Number = 0, max : Number = 1) : Number {
			if (value < min) {
				value = min;
			} else if (value > max) {
				value = max;
			}
			return value;
		}
		
		public static function range(value : Number, min : int, max : int) : Number {
			if (value < min) {
				value = min;
			} else if (value > max) {
				value = max;
			}
			return value;
		}
		
		public static function dist(x : int, y : int, oldX : int, oldY : int) : int {
			return (x - oldX) * (x - oldX) + (y - oldY) * (y - oldY);
		}
		
		public static function distance(pos : Point, pos2 : Point) : int {
			return dist(pos.x,pos.y,pos2.x,pos2.y);
		}
	}
}
