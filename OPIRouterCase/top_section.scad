use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/stand.scad>

module top_section(
size=[100,50],
screw_diam=3,
screw_clearance=0.2,
wall_sz=2,
base_sz=2,
center_xy=false,
center_z=false,
attach=0,
quality=2,
)
{
	attach_clearance=0.05;
	plug_diam=37.3;
	plug_shift=5+plug_diam/2;
	plug_height=19;
	plug_wall_sz=2;
	plug_cut1_sz=33.5;
	plug_cut2_sz=10;
	plug_cut3_sz=4;
	assert(len(size)==2);
	size_x=size[0];
	size_y=size[1];
	height=wall_sz;
	assert(screw_diam>1);
	assert(screw_diam<=6);
	assert(attach>=0);
	min_szx=plug_shift+plug_diam/2+2*plug_wall_sz;
	min_szy=plug_diam+2*plug_wall_sz;
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);
	plug_inner_diam=plug_diam-plug_wall_sz*2;
	plug_cut1_inner_sz=plug_cut1_sz-plug_wall_sz*2;
	translate([center_xy?0:size_x/2,center_xy?0:size_y/2,center_z?-height/2:0])
	{
		difference()
		{
			union()
			{
				//case section
				case_section(size=[size_x,size_y,height],
					screw_diam=screw_diam,
					screw_clearance=screw_clearance,
					wall_sz=wall_sz,
					base_sz=base_sz,
					attach=attach,
					quality=quality,
					center_xy=true);
				translate([-size_x/2+plug_shift,0,(plug_height-attach_clearance)/2+base_sz])
					intersection()
					{
						cylinder(d=plug_diam,
							h=plug_height+attach_clearance,
							center=true,$fn=24*quality);
						union()
						{
							cube(size=[plug_diam,plug_cut1_sz,plug_height+attach_clearance],
								center=true);
							cube(size=[plug_cut3_sz,plug_diam,plug_height+attach_clearance],
							center=true);
						}
					}
			}
			translate([-size_x/2+plug_shift,0,(plug_height+base_sz)/2])
				intersection()
				{
					cylinder(d=plug_inner_diam,
						h=plug_height+base_sz+2*attach_clearance,
						center=true,$fn=24*quality);
					cube(size=[plug_inner_diam,plug_cut1_inner_sz,plug_height+base_sz+2*attach_clearance],
						center=true);
				}
			translate([-size_x/2+plug_shift,0,base_sz+(plug_height+attach_clearance)/2])
				cube(size=[plug_diam,plug_cut2_sz,plug_height+attach_clearance],
						center=true);
		}
		

	}
}

top_section(center_xy=true,center_z=true);
