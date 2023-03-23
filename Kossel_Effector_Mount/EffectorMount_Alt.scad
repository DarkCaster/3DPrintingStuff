use <../OpenSCAD_Modules/cube_vround.scad>
use <../Kossel_Vslot_Joints/EffectorJoint_Alt.scad>

module EffectorMount
(
	clip_length_ext=41,
	clip_base_screw_pos=[22,35], //from effector joint
	clip_base_screw_tab_diam=8,
	clip_base_screw_diam=3.5,
	clip_base_screw_top_diam=7,

	center_hole_diam=4.2,
	side_hole_diam=3.2,
	side_hole1_pos=[-14,-3],
	side_hole2_pos=[19,-3],
	tool_base=[[-18,-15],[24,-15],[24,13],[-18,13]],
	tool_rotation=30,

	stiffeners_radius=2,
	arm_len=90,
	base_height=2,
	droplet_cut=0.4,
	nut_diam=6.75,
	nut_depth=1,
	quality=10,
)
{
	cutClr=0.01;

	//effector triangle geometric params
	R=arm_len*sqrt(3)/3;
	r=R/2;
	center_shift=[arm_len/2, r, 0];
	corner_shift=[clip_length_ext/2, tan(30)*clip_length_ext/2, 0];

	//translation vectors
	from_corner_to_zero=[-corner_shift[0],-corner_shift[1],0];
	from_corner_to_eff_center=[from_corner_to_zero[0]-center_shift[0],from_corner_to_zero[1]-center_shift[1],0];
	from_eff_center_to_corner=-from_corner_to_eff_center;
	from_zero_to_corner=-from_corner_to_zero;

	module stiffener_part()
	{
		intersection()
		{
			sphere(r=stiffeners_radius,$fn=quality*12);
			translate([0,0,-cutClr])
			cylinder(r=stiffeners_radius+cutClr,h=stiffeners_radius+2*cutClr,$fn=quality*12);
		}
	}

	module stiffener_l(base_height=base_height)
	{
		diff=clip_base_screw_tab_diam/2-stiffeners_radius;
		hull()
		{
			translate([0,-r+stiffeners_radius+diff,base_height])
			stiffener_part();

			translate(from_corner_to_eff_center)
			rotate(a=30,v=[0,0,1])
			translate([clip_base_screw_pos[0],0,base_height])
			stiffener_part();
		}
	}

	module stiffener_r(base_height=base_height)
	{
		mirror([1,0,0])
		rotate(a=120,v=[0,0,1])
		stiffener_l(base_height=base_height);
	}

	module base(base_height=base_height)
	{
		for(i=[0,1,2])
		rotate(a=120*i,v=[0,0,1])
		hull()
		{
			//clip base screw tabs
			translate(from_corner_to_eff_center)
			rotate(a=30,v=[0,0,1])
			translate([clip_base_screw_pos[0],0,0])
			cylinder(d=clip_base_screw_tab_diam, h=base_height, center=false, $fn=quality*12);
			//effector middle points
			linear_extrude(height=base_height)
			polygon(points=[[0,-r],[r*cos(30),r*sin(30)],[-r*cos(30),r*sin(30)]]);
		}
	}

	translate(from_eff_center_to_corner)
	translate([0,0,-base_height])
	difference()
	{
		union()
		{
			base();
			//stiffeners
			for(i=[0,1,2])
			rotate(a=120*i,v=[0,0,1])
			{
				stiffener_l();
				stiffener_r();
			}
			//tool mount
			intersection()
			{
				base(base_height=base_height+stiffeners_radius+cutClr);
				//mount
				color([0.5,0.5,0.5])
				rotate(a=tool_rotation,v=[0,0,1])
				linear_extrude(height=base_height+stiffeners_radius)
				polygon(points=tool_base);
			}
		}

		//clip base screw holes
		for(i=[0,1,2])
		rotate(a=120*i,v=[0,0,1])
		translate(from_corner_to_eff_center)
		rotate(a=30,v=[0,0,1])
		{
			translate([clip_base_screw_pos[0],0,-cutClr])
			cylinder(d=clip_base_screw_diam, h=base_height+2*cutClr, center=false, $fn=quality*12);
			translate([clip_base_screw_pos[0],0,base_height])
			cylinder(d=clip_base_screw_top_diam, h=stiffeners_radius+cutClr, center=false, $fn=quality*12);

			translate([clip_base_screw_pos[1],0,-cutClr])
			cylinder(d=clip_base_screw_diam, h=base_height+2*cutClr, center=false, $fn=quality*12);
			translate([clip_base_screw_pos[1],0,base_height])
			cylinder(d=clip_base_screw_top_diam, h=stiffeners_radius+cutClr, center=false, $fn=quality*12);
		}

		vcut=base_height+stiffeners_radius+2*cutClr;
		//tool holes
		rotate(a=tool_rotation,v=[0,0,1])
		{
			//center hole
			translate([0,0,-cutClr])
			cylinder(d=center_hole_diam, h=vcut, center=false, $fn=quality*12);
			//side holes
			translate([side_hole1_pos[0],side_hole1_pos[1],-cutClr])
			cylinder(d=side_hole_diam, h=vcut, center=false, $fn=quality*12);
			translate([side_hole2_pos[0],side_hole2_pos[1],-cutClr])
			cylinder(d=side_hole_diam, h=vcut, center=false, $fn=quality*12);
		}
	}

	//stiffeners
}

if($preview)
translate([41/2,-9/2-1.5,0])
color([0.5,0.2,0.3])
EffectorJoint();

EffectorMount();