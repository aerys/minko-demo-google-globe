package
{
	public class Color
	{
		public static function hsvToRgb(h	: Number, s	: Number, v	: Number) : uint
		{
			if (h == -1)
				return rgb(v, v, v);
			
			var i : int 	= h;
			var f : Number 	= h - i;
			
			if (!(i & 1))
				f = 1. - f; // if i is even
			
			var p : Number	= v * (1 - s);
			var q : Number 	= v * (1 - s * f);
			var t : Number	= v * (1. - s * (1. - f));			 
			
			switch (i) {
				case 0 :
					return rgb(v, t, p);
				case 1 :
					return rgb(q, v, p);
				case 2 :
					return rgb(p, v, t)
				case 3 :
					return rgb(p, q, v);
				case 4 :
					return rgb(t, p, v);
				default :
					return rgb(v, p, q);
			}
		}
		
		public static function rgb(r : Number, g : Number, b : Number) : uint
		{
			return ((r * 255.) << 16) + ((g * 255.) << 8) + b * 255.;
		}
	}
}