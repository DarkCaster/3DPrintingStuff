use <../OpenSCAD_Modules/cube_vround.scad>

module ConnectorMount
(
	mount_size=[20,30,4],
	clip_arm_size=30,
	support_triangle_sz=[20,7,5],
	rounding=3,
	screw_hole_diam=3.5,
	screw_hole_diff=15,
	connector_inner_cut_diam=19,
	connector_outer_cut_diam=22,
	quality=4,
)
{
	cutClr=0.1;
	difference()
	{
		union()
		{
			//mount base
			translate([-mount_size[0],-mount_size[1]/2,])
			cube_vround(size=[mount_size[0]+clip_arm_size,mount_size[1],mount_size[2]],
				rounding=rounding,
				quality=quality,center_xy=false);

			for(i=[-1,1])
			translate([0,i*(mount_size[1]/2-support_triangle_sz[2]/2),0])
			rotate(a=-90,v=[1,0,0])
			linear_extrude(height=support_triangle_sz[2],center=true)
			polygon(points=[
				[0,0],
				[0,-cutClr],
				[support_triangle_sz[0],-cutClr],
				[support_triangle_sz[0],0],
				[0,support_triangle_sz[1]],
			]);
		}

		//screw holes
		for(i=[-1,1])
		translate([-mount_size[0]/2,i*screw_hole_diff/2,-cutClr])
		cylinder(d=screw_hole_diam,h=mount_size[2]+2*cutClr,center=false,$fn=quality*12);

		//connector inner cut
		translate([clip_arm_size/2,0,-cutClr])
		cylinder(d=connector_inner_cut_diam,h=mount_size[2]+2*cutClr,center=false,$fn=quality*12);

		//connector outer
		//color([0,0,0])
		translate([clip_arm_size/2,0,-support_triangle_sz[1]-cutClr])
		cylinder(d=connector_outer_cut_diam,h=support_triangle_sz[1]+cutClr,center=false,$fn=quality*12);
	}
}

module MountCover
(
	//2mm inner wall, 2mm outer wall, 10mm back wall, 20mm inner height, 22mm outer height
	mount_size=[20,30,4, 2,2,15,33,35],
	extra_back_cut=[5,20],
	clearance=0.1,
	clip_arm_size=30,
	rounding=3,
	top_holes_x_pos=-10,
	top_holes_diff=[15,21],
	top_holes_diam=5,
	side_holes_x_pos=-5,
	side_holes_diam=5,
	back_hole_z_pos=20,
	back_hole_diam=4.8,
	quality=4,
)
{
	cutClr=0.1;
	cover_back_size=mount_size[0]+mount_size[4]+mount_size[5];
	cover_front_size=clip_arm_size+mount_size[4];
	cover_width=mount_size[1]+2*mount_size[4];

	cover_cut_back_size=cover_back_size-mount_size[4]-mount_size[5]+clearance;
	cover_cut_front_size=cover_front_size-mount_size[4]+clearance;
	cover_cut_width=cover_width-2*mount_size[4]+2*clearance;

	cover_int_back_size=cover_back_size-mount_size[3]-mount_size[4]-mount_size[5];
	cover_int_front_size=cover_front_size-mount_size[3]-mount_size[4];
	cover_int_width=cover_width-2*(mount_size[3]+mount_size[4]);

	difference()
	{
		//external hull
		translate([-cover_back_size,-cover_width/2,0])
		cube_vround(size=[cover_back_size+cover_front_size,cover_width,mount_size[7]],
			rounding=rounding+mount_size[4],
			quality=quality,
			center_xy=false);

		//bottom wall cut
		translate([-cover_cut_back_size,-cover_cut_width/2,-cutClr])
		cube_vround(size=[cover_cut_back_size+cover_cut_front_size,cover_cut_width,mount_size[2]+cutClr],
			rounding=rounding,
			quality=quality,center_xy=false);

		//inner wall cut
		translate([-cover_int_back_size,-cover_int_width/2,-cutClr])
		cube_vround(size=[cover_int_back_size+cover_int_front_size,cover_int_width,mount_size[6]+cutClr],
			rounding=rounding-mount_size[3],
			quality=quality,center_xy=false);

		//extra back cut
		translate([-extra_back_cut[0]-cover_int_back_size-mount_size[3],-extra_back_cut[1]/2,-cutClr])
		cube_vround(size=[extra_back_cut[0]+mount_size[3]+cutClr,extra_back_cut[1],mount_size[6]+cutClr],
			rounding=2,round_corners=[false,false,true,true],
			quality=quality,center_xy=false);

		//cable ans service holes
		//top holes
		for(i=[-1,1])
		{
			hull()
			{
				translate([top_holes_x_pos,i*top_holes_diff[0]/2,-cutClr])
				cylinder(d=top_holes_diam,h=mount_size[7]+2*cutClr, center=false, $fn=quality*12);
				translate([top_holes_x_pos,i*top_holes_diff[1]/2,-cutClr])
				cylinder(d=top_holes_diam,h=mount_size[7]+2*cutClr, center=false, $fn=quality*12);
			}
		}
		//side holes
		hull()
		{
			translate([side_holes_x_pos,0,mount_size[2]+side_holes_diam/2])
			rotate(a=90,v=[1,0,0])
			cylinder(d=side_holes_diam,h=cover_width+2*cutClr, center=true, $fn=quality*12);
			translate([side_holes_x_pos,0,-mount_size[2]-side_holes_diam/2])
			rotate(a=90,v=[1,0,0])
			cylinder(d=side_holes_diam,h=cover_width+2*cutClr, center=true, $fn=quality*12);
		}
		//back hole
		translate([cutClr,0,back_hole_z_pos])
		rotate(a=-90,v=[0,1,0])
		cylinder(d=back_hole_diam,h=cover_back_size+2*cutClr, center=false, $fn=quality*12);
	}
}

ConnectorMount();
MountCover();