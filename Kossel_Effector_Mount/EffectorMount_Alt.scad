use <../OpenSCAD_Modules/cube_vround.scad>
use <../Kossel_Vslot_Joints/EffectorJoint_Alt.scad>

module EffectorMount
(
	clip_length_ext=41,
	arm_len=90,
	base_height=2,
	droplet_cut=0.4,
	nut_diam=6.75,
	nut_depth=1,
	quality=10,
)
{
	cutClr=0.01;
	mount_shift=[clip_length_ext/2,tan(30)*clip_length_ext/2,0];


	//base
	translate(mount_shift)
	{
		//triangle base
		translate([0,0,-base_height])
		linear_extrude(height=base_height)
		polygon(points=[[0,0],[arm_len,0],[arm_len/2,cos(30)*arm_len]]);
	}

	//outer triangle ?
	//inner triangle
	//edge clips
	//stiffeners
}

translate([41/2,-9/2-1.5,0])
color([0.5,0.2,0.3])
EffectorJoint();

EffectorMount();