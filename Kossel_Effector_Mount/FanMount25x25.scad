use <HotendMount.scad>

module FanMount
(
	//hotend block params
	hotend_size=[20.25,12.1,27],
	hotend_cut_size=[21,13,27],
	hotend_front=11,
	hotend_mount_height=8,
	//shell
	shell_wall_size=2,
	extra_top_cut=0.2,
	//25x25 fan mount
	fan_size=[25.5,10.2,25.5],
	fan_air_hole_diam=24,
	fan_mount_size=[36,30,12,26.2],
	fan_mount_screws_diff=29,
	fan_mount_screws_z_shift=-4,
	fan_mount_screws_diam=3.2,
	//internal pins
	fan_clips_pins_diff=[20,20],
	fan_clips_pins_diam=2.9,
	fan_clips_pins_height=2,
	//other
	quality=2,
)
{
	cutClr=0.1;
	hotend_back=hotend_size[1]/2;

	union()
	{
		difference()
		{
			//outer hull
			hull()
			{
				//fan mount top clip
				translate([-fan_mount_size[0]/2,hotend_front,-hotend_mount_height])
				cube(size=[fan_mount_size[0],fan_mount_size[2],hotend_mount_height],center=false);

				//fan mount main body
				translate([-fan_mount_size[1]/2,hotend_front,-fan_mount_size[3]])
				cube(size=[fan_mount_size[1],fan_mount_size[2],fan_mount_size[3]],center=false);

				//shroud outer shell
				shroud_width=hotend_size[0]+2*shell_wall_size;
				translate([-shroud_width/2,-hotend_back,-fan_mount_size[3]])
				cube(size=[shroud_width,hotend_back+hotend_front+cutClr,fan_mount_size[3]],center=false);
			}

			//inner hull
			hull()
			{
				//fan mount inner cut
				translate([-fan_size[0]/2,hotend_front,-fan_size[2]])
				cube(size=[fan_size[0],fan_size[1],fan_size[2]+cutClr],center=false);

				translate([-hotend_size[0]/2,-hotend_back-cutClr,-fan_size[2]])
				cube(size=[hotend_size[0],hotend_back+hotend_front+2*cutClr,fan_size[2]+cutClr],center=false);
			}

			//hotend mount top cut
			translate([-fan_mount_size[0]/2-cutClr,-hotend_back-cutClr,-hotend_mount_height-extra_top_cut])
			cube(size=[fan_mount_size[0]+2*cutClr,hotend_front+hotend_back+cutClr,hotend_mount_height+extra_top_cut+cutClr],center=false);

			//fan mount air hole
			translate([0,hotend_front,-fan_size[2]/2])
			rotate(a=-90,v=[1,0,0])
			cylinder(d=fan_air_hole_diam,h=fan_mount_size[2]+cutClr,center=false,$fn=quality*24);

			//fan mount screw holes
			for(i=[-1,1])
			translate([i*fan_mount_screws_diff/2,hotend_front-cutClr,fan_mount_screws_z_shift])
			rotate(a=-90,v=[1,0,0])
			cylinder(d=fan_mount_screws_diam,h=fan_mount_size[2]+2*cutClr,center=false,$fn=quality*12);

			//hotend block cut
			translate([-hotend_cut_size[0]/2,-hotend_cut_size[1]/2,-hotend_cut_size[2]])
			cube(size=[hotend_cut_size[0],hotend_cut_size[1],hotend_cut_size[2]],center=false);
		}

		//fan clipping pins
		for(i=[-1,1],j=[1])
		translate([i*fan_clips_pins_diff[0]/2,hotend_front+fan_size[1]+cutClr,j*fan_clips_pins_diff[1]/2-fan_size[2]/2])
		rotate(a=90,v=[1,0,0])
		cylinder(d=fan_clips_pins_diam,h=fan_clips_pins_height+cutClr,center=false,$fn=quality*12);
	}

}

FanMount();

if($preview)
color([1,1,1,0.25])
render() HotendMount();
