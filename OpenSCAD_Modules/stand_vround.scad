use <cube_vround.scad>

module stand_vround(
	width=6,
	height=4,
	inner_diam=3,
	round_corners=[true,true,true,true],
	rounding=1,
	center_xy=false,
	center_z=false,
	attach=0,
	wall_attach=0,
	quality=2, //integer from 1 to infinity
)
{
	assert(inner_diam<width);
	hole_height=height+attach+0.2;
	hole_mvz=-attach-0.1;
	translate([center_xy?0:width/2,center_xy?0:width/2,center_z?-height/2:0])
	difference()
	{
		//draw rounded cube
		cube_vround(size=[width,width,height],
								round_corners=round_corners,
								rounding=rounding,
								center_xy=true,
								center_z=false,
								attach=attach,
								wall_attach=wall_attach,
								quality=quality);
		//drill the hole
		translate([0,0,hole_mvz])
			cylinder(d=inner_diam,h=hole_height,$fn=12*quality);
	}
}

//example
stand_vround(round_corners=[false,true,false,true],
width=4,
height=2,
inner_diam=3,
rounding=1,
attach=0.1,
wall_attach=0.1,
center_xy=false,center_z=true);
