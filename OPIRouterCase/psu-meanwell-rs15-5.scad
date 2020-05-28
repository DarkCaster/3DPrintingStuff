use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand.scad>

module psu_rs15_section(
size=[108,66],
screw_diam=3,
screw_clearance=0.2,
wall_sz=2,
base_sz=2,
center_xy=false,
center_z=false,
attach=0,
quality=2,
vent_size=[5,2],
vent_period=[10,3],
vent_angle=70,
psu_clearance=1,
)
{
	attach_clearance=0.05;
	plug_diam=33.3;
	stand_base_diam=12;
	plug_shift=5+plug_diam/2;
	plug_height_corr=-4+base_sz;
	psu_size=[76,51.5,28.5];
	psu_clr_mode=psu_size[0]>psu_size[1];
	psu_screw_dy=15;
	psu_screw_diam=3;
	psu_screw_ext_diam=5;
	psu_screw_dx1=11.5;
	psu_screw_dx2=51;
	assert(len(size)==2);
	size_x=size[0];
	size_y=size[1];
	height=base_sz+psu_size[2]+psu_clearance*2;
	assert(screw_diam>1);
	assert(screw_diam<=6);
	assert(attach>=0);
	max_subsz=max(psu_size[1],plug_diam);
	max_wallsz=max(wall_sz,plug_shift+stand_base_diam/2);
	min_szx=max_wallsz+wall_sz+2*(psu_clr_mode?psu_clearance:screw_diam+wall_sz)+psu_size[0];
	min_szy=2*(wall_sz+(psu_clr_mode?screw_diam+wall_sz:psu_clearance))+max_subsz;
	psu_stand_sz=psu_clr_mode?(size_y-psu_size[1]-2*wall_sz)/2:psu_clearance;
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);
	psu_mvx=size_x/2-psu_size[0]/2-(psu_clr_mode?psu_clearance:screw_diam+wall_sz)-wall_sz;
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
					vents=[true,true,true,true],
					vent_size=vent_size,
					vent_period=vent_period,
					vent_angle=vent_angle,
					center_xy=true);
				//psu plug stand
				translate([-size_x/2+plug_shift,0,base_sz])
					stand(height=height-base_sz+plug_height_corr,
						inner_diam=3,
						top_diam=5,
						bottom_diam=stand_base_diam,
						attach=attach_clearance,
						quality=2,center_xy=true);
				//psu stands
				translate([psu_mvx+psu_size[0]/2-psu_screw_dx1,(size_y-psu_stand_sz)/2-wall_sz,base_sz])
					cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz],
						rounding=psu_stand_sz/2, quality=quality,
						round_corners=[false,true,true,false],attach=attach_clearance,center_xy=true);
				translate([psu_mvx+psu_size[0]/2-psu_screw_dx2,(size_y-psu_stand_sz)/2-wall_sz,base_sz])
					cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz],
						rounding=psu_stand_sz/2, quality=quality,
						round_corners=[false,true,true,false],attach=attach_clearance,center_xy=true);
				translate([psu_mvx+psu_size[0]/2-psu_screw_dx1,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
				{
					cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz],
						rounding=psu_stand_sz/2, quality=quality,
						round_corners=[true,false,false,true],attach=attach_clearance,center_xy=true);
					translate([0,-wall_sz/2,psu_screw_dy])
						rotate(a=90,v=[1,0,0])
							cylinder(d=psu_screw_ext_diam,
								h=psu_stand_sz+wall_sz,
								center=true,$fn=12*quality);
				}
				translate([psu_mvx+psu_size[0]/2-psu_screw_dx2,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
				{
					cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz],
						rounding=psu_stand_sz/2, quality=quality,
						round_corners=[true,false,false,true],attach=attach_clearance,center_xy=true);
					translate([0,-wall_sz/2,psu_screw_dy])
						rotate(a=90,v=[1,0,0])
							cylinder(d=psu_screw_ext_diam,
								h=psu_stand_sz+wall_sz,
								center=true,$fn=12*quality);
				}
			}
			translate([psu_mvx+psu_size[0]/2-psu_screw_dx1,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
				translate([0,-wall_sz/2,psu_screw_dy])
					rotate(a=90,v=[1,0,0])
						cylinder(d=psu_screw_diam,
							h=psu_stand_sz+wall_sz+2*attach_clearance,
							center=true,$fn=12*quality);
			translate([psu_mvx+psu_size[0]/2-psu_screw_dx2,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
				translate([0,-wall_sz/2,psu_screw_dy])
					rotate(a=90,v=[1,0,0])
						cylinder(d=psu_screw_diam,
							h=psu_stand_sz+wall_sz+2*attach_clearance,
							center=true,$fn=12*quality);
			//cut for wires
			translate([-size_x/2+psu_mvx+wall_sz,-(size_y/2-2*wall_sz-stand_base_diam/2-2*wall_sz-screw_diam)])
				cube_vround(size=[psu_mvx*2,size_y/2-(2*wall_sz+screw_diam)-stand_base_diam/2,base_sz+attach_clearance],
					rounding=psu_stand_sz/2, quality=quality,
					round_corners=[true,true,true,true],attach=attach_clearance,center_xy=true);
		}
		//draw psu box
		if($preview)
			color([0.75,0.75,0.75])
			translate([psu_mvx,0,psu_size[2]/2+base_sz])
				cube(size=psu_size,center=true);
	}
}

psu_rs15_section(center_xy=true,center_z=true);
