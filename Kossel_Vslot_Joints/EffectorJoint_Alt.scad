//Simple do-(sh)it-yourself joints
use <../OpenSCAD_Modules/cube_vround.scad>

module InnerJoint
(
	shaft_diam=2.95,
	clip_length=29, //1 extra mm kept for 2x0.5mm washers
	clip_width=10, //1 extra mm kept for 2x0.5mm washers
	screw_hole_diam=2.95,
	droplet_cut=0.4,
	face_size=9,
	hull_facet=[1,0.5],
	center_cut_diam=4,
	quality=10,
)
{
	cutClr=0.1;
	difference()
	{
		hull()
		{
			//x dimension
			cube(size=[clip_length,face_size,face_size-hull_facet[0]*2],center=true);
			cube(size=[clip_length-hull_facet[1]*2,face_size-hull_facet[1]*2,face_size],center=true);
			//y dimention
			cube(size=[face_size,clip_width,face_size-hull_facet[0]*2],center=true);
			cube(size=[face_size,clip_width-hull_facet[1]*2,face_size],center=true);
		}
		//center cut
		cylinder(d=center_cut_diam,h=face_size+cutClr*2,$fn=quality*10,center=true);
		//main cut (x dimension)
		rotate(a=-90,v=[0,1,0])
		{
			hull()
			{
				cylinder(d=screw_hole_diam,h=clip_length+2*cutClr,center=true,$fn=quality*12);
				linear_extrude(height=clip_length+2*cutClr,center=true)
					polygon(points=[
						[0,-screw_hole_diam/2],
						[screw_hole_diam/2+droplet_cut,0],
						[0,screw_hole_diam/2],
					]);
			}
		}

		//side cut (y dimension)
		rotate(a=90,v=[1,0,0])
		{
			hull()
			{
				//main cut
				cylinder(d=shaft_diam,h=clip_width+2*cutClr,center=true,$fn=quality*12);
				//droplet cut for shaft for better printing wthout supports
				linear_extrude(height=clip_width+2*cutClr,center=true)
				polygon(points=[
					[-shaft_diam/2,0],
					[0,shaft_diam/2+droplet_cut],
					[shaft_diam/2,0],
				]);
			}
		}
	}
	
}

module OuterJoint
(
	shaft_diam=3.15,
	screw_hole_diam=3.2,
	handle_height=40,
	clip_width_int=10+1,
	clip_width=10+1+2+2,
	clip_height=16,
	clip_cut_size=11, //1 for 2x0.5mm washers
	droplet_cut=0.4,
	face_size=9,
	handle_cuts_pos1=16+9/2,
	handle_cuts_pos2=40-9/2,//face_size
	holes_facet=[0.5,0.6],
	quality=10,
)
{
	face_shift=face_size/2;
	cutClr=0.01;

	difference()
	{
		union()
		{
			difference()
			{
				//handle
				translate([0,0,handle_height/2-face_shift])
				rotate(a=90,v=[0,1,0])
				rotate(a=90,v=[1,0,0])
				cube_vround(size=[handle_height,face_size,clip_width],center_xy=true,center_z=true,rounding=face_size/2,quality=quality);

				//hinge clip
				//translate([0,0,clip_height/2-face_shift])
				//cube(size=[face_size+2*cutClr,clip_width_int,clip_height],center=true);

				translate([0,0,handle_height/2-face_shift])
				cube(size=[face_size+2*cutClr,clip_width_int,handle_height+2*cutClr],center=true);
			}

			translate([0,0,handle_height/2+clip_height/2-face_shift])
			rotate(a=90,v=[0,1,0])
			rotate(a=90,v=[1,0,0])
			cube_vround(size=[handle_height-clip_height,face_size,clip_width],center_xy=true,center_z=true,rounding=face_size/2,quality=quality);
		}

		union()
		{
			rotate(a=90,v=[1,0,0])
			cylinder(d=shaft_diam,h=clip_width+2*cutClr,center=true,$fn=quality*12);

			for(i=[-1:2:1])
			rotate(a=i*90,v=[1,0,0])
			translate([0,0,-clip_width/2+holes_facet[1]/2])
			cylinder(d1=shaft_diam+holes_facet[0]*2,d2=shaft_diam,h=holes_facet[1]+2*cutClr,center=true,$fn=quality*12);
		}

		//handle cuts
		union()
		{
			translate([0,0,handle_cuts_pos1-face_shift])
			rotate(a=90,v=[1,0,0])
			cylinder(d=screw_hole_diam,h=clip_width+2*cutClr,center=true,$fn=quality*12);

			translate([0,0,handle_cuts_pos1-face_shift])
			for(i=[-1:2:1])
			rotate(a=i*90,v=[1,0,0])
			translate([0,0,-clip_width/2+holes_facet[1]/2])
			cylinder(d1=screw_hole_diam+holes_facet[0]*2,d2=screw_hole_diam,h=holes_facet[1]+2*cutClr,center=true,$fn=quality*12);
		}

		union()
		{
			translate([0,0,handle_cuts_pos2-face_shift])
			rotate(a=90,v=[1,0,0])
			cylinder(d=screw_hole_diam,h=clip_width+2*cutClr,center=true,$fn=quality*12);

			translate([0,0,handle_cuts_pos2-face_shift])
			for(i=[-1:2:1])
			rotate(a=i*90,v=[1,0,0])
			translate([0,0,-clip_width/2+holes_facet[1]/2])
			cylinder(d1=screw_hole_diam+holes_facet[0]*2,d2=screw_hole_diam,h=holes_facet[1]+2*cutClr,center=true,$fn=quality*12);
		}
	}

}

