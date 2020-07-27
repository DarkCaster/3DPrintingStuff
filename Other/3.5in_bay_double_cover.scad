use <../OpenSCAD_Modules/cube_vround.scad>

module double_cover(
	quality=2, //integer from 1 to infinity
)
{
	main_height=6;
	base_hieght=1;
	clip_cut=12;
	clip_width=8;
	clip_height=10;
	clip_int_height=7;
	size_int_height=5;
	size_int_depth=1;
	difference()
	{
		union()
		{
			//base
			difference()
			{
				translate([0,0,main_height/2])
					cube([52,104,main_height],center=true);
				translate([52/4,0,main_height/2+base_hieght])
					cube([clip_cut,104+0.1,main_height],center=true);
				translate([-52/4,0,main_height/2+base_hieght])
					cube([clip_cut,104+0.1,main_height],center=true);
			}
			translate([52/4,0,clip_height/2])
				cube([clip_width,104,clip_height],center=true);
			translate([-52/4,0,clip_height/2])
				cube([clip_width,104,clip_height],center=true);
		}
		translate([0,0,base_hieght])
			cube_vround(size=[48,98,clip_height],center_xy=true,quality=quality);
		translate([0,104/2-size_int_depth/2+0.1,base_hieght+size_int_height/2+0.01])
			cube(size=[52+1,size_int_depth,size_int_height],center=true);
		translate([0,-(104/2-size_int_depth/2+0.1),base_hieght+size_int_height/2+0.01])
			cube(size=[52+1,size_int_depth,size_int_height],center=true);
	}
}

module double_cover_cut(
	quality=2, //integer from 1 to infinity
)
{
	base_hieght=1;
	clip_height=10;
	cube_vround(size=[48,98,clip_height],center_xy=true,quality=quality);
}

double_cover_cut();
double_cover();