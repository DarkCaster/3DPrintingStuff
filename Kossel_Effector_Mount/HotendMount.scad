use <EffectorMount_Alt.scad>

module NutPocket
(
	nut_diam=6.75,
	pocket_len=100,
)
{
	m=(nut_diam/2)*sqrt(3)/2;
	cylinder(d=nut_diam,h=pocket_len,center=false,$fn=6);
}

module VNutPocket
(
	nut_diam=6.75,
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

module HotendMount
(
	//mount base parameters
	center_hole_diam=4.6,
	side_hole_diam=3.2,
	side_hole1_pos=[-14,-3],
	side_hole2_pos=[19,-3],
	base_points=[[-18,-15],[24,-15],[24,9],[-18,9]],
	base_height=8,
	side_holes_nut_depth=3,
	//hotend block params
	hotend_block_size=[20.25,12.1,27],
	hotend_block_front=3,
	hotend_screws_diam=3.2,
	hotend_screws_cut_len=24,
	hotend_screws_diff=14,
	hotend_screws_z_shift=-3,
	//hotend cooler params
	cooler_mount_screws_diff=29,
	cooler_mount_screws_y_shift=10,
	cooler_mount_screws_z_shift=-4,
	cooler_mount_screws_diam=3.2,
	cooler_nut_pocket_depth=3,

	quality=2,
)
{
	cutClr=0.1;
	difference()
	{
		//mount base
		translate([0,0,-base_height])
		linear_extrude(height=base_height)
		polygon(points=base_points);

		//central shaft
		translate([0,0,-base_height-cutClr])
		cylinder(d=center_hole_diam,h=base_height+2*cutClr,$fn=quality*12);

		//left mount hole
		translate([side_hole1_pos[0],side_hole1_pos[1],-base_height-cutClr])
		cylinder(d=side_hole_diam,h=base_height+2*cutClr,$fn=quality*12);

		translate([side_hole1_pos[0],side_hole1_pos[1],-base_height+side_holes_nut_depth])
		rotate(a=90,v=[0,0,1])
		rotate(a=180,v=[1,0,0])
		NutPocket(pocket_len=side_holes_nut_depth+cutClr);

		//right mount hole
		translate([side_hole2_pos[0],side_hole2_pos[1],-base_height-cutClr])
		cylinder(d=side_hole_diam,h=base_height+2*cutClr,$fn=quality*12);

		translate([side_hole2_pos[0],side_hole2_pos[1],-base_height+side_holes_nut_depth])
		rotate(a=90,v=[0,0,1])
		rotate(a=180,v=[1,0,0])
		NutPocket(pocket_len=side_holes_nut_depth+cutClr);

		//hotend block cut
		translate([-hotend_block_size[0]/2, -hotend_block_size[1]/2, -hotend_block_size[2]-cutClr])
		cube(size=[hotend_block_size[0],hotend_block_size[1]+hotend_block_front,hotend_block_size[2]+2*cutClr],center=false);

		//hotend block screws
		for(i=[-1,1])
		{
			translate([i*hotend_screws_diff/2,0,hotend_screws_z_shift])
			{
				rotate(a=90,v=[1,0,0])
				cylinder(d=hotend_screws_diam,h=hotend_screws_cut_len+2*cutClr,center=true,$fn=quality*12);
				translate([0,-hotend_screws_cut_len/2,0])
				rotate(a=90,v=[1,0,0])
				NutPocket(pocket_len=hotend_screws_cut_len);
			}
		}

		//cooler mount screws
		for(i=[-1,1])
		{
			translate([i*cooler_mount_screws_diff/2,cooler_mount_screws_y_shift,cooler_mount_screws_z_shift])
			{
				rotate(a=90,v=[1,0,0])
				cylinder(d=cooler_mount_screws_diam,h=hotend_block_size[1]+hotend_block_front,center=true,$fn=quality*12);
				translate([0,-hotend_block_size[1]/2,0])
				rotate(a=180,v=[1,0,0])
				VNutPocket(pocket_len=base_height,nut_height=cooler_nut_pocket_depth);
			}
		}
	}

}

//color([0.25,0.25,0.25])
//EffectorMount(center_xy=true,center_z=true,rotate_motor=true);

HotendMount();
