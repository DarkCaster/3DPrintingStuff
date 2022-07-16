use <../OpenSCAD_Modules/cube_vround.scad>

module FanMount
(
	ext_size=[160,160,8],
	fan_ext_clip_size=[130,130,13],
	fan_int_size=[120,120,0.4,1.2],
	fan_int_rounding=5,
	fan_ext_roundung=10-0.4,
	screw_hole_diam=3.75,
	corner_clip_shift=5,
	center_clip_shift=5,
	int_clip_size=[15,15],
	int_clip_hole_diam=4.5,
	int_clip_head_size=[9,4],
	int_clip_diff=[105,105],
	quality=2
)
{
	cutClr=1;
	rounding=5;

	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					//base
					cube_vround(size=ext_size,center_xy=true,quality=quality,rounding=rounding);
					//fan
					cube_vround(size=fan_ext_clip_size,center_xy=true,quality=quality,rounding=fan_ext_roundung);
				}
				//fan cut (bottom)
				translate([0,0,-cutClr])
				cube_vround(size=[fan_int_size[0]-2*fan_int_size[3],fan_int_size[1]-2*fan_int_size[3],fan_ext_clip_size[2]+2*cutClr],center_xy=true,quality=quality,rounding=fan_int_rounding);
				//fan cut (top)
				translate([0,0,ext_size[2]])
				cube_vround(size=[fan_int_size[0]+2*fan_int_size[2],fan_int_size[1]+2*fan_int_size[2],fan_ext_clip_size[2]],center_xy=true,quality=quality,rounding=fan_int_rounding);
			}
			//fan int clips
			for (i=[-1:2:1],j=[-1:2:1])
			translate([i*(fan_int_size[0]-int_clip_size[0]+cutClr)/2,j*(fan_int_size[1]-int_clip_size[1]+cutClr)/2,0])
			cube_vround(size=[int_clip_size[0]+cutClr,int_clip_size[1]+cutClr,ext_size[2]],center_xy=true,rounding=fan_int_rounding,quality=quality,round_corners=[i<0&&j<0, i<0&&j>0, i>0&&j>0, i>0&&j<0]);
		}
		for (i=[-1:2:1],j=[-1:2:1])
		translate([i*int_clip_diff[0]/2,j*int_clip_diff[1]/2,-cutClr])
		{
			//fan internal clip - screw holes
			cylinder(d=int_clip_hole_diam,h=fan_ext_clip_size[2]+2*cutClr,center=false,$fn=quality*12);
			//fan internal clip - screw heads
			cylinder(d=int_clip_head_size[0],h=int_clip_head_size[1]+cutClr,center=false,$fn=quality*12);
		}
		//center clip holes
		for (j=[-1:2:1])
		translate([0,j*(ext_size[1]/2-center_clip_shift),ext_size[2]/2])
		cylinder(d=screw_hole_diam,h=ext_size[2]+2*cutClr,center=true,$fn=quality*12);
		//corner clip holes
		for (i=[-1:2:1],j=[-1:2:1])
		translate([i*(ext_size[0]/2-corner_clip_shift),j*(ext_size[1]/2-corner_clip_shift),ext_size[2]/2])
		cylinder(d=screw_hole_diam,h=ext_size[2]+2*cutClr,center=true,$fn=quality*12);
	}
}

FanMount();
