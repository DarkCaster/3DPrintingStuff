use <HotendMount.scad>

module VNutPocket
(
	nut_diam=6.65,
	nut_height=2.8,
	pocket_len=10,
)
{
	m=(nut_diam/2)*sqrt(3)/2;
	rotate(a=90,v=[0,0,1])
		rotate(a=90,v=[0,-1,0])
			union()
			{
				cylinder(d=nut_diam,h=nut_height,center=true,$fn=6);
				translate([pocket_len/2,0,0])
				cube(size=[pocket_len,m*2,nut_height],center=true);
			}
}

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
	fan_clips_wires_cut_diam=3,
	fan_clips_wires_x_shift=7,
	//part fan clip ports
	part_fan_clip_size=[8,8,8],
	part_fan_clip_screws_diam=3.2,
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
			union()
			{
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

				//part fan clips
				for(i=[0,1])
				mirror(v=[i,0,0])
				{
					hull()
					{
						translate([fan_size[0]/2+part_fan_clip_size[0]/2,0,-hotend_mount_height-part_fan_clip_size[2]/2])
						cube(size=part_fan_clip_size,center=true);
						translate([fan_size[0]/2+cutClr/2,hotend_front+cutClr/2,-hotend_mount_height-part_fan_clip_size[2]/2])
						cube(size=[cutClr,cutClr,part_fan_clip_size[2]],center=true);
					}
				}
			}

			//part fan clip-cuts
			for(i=[0,1])
			mirror(v=[i,0,0])
			translate([fan_size[0]/2+part_fan_clip_size[0]/2+cutClr,0,-hotend_mount_height-part_fan_clip_size[2]/2])
			{
				rotate(a=90,v=[0,1,0])
				cylinder(d=part_fan_clip_screws_diam,h=part_fan_clip_size[0]+cutClr,center=true,$fn=quality*12);
				rotate(a=90,v=[1,0,0])
				rotate(a=90,v=[0,0,1])
				VNutPocket();
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
			translate([-fan_mount_size[0]/2-cutClr-part_fan_clip_size[0],-hotend_back-cutClr,-hotend_mount_height-extra_top_cut])
			cube(size=[fan_mount_size[0]+2*cutClr+2*part_fan_clip_size[0],hotend_front+hotend_back+cutClr,hotend_mount_height+extra_top_cut+cutClr],center=false);

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

			//fan wires cut
			translate([fan_clips_wires_x_shift,hotend_front,0])
			rotate(a=-90,v=[1,0,0])
			cylinder(d=fan_clips_wires_cut_diam,h=fan_mount_size[2]+cutClr,center=false,$fn=quality*12);
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
