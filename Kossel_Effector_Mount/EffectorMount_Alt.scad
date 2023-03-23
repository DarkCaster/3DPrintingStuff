use <../OpenSCAD_Modules/cube_vround.scad>
use <../Kossel_Vslot_Joints/EffectorJoint_Alt.scad>

module EffectorMount
(
	clip_length_ext=41,
	clip_base_screw_pos=[22,35],
	clip_base_screw_ext_diam=10,
	clip_base_screw_diam=3.5,
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

	translate(from_eff_center_to_corner)
	translate([0,0,-base_height])
	difference()
	{
		union()
		{
			for(i=[0,1,2])
			rotate(a=120*i,v=[0,0,1])
			hull()
			{
				//clip base screw tabs
				translate(from_corner_to_eff_center)
				rotate(a=30,v=[0,0,1])
				translate([clip_base_screw_pos[0],0,0])
				cylinder(d=clip_base_screw_ext_diam, h=base_height, center=false, $fn=quality*12);
				//effector middle points
				linear_extrude(height=base_height)
				polygon(points=[[0,-r],[r*cos(30),r*sin(30)],[-r*cos(30),r*sin(30)]]);
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
			translate([clip_base_screw_pos[1],0,-cutClr])
			cylinder(d=clip_base_screw_diam, h=base_height+2*cutClr, center=false, $fn=quality*12);
		}
	}

	//stiffeners
}

translate([41/2,-9/2-1.5,0])
color([0.5,0.2,0.3])
EffectorJoint();

EffectorMount();