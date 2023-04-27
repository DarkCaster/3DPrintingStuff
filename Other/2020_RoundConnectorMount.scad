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


ConnectorMount();