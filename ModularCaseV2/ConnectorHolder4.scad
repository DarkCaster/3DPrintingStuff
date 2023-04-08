use <../OpenSCAD_Modules/cube_vround.scad>

module Nut
(
width=5,
height=4,
)
{
	fudge = 1/cos(180/6);
	cylinder(h=height,d=width*fudge,$fn=6);
}

module DB15Cut
(
	extra_width=2,
	width=3.2,
	screw_diam=3.25,
	conn_width=28,
	conn_length=11.5,
	screw_diff=33.5,
	nut_clip_depth=2,
	nut_width=5,
	quality=1,
)
{
	cutClr=0.1;
	union()
	{
		translate([0,0,-width-cutClr])
			cube_vround(size=[conn_width,conn_length,width+extra_width+2*cutClr],rounding=2,center_xy=true,quality=quality);
		translate([-screw_diff/2,0,-width-cutClr])
		{
			cylinder(d=screw_diam,h=width+extra_width+2*cutClr,$fn=quality*12);
			Nut(height=width+extra_width+cutClr-nut_clip_depth,width+nut_width);
		}
		translate([screw_diff/2,0,-width-cutClr])
		{
			cylinder(d=screw_diam,h=width+extra_width+2*cutClr,$fn=quality*12);
			Nut(height=width+extra_width+cutClr-nut_clip_depth,width+nut_width);
		}
	}
}

module DualDB15Holder
(
	size=[50,46,10],
	diff=18,
	shift=2,
	bed_conn_shift=8,
	bed_conn_width=10,
	quality=2,
)
{
	cutClr=0.1;
	difference()
	{
		translate([0,shift,0])
		cube_vround(size=size,center_xy=true,quality=quality);

		for(i=[-1,1])
		translate([0,i*diff/2,0])
		DB15Cut(extra_width=size[2],width=0,quality=quality);

		//color([0.2,0.2,0.2])
		translate([-bed_conn_width/2,diff/2+bed_conn_shift,-cutClr])
		cube(size=[bed_conn_width,size[1],size[2]+2*cutClr]);
	}
}

DualDB15Holder();
