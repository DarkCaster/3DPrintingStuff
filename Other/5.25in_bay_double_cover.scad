use <../OpenSCAD_Modules/cube_vround.scad>

module xl_double_cover(
	quality=2, //integer from 1 to infinity
)
{
	ext_len=152;
	ext_width=86;
	wall_sz=2;
	
	main_height=6;
	base_hieght=1;
	clip_cut=20;
	clip_width=12;
	clip_height=12;
	size_int_depth=2;
	int_len=ext_len-size_int_depth*2-wall_sz*2;
	clip_int_height=8;

	difference()
	{
		union()
		{
			//base
			difference()
			{
				translate([0,0,main_height/2])
					cube([ext_width,ext_len,main_height],center=true);
				translate([ext_width/4,0,main_height/2+base_hieght])
					cube([clip_cut,ext_len+0.1,main_height],center=true);
				translate([-ext_width/4,0,main_height/2+base_hieght])
					cube([clip_cut,ext_len+0.1,main_height],center=true);
			}
			translate([ext_width/4,0,clip_height/2])
				cube([clip_width,ext_len,clip_height],center=true);
			translate([-ext_width/4,0,clip_height/2])
				cube([clip_width,ext_len,clip_height],center=true);
		}
		translate([0,0,base_hieght])
			cube_vround(size=[ext_width-wall_sz*2,int_len,clip_height],center_xy=true,quality=quality);
		translate([0,ext_len/2-size_int_depth/2+0.1,base_hieght+clip_int_height/2+0.01])
			cube(size=[ext_width+1,size_int_depth,clip_int_height],center=true);
		translate([0,-(ext_len/2-size_int_depth/2+0.1),base_hieght+clip_int_height/2+0.01])
			cube(size=[ext_width+1,size_int_depth,clip_int_height],center=true);
	}
}

module xl_double_cover_cut(
	quality=2, //integer from 1 to infinity
)
{
	base_hieght=1;
	clip_height=10;
	
	ext_len=152;
	ext_width=86;
	wall_sz=2;
	size_int_depth=2;
	int_len=ext_len-size_int_depth*2-wall_sz*2;
	
	cube_vround(size=[ext_width-wall_sz*2,int_len,clip_height],center_xy=true,quality=quality);
}

xl_double_cover();
xl_double_cover_cut();