use <../OpenSCAD_Modules/cube_vround.scad>

module front_stand(
	use_mirror=false,
	quality=2, //integer from 1 to infinity
	height=85,
	ext_screw_shift=10,
	ext_screw_distance=55,
	hdd_height=27,
	hdd_count=3,
	hdd_width=101.5,
	ext_width=146,
	stand_len=15,
	stand_base_width=5,
	stand_shift=4,
	screw_shift=6,
	screw_depth=2,
)
{
	mirror([0,0,use_mirror?1:0])
	{
		difference()
		{
			union()
			{
				translate([0,0,-stand_base_width])
					cube_vround(round_corners=[true,true,true,true],
						size=[height,stand_len,stand_base_width],
						attach=0, wall_attach=0.01, rounding=3,
						center_xy=false,center_z=false);
				for(x=[0:hdd_count-1])
					translate([stand_shift+hdd_height*x,0,0])
						cube_vround(round_corners=[x==hdd_count-1,x==hdd_count-1,false,false],
							size=[hdd_height,stand_len,(ext_width-hdd_width-stand_base_width*2)/(hdd_count-1)*(use_mirror?(hdd_count-1-x):x)],
							attach=0.01, wall_attach=0.01, rounding=3,
							center_xy=false,center_z=false);
			}
			for(x=[0:hdd_count-1])
			{
				translate([stand_shift+screw_shift+hdd_height*x,5,-stand_base_width-0.01])
					cylinder(d=4,h=ext_width,$fn=6*quality);
				translate([stand_shift+screw_shift+hdd_height*x,5,-stand_base_width-0.01])
					cylinder(d=8,h=stand_base_width-screw_depth+(ext_width-hdd_width-stand_base_width*2)/(hdd_count-1)*(use_mirror?(hdd_count-1-x):x),$fn=6*quality);
				translate([stand_shift+screw_shift+hdd_height*x-4,5-100,(ext_width-hdd_width-stand_base_width*2)/(hdd_count-1)*(use_mirror?(hdd_count-1-x):x)-7])
					cube([8,100,5]);
			}
			translate([ext_screw_shift,12,-stand_base_width-0.01])
				cylinder(d=3,h=stand_base_width+0.02,$fn=6*quality);
			translate([ext_screw_shift+ext_screw_distance,12,-stand_base_width-0.01])
				cylinder(d=3,h=stand_base_width+0.02,$fn=6*quality);
			if(!use_mirror)
				translate([stand_shift+hdd_height*hdd_count,stand_len/2,(ext_width-hdd_width-stand_base_width*2)/(hdd_count-1)*(hdd_count-1)-15])
					rotate([90,0,0])
						cylinder(d=20,h=stand_len+0.1,center=true,$fn=12*quality);
			translate([height/2,stand_len/2,-stand_base_width+8/2])
				rotate([90,0,0])
					cube_vround(size=[8,8+0.01,stand_len+0.1],round_corners=[true,false,false,true],center_xy=true,center_z=true);
			if(use_mirror)
			{
				translate([stand_shift+hdd_height/2-1,stand_len/2,13])
					rotate([90,0,0])
						cube_vround(size=[18,20,stand_len+0.1],center_xy=true,center_z=true);
				for(x=[0:hdd_count-1])
					translate([stand_shift+hdd_height*x+hdd_height-2,-0.1,(ext_width-hdd_width-stand_base_width*2)/(hdd_count-1)*(hdd_count-2-x)])
						cube_vround(round_corners=[x==hdd_count-1,x==hdd_count-1,false,false],
							size=[hdd_height,stand_len+0.2,(ext_width-hdd_width-stand_base_width*2)/(hdd_count-1)*(hdd_count-1-x)+1],
							attach=0.01, wall_attach=0.01, rounding=3,
							center_xy=false,center_z=false);
			}
			else
			{
				translate([stand_shift+hdd_height*2,stand_len/2,10])
					rotate([90,0,0])
						cube_vround(size=[30,10,stand_len+0.1],center_xy=true,center_z=true);
			}
		}
	}
}

front_stand();
//front_stand(use_mirror=true);