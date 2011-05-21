package
{
	public class ColorUtils
	{
		public static function hsvToRgb(h	: Number, s	: Number, v	: Number) : uint
		{
			var r	: Number	= 0;
			var g	: Number	= 0;
			var b	: Number	= 0;
			var i	: Number	= 0.;
			var f	: Number	= 0.;
			var p	: Number	= 0.;
			var q	: Number	= 0.;
			var t 	: Number 	= 0.;
			
			if (v == 0.0)
			{
				r = g = b = 0;
			}
			else
			{
				i = Math.floor( h * 6 );
				f = ( h * 6 ) - i;
				p = v * ( 1 - s );
				q = v * ( 1 - ( s * f ) );
				t = v * ( 1 - ( s * ( 1 - f ) ) );
				
				switch (i)
				{
					case 1 :
						return rgb(q, v, p);
					case 2 :
						return rgb(p, v, t);
					case 3 :
						return rgb(p, q, v);
					case 4 :
						return rgb(t, p, v);
					case 5 :
						return rgb(v, p, q);
					case 6 :
					case 0 :
						return rgb(v, t, p);
				}
				
			}
			
			return rgb(r, g, b);
		}
		
		public static function rgb(r : Number, g : Number, b : Number) : uint
		{
			return ((r * 255.) << 16) + ((g * 255.) << 8) + b * 255.;
		}
	}
}