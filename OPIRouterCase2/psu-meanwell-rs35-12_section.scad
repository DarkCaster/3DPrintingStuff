use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand.scad>

rs35_12_psu_size=[99,81,35.5];

function psu_rs35_section_height(base_sz=2,psu_clearance=1) = base_sz+rs35_12_psu_size[2]+psu_clearance/2;

module psu_rs15_section(
size=[120,95],
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
cable_diam=6.75,
clip_z=10,
clip_int_sz=3,
clip_ext_sz=10,
clip_width=3,
)
{
	attach_clearance=0.05;
	psu_clr_mode=rs35_12_psu_size[0]>rs35_12_psu_size[1];
	psu_screw_dy=18;
	psu_screw_diam=3;
	psu_screw_ext_diam=5;
	psu_screw_dx1=6.5;
	psu_screw_dx2=80.5;
	psu_cable_ext_diam=cable_diam+2;
	psu_cable_pos_y=psu_screw_dy;
	assert(len(size)==2);
	size_x=size[0];
	size_y=size[1];
	height=psu_rs35_section_height(base_sz=base_sz,psu_clearance=psu_clearance);
	assert(screw_diam>1);
	assert(screw_diam<=6);
	assert(attach>=0);
	max_subsz=rs35_12_psu_size[1];
	max_wallsz=wall_sz;
	min_szx=max_wallsz+wall_sz+2*(psu_clr_mode?psu_clearance:screw_diam+wall_sz)+rs35_12_psu_size[0];
	min_szy=2*(wall_sz+(psu_clr_mode?screw_diam+wall_sz:psu_clearance))+max_subsz;
	psu_stand_sz=psu_clr_mode?(size_y-rs35_12_psu_size[1]-2*wall_sz)/2:psu_clearance;
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);
	psu_mvx=size_x/2-rs35_12_psu_size[0]/2-(psu_clr_mode?psu_clearance:screw_diam+wall_sz)-wall_sz;
	psu_cable_mvx=(size_x-rs35_12_psu_size[0])/2;
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
					vents=[false,true,true,true],
					vent_size=vent_size,
					vent_period=vent_period,
					vent_angle=vent_angle,
					center_xy=true);
				//psu stands
				translate([psu_mvx+rs35_12_psu_size[0]/2-psu_screw_dx1,(size_y-psu_stand_sz)/2-wall_sz,base_sz])
					cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz],
						rounding=psu_stand_sz/2, quality=quality,
						round_corners=[false,true,true,false],attach=attach_clearance,center_xy=true);
				translate([psu_mvx+rs35_12_psu_size[0]/2-psu_screw_dx2,(size_y-psu_stand_sz)/2-wall_sz,base_sz])
					cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz],
						rounding=psu_stand_sz/2, quality=quality,
						round_corners=[false,true,true,false],attach=attach_clearance,center_xy=true);
				translate([psu_mvx+rs35_12_psu_size[0]/2-psu_screw_dx1,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
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
				translate([psu_mvx+rs35_12_psu_size[0]/2-psu_screw_dx2,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
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
				translate([-size_x/2+psu_cable_mvx+wall_sz,-(size_y-wall_sz)/2,psu_screw_dy+base_sz])
					rotate(a=90,v=[1,0,0])
						cylinder(d=psu_cable_ext_diam,h=wall_sz,center=true,$fn=12*quality);
				translate([-size_x/2+psu_cable_mvx+wall_sz,(size_y-wall_sz)/2,psu_screw_dy+base_sz])
					rotate(a=90,v=[1,0,0])
						cylinder(d=psu_cable_ext_diam,h=wall_sz,center=true,$fn=12*quality);
				translate([0,size_y/2,clip_z])
					rotate(a=90,v=[0,1,0])
						linear_extrude(height=size_x-wall_sz*2-screw_diam, center = true)
							polygon(points = [[-clip_int_sz/2,-attach_clearance],[-clip_ext_sz/2,clip_width],[clip_ext_sz/2,clip_width],[clip_int_sz/2,-attach_clearance]]);
			}
			translate([psu_mvx+rs35_12_psu_size[0]/2-psu_screw_dx1,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
				translate([0,-wall_sz/2,psu_screw_dy])
					rotate(a=90,v=[1,0,0])
						cylinder(d=psu_screw_diam,
							h=psu_stand_sz+wall_sz+2*attach_clearance,
							center=true,$fn=12*quality);
			translate([psu_mvx+rs35_12_psu_size[0]/2-psu_screw_dx2,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
				translate([0,-wall_sz/2,psu_screw_dy])
					rotate(a=90,v=[1,0,0])
						cylinder(d=psu_screw_diam,
							h=psu_stand_sz+wall_sz+2*attach_clearance,
							center=true,$fn=12*quality);
			translate([-size_x/2+psu_cable_mvx+wall_sz,-(size_y-wall_sz)/2,psu_screw_dy+base_sz])
				rotate(a=90,v=[1,0,0])
					cylinder(d=cable_diam,h=wall_sz+attach_clearance,center=true,$fn=12*quality);
			translate([-size_x/2+psu_cable_mvx+wall_sz,(size_y-wall_sz)/2,psu_screw_dy+base_sz])
				rotate(a=90,v=[1,0,0])
					cylinder(d=cable_diam,h=wall_sz+attach_clearance,center=true,$fn=12*quality);
		}
		//draw psu box
		if($preview)
			color([0.75,0.75,0.75])
			translate([psu_mvx,0,rs35_12_psu_size[2]/2+base_sz])
				cube(size=rs35_12_psu_size,center=true);
	}
}

psu_rs15_section(center_xy=true,center_z=true);
