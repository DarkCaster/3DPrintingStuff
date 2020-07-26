use <../OpenSCAD_Modules/cube_vround.scad>

module hdd_clip1(
	len=79,
	height=20,
	quality=2, //integer from 1 to infinity
)
{
	difference()
	{
		union()
		{
			cube_vround(size=[len+8,20,1.6],rounding=2,center_xy=true,quality=quality);
			translate([len/2+2,0,0])
				cube_vround(size=[4,20,height],rounding=2,center_xy=true,quality=quality);
			translate([-len/2-2,0,0])
				cube_vround(size=[4,20,height],rounding=2,center_xy=true,quality=quality);
		}
		translate([0,0,height-4])
			cube(size=[len+10,14,3],center=true);
	}
}

hdd_clip1();