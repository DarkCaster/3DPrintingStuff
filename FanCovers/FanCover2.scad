use <../OpenSCAD_Modules/boards.scad>

module fan_cover(
	size=92,
	fan_diam=89,
	hole_diam=4,
	hole_shift=5,
	base=1,
	height=1,
	quality=2, //integer from 1 to infinity
)
{
	difference()
	{
		board(size_x=size,size_y=size,hole_diam=hole_diam,hole1=[hole_shift,hole_shift],hole2=[hole_shift,hole_shift],hole3=[hole_shift,hole_shift],hole4=[hole_shift,hole_shift],rounding=hole_shift,width=height,center_xy=true,center_z=false);
		translate([0,0,base])
			cylinder(d=fan_diam,h=height-base+0.1,$fn=24*quality);
	}
}

module fan_cut(
	fan_diam=89,
	height=6,
	quality=2, //integer from 1 to infinity
)
{
	translate([0,0,-0.1])
		cylinder(d=fan_diam-0.05,h=height+0.2,$fn=24*quality);
}

fan_cover();
fan_cut();