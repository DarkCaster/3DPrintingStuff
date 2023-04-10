module IsolatedStand
(
	diam=7,
	top_height=6,
	bottom_height=6,
	screw_hole_diam=3,
	top_hole_depth=5,
	bottom_hole_depth=5,
	quality=2,
)
{
	cutClr=0.1;
	difference()
	{
		translate([0,0,-bottom_height])
		cylinder(d=diam, h=top_height+bottom_height, center=false, $fn=quality*12);

		translate([0,0,top_height-top_hole_depth])
		cylinder(d=screw_hole_diam, h=top_hole_depth+cutClr, center=false, $fn=quality*12);

		translate([0,0,-cutClr-bottom_hole_depth-(bottom_height-bottom_hole_depth)])
		cylinder(d=screw_hole_diam, h=bottom_hole_depth+cutClr, center=false, $fn=quality*12);
	}
}

module IsolatedNutCap
(
	nut_height=3,
	nut_width=5.65,
	cap_height=4,
	cap_diam=9,
	quality=2,
)
{
	cutClr=0.1;
	fudge = 1/cos(180/6);
	difference()
	{
		cylinder(d=cap_diam, h=cap_height, center=false, $fn=quality*12);
		translate([0,0,cap_height-nut_height])
		cylinder(h=nut_height+cutClr,d=nut_width*fudge,$fn=6);
	}
}

IsolatedStand();

translate([20,0])
IsolatedNutCap();