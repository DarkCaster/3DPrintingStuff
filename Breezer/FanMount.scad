use <../OpenSCAD_Modules/cube_vround.scad>

module FanMount
(
	ext_size=[160,160,10],
	fan_ext_clip_size=[130,130,14],
	fan_int_size=[120,120],
	corner_clip_shift=5,
	center_clip_shift=5,

	int_size=[160,134,10],
	int_clr=0.8,
	base_clr=0.4,
	int_clip_size=2,
	xshift=5,
	screw_hole_diam=3.75,
	
	hscrew_diff=142,
	hscrew_size=[30,12],
	quality=2
)
{
	cutClr=1;
	rounding=5;

	difference()
	{
		union()
		{
			//base
			cube_vround(size=ext_size,center_xy=true,quality=quality,rounding=rounding);
			cube_vround(size=fan_ext_clip_size,center_xy=true,quality=quality,rounding=rounding);
		}
		translate([0,0,-cutClr])
		cube_vround(size=[fan_int_size[0],fan_int_size[1],fan_ext_clip_size[2]+2*cutClr],center_xy=true,quality=quality,rounding=rounding);

		//center clips
		for (j=[-1:2:1])
		translate([0,j*(ext_size[1]/2-center_clip_shift),ext_size[2]/2])
		cylinder(d=screw_hole_diam,h=ext_size[2]+2*cutClr,center=true,$fn=quality*12);

		//corner clip cuts
		for (i=[-1:2:1],j=[-1:2:1])
		translate([i*(ext_size[0]/2-corner_clip_shift),j*(ext_size[1]/2-corner_clip_shift),ext_size[2]/2])
		cylinder(d=screw_hole_diam,h=ext_size[2]+2*cutClr,center=true,$fn=quality*12);

	}
}

FanMount();
