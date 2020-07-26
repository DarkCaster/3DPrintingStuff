use <../OpenSCAD_Modules/cube_vround.scad>

module hdd_clip2(
	height=4,
	quality=2, //integer from 1 to infinity
)
{
	difference()
	{
		cube_vround(size=[10,16,height],rounding=5,center_xy=true,quality=quality);
		translate([0,-3,-0.1])
			cylinder(d=4,h=height+0.2,$fn=6*quality);
		translate([0,-3,1])
			cylinder(d=8,h=height,$fn=6*quality);
		translate([0,3,-0.1])
			cylinder(d=3,h=height+0.2,$fn=6*quality);
	}
}

module hdd_clip2_alt(
	height=4,
	quality=2, //integer from 1 to infinity
)
{
	difference()
	{
		hdd_clip2(height=height,quality=quality);
		translate([0,-7,height/2+1])
			cube([8,8,height],center=true);
	}
}

//hdd_clip2();
hdd_clip2_alt();