

module stand_cyl
(
	line_wd=0.4,
	lines_cnt=6,
	out_diam_extra=0.0,
	inner_diam=3.5,
	height=7,
	quality=2,
)
{
	outer_diam=inner_diam+line_wd*lines_cnt*2+out_diam_extra;
	difference()
	{
		cylinder(h=height,d=outer_diam,center=true,$fn=quality*12);
		cylinder(h=height+1,d=inner_diam,center=true,$fn=quality*12);
	}
}

stand_cyl();