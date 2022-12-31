//Simple do-(sh)it-yourself joints
use <../OpenSCAD_Modules/cube_vround.scad>

module InnerJoint
(
	shaft_diam=3.05,
	shaft_end_diam=6,
	shaft_end_depth=6,
	shaft_droplet_cut=0.4,
	joint_diam=18,
	joint_height=11.8,
	joint_facet=[1,0.5],
	joint_support_diam=6,
	joint_support_len=11,
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
	joint_diam=[18.05,22],
	joint_height=[12,14],
	joint_groove=[6,5,19],
	joint_angle=[90,-110],
	handle_size=[8,40],
	front_clip_size=[6,15],
	front_hole_pos=[3,-12],
	back_hole_pos=[4,12,36],
	screw_hole_diam=3.25,
	central_hole_diam=10,
	top_part=false,
	quality=10,
)
{
	cutClr=0.1;
	difference()
	{
		difference()
		{
			union()
			{
				//outer shell
				//hull()
				{
					cylinder(d=joint_diam[1],h=joint_height[1],center=true,$fn=quality*12);
					//front clip
					translate([0,-front_clip_size[1],0])
					cube_vround(size=[front_clip_size[0],front_clip_size[1],joint_height[1]],rounding=front_clip_size[0]/2, center_xy=false,center_z=true,quality=quality);
				}
				//handle
				cube_vround(size=[handle_size[0],handle_size[1],joint_height[1]],rounding=handle_size[0]/2, center_xy=false,center_z=true,quality=quality);
			}
			//front hole
			translate([front_hole_pos[0],front_hole_pos[1],0])
			cylinder(d=screw_hole_diam,h=joint_height[1]+2*cutClr,center=true,$fn=quality*12);
			//back hole1
			translate([back_hole_pos[0],back_hole_pos[1],0])
			cylinder(d=screw_hole_diam,h=joint_height[1]+2*cutClr,center=true,$fn=quality*12);
			//back hole2
			translate([back_hole_pos[0],back_hole_pos[2],0])
			cylinder(d=screw_hole_diam,h=joint_height[1]+2*cutClr,center=true,$fn=quality*12);
			//inner shell - main working surface
			cylinder(d=joint_diam[0],h=joint_height[0],center=true,$fn=quality*12);
			//groove
			hull()
			{
				cylinder(d=joint_diam[0],h=joint_groove[0],center=true,$fn=quality*12);
				cylinder(d=joint_groove[2],h=joint_groove[1],center=true,$fn=quality*12);
			}
			//central hole
			cylinder(d=central_hole_diam,h=joint_height[1]+2*cutClr,center=true,$fn=quality*12);
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

		//top or bottom half cut
		if(top_part)
		{
			cube_vround(size=[joint_diam[1]+2*cutClr,(handle_size[1]+cutClr)*2,joint_height[1]/2+cutClr],round_corners=[false,false,false,false], center_xy=true,center_z=false,quality=quality);
		}
		else
		{
			translate([0,0,-joint_height[1]/2-cutClr])
			cube_vround(size=[joint_diam[1]+2*cutClr,(handle_size[1]+cutClr)*2,joint_height[1]/2+cutClr],round_corners=[false,false,false,false], center_xy=true,center_z=false,quality=quality);
		}
	}
}

InnerJoint();
color([0.75,0.75,1])
{
	OuterJointHalf(top_part=true);
	OuterJointHalf(top_part=false);
}
