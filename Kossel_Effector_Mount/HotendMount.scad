use <EffectorMount_Alt.scad>


module HotendMount
(
	//mount base parameters
	center_hole_diam=4.6,
	side_hole_diam=3.2,
	side_hole1_pos=[-14,-3],
	side_hole2_pos=[19,-3],
	base_points=[[-18,-15],[24,-15],[24,13],[-18,13]],
	base_height=8,
	//hotend block params
	hotend_block_size=[20.25,12.1,27],
	hotend_block_front=3, // front cut
	screws_diff=14,

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

		//right mount hole
		translate([side_hole2_pos[0],side_hole2_pos[1],-base_height-cutClr])
		cylinder(d=side_hole_diam,h=base_height+2*cutClr,$fn=quality*12);

		//hotend block cut
		translate([-hotend_block_size[0]/2, -hotend_block_size[1]/2-hotend_block_front, -hotend_block_size[2]-cutClr])
		cube(size=[hotend_block_size[0],hotend_block_size[1]+hotend_block_front,hotend_block_size[2]+2*cutClr],center=false);
	}

}


//color([0.25,0.25,0.25])
//EffectorMount(center_xy=true,center_z=true,rotate_motor=true);

HotendMount();
