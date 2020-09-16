use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand.scad>

mainboard_size=[99,143,35.5];

function mainboard_height(base_sz=2,mainboard_clearance=1) = base_sz+mainboard_size[2]+mainboard_clearance/2;

module mainboard_section(
size=[112,160],
screw_diam=3,
screw_clearance=0.2,
wall_sz=1.6,
base_sz=2,
center_xy=false,
center_z=false,
attach=0,
quality=2,
vent_size=[10,2],
vent_period=[20,5],
vent_angle=45,
mainboard_clearance=1,
cable_diam=6.75,
antenna_diam=6.5,
antenna_z=25,
antenna_x=15,
clip_z=10,
clip_int_sz=3,
clip_ext_sz=10,
clip_width=3,
clip_clearance=0.2,
clip_cover_width=3+1.6,
clip_cover_sz=12,
)
{
	attach_clearance=0.05;
	psu_clr_mode=mainboard_size[0]>mainboard_size[1];
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
	height=mainboard_height(base_sz=base_sz,mainboard_clearance=mainboard_clearance);
	assert(screw_diam>1);
	assert(screw_diam<=6);
	assert(attach>=0);
	max_subsz=mainboard_size[1];
	max_wallsz=wall_sz;
	min_szx=max_wallsz+wall_sz+2*(psu_clr_mode?mainboard_clearance:screw_diam+wall_sz)+mainboard_size[0];
	min_szy=2*(wall_sz+(psu_clr_mode?screw_diam+wall_sz:mainboard_clearance))+max_subsz;
	psu_stand_sz=psu_clr_mode?(size_y-mainboard_size[1]-2*wall_sz)/2:mainboard_clearance;
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);
	psu_mvx=size_x/2-mainboard_size[0]/2-(psu_clr_mode?mainboard_clearance:screw_diam+wall_sz)-wall_sz;
	psu_cable_mvx=(size_x-mainboard_size[0])/2+4;
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
					vents=[true,false,false,true],
					vent_size=vent_size,
					vent_period=vent_period,
					vent_angle=vent_angle,
					center_xy=true);
				translate([0,-size_y/2,clip_z])
					rotate(a=90,v=[0,1,0])
						linear_extrude(height=size_x-wall_sz*4-screw_diam, center = true)
							polygon(points = [[-clip_cover_sz/2,0],[-clip_cover_sz/2,clip_cover_width],[clip_cover_sz/2,clip_cover_width],[clip_cover_sz/2,0]]);
			}
			translate([-size_x/2+psu_cable_mvx+wall_sz,-(size_y-wall_sz)/2,psu_screw_dy+base_sz])
				rotate(a=90,v=[1,0,0])
					cylinder(d=cable_diam,h=wall_sz+attach_clearance,center=true,$fn=12*quality);
			translate([0,-size_y/2,clip_z])
				rotate(a=90,v=[0,1,0])
					linear_extrude(height=size_x*2, center = true)
						polygon(points = [[-clip_int_sz/2-clip_clearance,-attach_clearance],[-clip_ext_sz/2-clip_clearance,clip_width],[clip_ext_sz/2+clip_clearance,clip_width],[clip_int_sz/2+clip_clearance,-attach_clearance]]);
			//antenna
			translate([size_x/2-wall_sz/2,-size_y/2+antenna_x,antenna_z+base_sz])
				rotate(a=90,v=[0,1,0])
					cylinder(d=antenna_diam,h=wall_sz+attach_clearance*2,center=true,$fn=12*quality);
			translate([size_x/2-wall_sz/2,size_y/2-antenna_x,antenna_z+base_sz])
				rotate(a=90,v=[0,1,0])
					cylinder(d=antenna_diam,h=wall_sz+attach_clearance*2,center=true,$fn=12*quality);
		}
		//draw psu box
		if(!$preview)
			color([0.75,0.75,0.75])
			translate([psu_mvx,0,mainboard_size[2]/2+base_sz])
				cube(size=mainboard_size,center=true);
	}
}

mainboard_section(center_xy=true,center_z=true);