module NutPocket
(
	nut_diam=6.75,
	pocket_len=100,
)
{
	m=(nut_diam/2)*sqrt(3)/2;
	cylinder(d=nut_diam,h=pocket_len,center=false,$fn=6);
}

module EffectorJoint
(
	shaft_diam=3.1,
	joint_face_size=9,
	clip_y_shift=1.5,
	clip_length_int=30, //1 extra mm kept for 2x0.5mm washers
	clip_length_ext=41,
	clip_base_height=4,
	clip_base_cut_size=[12,8.5],
	clip_base_cut2_size=[7,12],
	clip_base_corner_pos=[35,7],
	clip_base_corner_rounding=7,
	clip_base_screw_pos=[22,35],
	clip_base_screw_diam=3.2,
	droplet_cut=0.4,
	nut_diam=6.75,
	nut_depth=2,
	quality=10,
)
{
	cutClr=0.01;
	//cutClr=1;

	base_screw_support_sz=[clip_length_ext/2,clip_base_corner_pos[1]+clip_base_corner_rounding];
	base_screw_support_r=clip_base_corner_rounding;

	clip_center_shift=(clip_length_ext-clip_length_int)/2;
	clip_cut_center_shift=(clip_length_ext-clip_base_cut_size[0])/2;
	clip_cut2_center_shift=clip_length_ext/2;

	translate([-clip_length_ext/2,clip_y_shift+joint_face_size/2,0])
	difference()
	{
		union()
		{
			//clip
			for(i=[-1:2:1])
			{
				//top edge
				rotate(a=i<0?0:60,v=[0,0,1])
				mirror([0,i<0?0:1,0])
				{
					//clip base
					translate([0,-joint_face_size/2-clip_y_shift,0])
					rotate(a=90,v=[0,1,0])
					cube_vround(size=[joint_face_size,joint_face_size+cutClr,clip_length_ext],center_xy=true,center_z=false,rounding=joint_face_size/2,round_corners=[false,true,true,true],quality=quality);
					//clip shift
					translate([0,-clip_y_shift,-joint_face_size/2])
					cube([clip_length_ext,clip_y_shift+cutClr,clip_base_height]);
				}
			}

			//base screws supports
			translate([0,0,-joint_face_size/2])
			hull()
			for(i=[-1:2:1])
			{
				//top edge
				rotate(a=i<0?0:60,v=[0,0,1])
				mirror([0,i<0?0:1,0])
				{
					translate([base_screw_support_sz[0],0,0])
					cube_vround(size=[base_screw_support_sz[0],base_screw_support_sz[1],clip_base_height],center_xy=false,center_z=false,rounding=base_screw_support_r,round_corners=[true,false,false,false],quality=quality);
				}
			}

			//middle
			translate([0,0,-joint_face_size/2])
			linear_extrude(height=clip_base_height)
			polygon(points=[
				[0,0],
				[clip_length_ext*cos(60),clip_length_ext*sin(60)],
				[clip_length_ext,0],
			]);
		}

		for(i=[-1:2:1])
		{
			//top edge
			rotate(a=i<0?0:60,v=[0,0,1])
			mirror([0,i<0?0:1,0])
			{
				//clip cut
				translate([clip_center_shift,-joint_face_size-clip_y_shift-cutClr,-joint_face_size/2-cutClr])
				cube([clip_length_int,joint_face_size+cutClr+clip_y_shift,joint_face_size+2*cutClr]);

				//clip base cut
				translate([clip_cut_center_shift,-clip_y_shift-joint_face_size/2,-joint_face_size/2-cutClr])
				cube([clip_base_cut_size[0],clip_base_cut_size[1],joint_face_size+2*cutClr]);

				//clip base cut
				translate([clip_cut2_center_shift,-clip_y_shift-joint_face_size/2,0])
				rotate(a=-90,v=[1,0,0])
				cylinder(d=clip_base_cut2_size[0], h=clip_base_cut2_size[1], center=false, $fn=quality*12);
				//cube([clip_base_cut2_size[0],clip_base_cut2_size[1],joint_face_size+2*cutClr]);

				//inner clip mount cut (droplet shaped)
				translate([clip_length_ext+cutClr,-clip_y_shift-joint_face_size/2,0])
				rotate(a=-90,v=[0,1,0])
				{
					hull()
					{
						cylinder(d=shaft_diam,h=clip_length_ext+2*cutClr,center=false,$fn=quality*12);
						linear_extrude(height=clip_length_ext+2*cutClr,center=false)
							polygon(points=[
								[0,-shaft_diam/2],
								[shaft_diam/2+droplet_cut,0],
								[0,shaft_diam/2],
							]);
					}
				}
			}
		}


		rotate(a=30,v=[0,0,1])
		{
			//screw hole 1
			translate([clip_base_screw_pos[0],0,-joint_face_size/2-cutClr])
			cylinder(d=clip_base_screw_diam, h=clip_base_height+2*cutClr, center=false, $fn=quality*12);

			//screw hole 2
			translate([clip_base_screw_pos[1],0,-joint_face_size/2-cutClr])
			cylinder(d=clip_base_screw_diam, h=clip_base_height+2*cutClr, center=false, $fn=quality*12);

			//nut hole 1
			translate([clip_base_screw_pos[0],0,-joint_face_size/2+nut_depth])
			rotate(a=180,v=[1,0,0])
			NutPocket(nut_diam=nut_diam,pocket_len=joint_face_size);

			//nut hole 2
			translate([clip_base_screw_pos[1],0,-joint_face_size/2+nut_depth])
			rotate(a=360/12,v=[0,0,1])
			rotate(a=180,v=[1,0,0])
			NutPocket(nut_diam=nut_diam,pocket_len=joint_face_size);
		}
	}

	//calculate effector properties
	echo("Effector properties (see https://reprap.org/wiki/Delta_geometry for more info)");
	//b distance
	y_shift_distance=clip_y_shift+joint_face_size/2;
	h_shift_distance=y_shift_distance/tan(30);
	b_distance=h_shift_distance+clip_length_ext/2;
	echo("B distance:",b_distance);
	//TODO: arm space
	//TODO: effector offset
}

EffectorJoint();

InnerJoint();

//half of the joint handle
//OuterJoint();
difference() { OuterJoint(); translate([0,-50,0]) cube(size=[100,100,100], center=true); }