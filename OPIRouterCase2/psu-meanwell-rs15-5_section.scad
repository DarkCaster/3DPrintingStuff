use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand.scad>
use <../OpenSCAD_Modules/boards.scad>

rs15_5_psu_size=[76,51.5,28.5];

function psu_rs15_5_section_height(base_sz=2,psu_clearance=1) = base_sz+rs15_5_psu_size[2]+psu_clearance/2;

module psu_rs15_section(
size=[98,66],
base_len=112,
screw_diam=3,
screw_clearance=0.2,
wall_sz=1.6,
base_sz=2,
center_xy=false,
center_z=false,
attach=0,
quality=2,
vent_size=[10,2],
vent_period=[20,4],
vent_angle=45,
psu_clearance=1,
cable_diam=6.75,
clip_z=10,
clip_int_sz=3,
clip_ext_sz=10,
clip_width=3,
psu_wires_dy=10,
)
{
	attach_clearance=0.05;
	psu_clr_mode=rs15_5_psu_size[0]>rs15_5_psu_size[1];
	psu_screw_dy=15;
	psu_screw_diam=3;
	psu_screw_ext_diam=5;
	psu_screw_dx1=11.5;
	psu_screw_dx2=51;
	psu_cable_ext_diam=cable_diam+2;
	assert(len(size)==2);
	size_x=size[0];
	size_y=size[1];
	height=psu_rs15_5_section_height(base_sz=base_sz,psu_clearance=psu_clearance);
	psu_wires_height=height-base_sz-psu_wires_dy;
	assert(screw_diam>1);
	assert(screw_diam<=6);
	assert(attach>=0);
	max_subsz=rs15_5_psu_size[1];
	max_wallsz=wall_sz;
	min_szx=max_wallsz+wall_sz+2*(psu_clr_mode?psu_clearance:screw_diam+wall_sz)+rs15_5_psu_size[0];
	min_szy=2*(wall_sz+(psu_clr_mode?screw_diam+wall_sz:psu_clearance))+max_subsz;
	psu_stand_sz=psu_clr_mode?(size_y-rs15_5_psu_size[1]-2*wall_sz)/2:psu_clearance;
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);
	psu_mvx=size_x/2-rs15_5_psu_size[0]/2-(psu_clr_mode?psu_clearance:screw_diam+wall_sz)-wall_sz;
	psu_cable_mvx=(size_x-rs15_5_psu_size[0])/2+4;
	screw_hole_shift=[wall_sz+screw_diam/2,wall_sz+screw_diam/2];
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
					vents=[true,true,true,false],
					vent_size=vent_size,
					vent_period=vent_period,
					vent_angle=vent_angle,
					center_xy=true);
				//base section
				translate([-size_x/2,-size_y/2,0])
					board(size_x=size_x,size_y=base_len,width=base_sz,hole_diam=screw_diam,rounding=screw_diam,
						hole1=screw_hole_shift,hole2=screw_hole_shift,hole3=screw_hole_shift,hole4=screw_hole_shift,
						quality=quality,center_xy=false);
				//psu stands
				translate([psu_mvx+rs15_5_psu_size[0]/2-psu_screw_dx1,(size_y-psu_stand_sz)/2-wall_sz,base_sz])
					cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz],
						rounding=psu_stand_sz/2, quality=quality,
						round_corners=[false,true,true,false],attach=attach_clearance,center_xy=true);
				translate([psu_mvx+rs15_5_psu_size[0]/2-psu_screw_dx2,(size_y-psu_stand_sz)/2-wall_sz,base_sz])
					cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz],
						rounding=psu_stand_sz/2, quality=quality,
						round_corners=[false,true,true,false],attach=attach_clearance,center_xy=true);
				translate([psu_mvx+rs15_5_psu_size[0]/2-psu_screw_dx1,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
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
				translate([psu_mvx+rs15_5_psu_size[0]/2-psu_screw_dx2,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
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
				translate([-size_x/2,0,clip_z])
					rotate(a=-90,v=[0,1,0]) rotate(a=90,v=[1,0,0])
						linear_extrude(height=size_y-wall_sz*2-screw_diam, center = true)
							polygon(points = [[-clip_int_sz/2,-attach_clearance],[-clip_ext_sz/2,clip_width],[clip_ext_sz/2,clip_width],[clip_int_sz/2,-attach_clearance]]);
				translate([-(size_x-wall_sz)/2,-size_y/2+psu_cable_mvx+wall_sz,psu_wires_height+base_sz])
					rotate(a=90,v=[0,1,0])
						cylinder(d=psu_cable_ext_diam,h=wall_sz,center=true,$fn=12*quality);
			}
			translate([psu_mvx+rs15_5_psu_size[0]/2-psu_screw_dx1,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
				translate([0,-wall_sz/2,psu_screw_dy])
					rotate(a=90,v=[1,0,0])
						cylinder(d=psu_screw_diam,
							h=psu_stand_sz+wall_sz+2*attach_clearance,
							center=true,$fn=12*quality);
			translate([psu_mvx+rs15_5_psu_size[0]/2-psu_screw_dx2,-(size_y-psu_stand_sz)/2+wall_sz,base_sz])
				translate([0,-wall_sz/2,psu_screw_dy])
					rotate(a=90,v=[1,0,0])
						cylinder(d=psu_screw_diam,
							h=psu_stand_sz+wall_sz+2*attach_clearance,
							center=true,$fn=12*quality);
			translate([-(size_x-wall_sz)/2,-size_y/2+psu_cable_mvx+wall_sz,psu_wires_height+base_sz])
				rotate(a=90,v=[0,1,0])
					cylinder(d=cable_diam,h=wall_sz+attach_clearance,center=true,$fn=12*quality);
			//cut for wires
			translate([-size_x/2+psu_mvx+wall_sz+1,0])
				cube_vround(size=[psu_mvx*2,size_y-wall_sz*4-screw_diam*2,base_sz+attach_clearance],
					quality=quality,round_corners=[true,true,true,true],rounding=psu_stand_sz/2,attach=attach_clearance,center_xy=true);
		}
		//draw psu box
		if($preview)
			color([0.75,0.75,0.75])
			translate([psu_mvx,0,rs15_5_psu_size[2]/2+base_sz])
				cube(size=rs15_5_psu_size,center=true);
	}
}


module psu_rs15_cover(
size=[98,66],
screw_diam=3,
wall_sz=1.6,
base_sz=2,
center_xy=false,
center_z=false,
attach=0,
quality=2,
psu_clearance=1,
)
{
	attach_clearance=0.05;
	psu_clr_mode=rs15_5_psu_size[0]>rs15_5_psu_size[1];
	assert(len(size)==2);
	size_x=size[0];
	size_y=size[1];
	height=psu_rs15_5_section_height(base_sz=base_sz,psu_clearance=psu_clearance);
	assert(screw_diam>1);
	assert(screw_diam<=6);
	assert(attach>=0);
	max_subsz=rs15_5_psu_size[1];
	max_wallsz=wall_sz;
	min_szx=max_wallsz+wall_sz+2*(psu_clr_mode?psu_clearance:screw_diam+wall_sz)+rs15_5_psu_size[0];
	min_szy=2*(wall_sz+(psu_clr_mode?screw_diam+wall_sz:psu_clearance))+max_subsz;
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);
	screw_hole_shift=[wall_sz+screw_diam/2,wall_sz+screw_diam/2];
	translate([center_xy?0:size_x/2,center_xy?0:size_y/2,center_z?-height/2:0])
	{
		translate([-size_x/2,-size_y/2,0])
			board(size_x=size_x,size_y=size_y,width=base_sz,hole_diam=screw_diam,rounding=screw_diam,
				hole1=screw_hole_shift,hole2=screw_hole_shift,hole3=screw_hole_shift,hole4=screw_hole_shift,
				quality=quality,center_xy=false);
	}
}

//psu_rs15_cover(center_xy=true,center_z=true);
psu_rs15_section(center_xy=true,center_z=true);
