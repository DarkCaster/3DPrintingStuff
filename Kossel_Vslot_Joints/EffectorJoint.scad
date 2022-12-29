//Simple do-(sh)it-yourself joints


module InnerJoint
(
	shaft_diam=3.2,
	shaft_end_diam=6,
	shaft_end_depth=4,
	shaft_droplet_cut=0.4,
	joint_diam=18,
	joint_height=12,
	joint_facet=[0.6,0.5],
	joint_support_diam=6,
	joint_support_len=12,
	quality=10,
)
{
	cutClr=0.1;
	height=joint_height-joint_facet[0]*2;
	length=joint_support_len+joint_diam/2;

	difference()
	{
		union()
		{
			hull()
			{
				//main working body
				cylinder(d=joint_diam,h=height,center=true,$fn=quality*12);
				//facet part of main working body
				cylinder(d=joint_diam-joint_facet[1]*2,h=joint_height,center=true,$fn=quality*12);
			}
			hull()
			{
				//support
				translate([-joint_support_len/2,0,0])
					cube(size=[joint_support_len,joint_support_diam,height],center=true);
				//support of the facet
				translate([-joint_support_len/2,0,0])
					cube(size=[joint_support_len,joint_support_diam-joint_facet[1]*2,joint_height],center=true);
			}
		}
		shaft_length=joint_diam/2+joint_support_len;
		//shaft
		translate([-shaft_length/2+joint_diam/2,0,0])
		rotate(a=90,v=[0,1,0])
		{
			hull()
			{
				//main cut
				cylinder(d=shaft_diam,h=shaft_length+2*cutClr,center=true,$fn=quality*12);
				//droplet cut for shaft for better printing wthout supports
				linear_extrude(height=shaft_length+2*cutClr,center=true)
				polygon(points=[
					[0,-shaft_diam/2],
					[-shaft_diam/2-shaft_droplet_cut,0],
					[0,shaft_diam/2],
				]);
			}
		}
		//front cut for screw-cap
		translate([joint_diam/2-shaft_end_depth/2+cutClr/2,0,0])
		rotate(a=90,v=[0,1,0])
		cylinder(d=shaft_end_diam,h=shaft_end_depth+cutClr,center=true,$fn=quality*12);

	}
}

module OuterJointHalf
(
	joint_diam=[18.2,22],
	joint_height=[12,14],
	joint_groove=[6,5,19],
	joint_angle=[93,-93],
	screw_hole_diam=3.5,
	top_part=false,
	quality=10,
)
{
	cutClr=0.1;
	//difference()
	{
		//main working body
		difference()
		{
			cylinder(d=joint_diam[1],h=joint_height[1],center=true,$fn=quality*12);

		}
		
		//side cut
		ext_rad_x2=joint_diam[1];
		linear_extrude(height=joint_height[1]+2*cutClr,center=true)
		polygon(points=[
			[0,0],
			[cos(joint_angle[0])*ext_rad_x2,sin(joint_angle[0])*ext_rad_x2],
			[cos(135)*ext_rad_x2,sin(135)*ext_rad_x2],
			[cos(135)*ext_rad_x2,-sin(135)*ext_rad_x2],
			[cos(joint_angle[1])*ext_rad_x2,sin(joint_angle[1])*ext_rad_x2],
		]);
	}


}

InnerJoint();
//color([0.75,1,1])
//OuterJointHalf();