use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand.scad>
use <../OPIRouterCase1/opi_zero.scad>

opi_payload_size=[99,143,28.5];

function opi_payload_height(base_sz=2,payload_clearance=1) = base_sz+opi_payload_size[2]+payload_clearance/2;

dub_size=[27.4,72,17];

module opi_section(
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
vent_period=[20,4],
vent_angle=45,
payload_clearance=1,
stand_wall_sz=1.2,
stand_height=2.5,
cable_diam=6.75,
clip_z=10,
clip_int_sz=3,
clip_ext_sz=10,
clip_width=3,
clip_clearance=0.4,
clip_cover_width=3+1.6,
clip_cover_sz=14,
opi_shift_x=25,
opi_shift_y=0,
dub_shift_x=-29,
psu_wires_dy=10,
)
{
	attach_clearance=0.05;
	psu_clr_mode=opi_payload_size[0]>opi_payload_size[1];
	psu_cable_ext_diam=cable_diam+2;
	assert(len(size)==2);
	size_x=size[0];
	size_y=size[1];
	height=opi_payload_height(base_sz=base_sz,payload_clearance=payload_clearance);
	assert(screw_diam>1);
	assert(screw_diam<=6);
	assert(attach>=0);
	max_subsz=opi_payload_size[1];
	max_wallsz=wall_sz;
	min_szx=max_wallsz+wall_sz+2*(psu_clr_mode?payload_clearance:screw_diam+wall_sz)+opi_payload_size[0];
	min_szy=2*(wall_sz+(psu_clr_mode?screw_diam+wall_sz:payload_clearance))+max_subsz;
	psu_stand_sz=psu_clr_mode?(size_y-opi_payload_size[1]-2*wall_sz)/2:payload_clearance;
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);
	psu_mvx=size_x/2-opi_payload_size[0]/2-(psu_clr_mode?payload_clearance:screw_diam+wall_sz)-wall_sz;
	psu_cable_mvx=10;
	psu_wires_height=psu_wires_dy;

	opi_szx=opi_szx();
	opi_szy=opi_szy();
	opi_board_width=opi_board_width();
	opi_move_z=base_sz+stand_height;
	ostand_mvx=opi_szx/2-3;
	ostand_mvy=opi_szy/2-3;

	//sd cut
	sdcut_width=12;
	sdcut_height=stand_height+base_sz;
	sdcut_length=size_y/2-opi_szx/2-payload_clearance+opi_shift_y; //using opi_szx because orange pi board is rotated 90 deg
	sdcut_shield_length=sdcut_length+1.5;
	sdcut_shift_x=-4.75;
	sdcut_shield_height=stand_height-2.2;
	assert(sdcut_shield_height>0);

	dub_holder_wall_sz=8;
	dub_rounding=4;
	dub_clip_size=[6,8.5,7];
	dub_clip_shift=7.5;
	dub_clip2_size=[2,6];
	dub_plug_size=[24,16];
	dub_holder_size=[dub_size[0]+2*dub_holder_wall_sz,dub_size[1]+dub_holder_wall_sz,dub_size[2]];
	dub_holder_move=[dub_shift_x,(-size_y+dub_holder_size[1])/2,base_sz];
	dub_holder_cut1_size=[dub_size[0],dub_size[1]+attach_clearance,dub_size[2]];
	dub_holder_cut1_move=[dub_shift_x,-(size_y-dub_size[1]+attach_clearance)/2,base_sz+attach_clearance];
	dub_holder_cut2_size=[2*(dub_holder_wall_sz+attach_clearance)+dub_size[0],dub_size[1]-dub_rounding*2,dub_size[2]];
	dub_holder_cut2_move=[dub_shift_x,-(size_y-dub_size[1])/2,base_sz+attach_clearance];
	dub_holder_cut3_size=[dub_size[0]-dub_rounding*2,2*(dub_holder_wall_sz+attach_clearance)+dub_size[1],dub_size[2]];
	dub_holder_cut3_move=[dub_shift_x,-(size_y-dub_size[1]+attach_clearance)/2,base_sz+attach_clearance];

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
				//side clip
				translate([0,-size_y/2,height-clip_z])
					rotate(a=90,v=[0,1,0])
						linear_extrude(height=size_x-wall_sz*4-screw_diam, center = true)
							polygon(points = [[-clip_cover_sz/2,0],[-clip_cover_sz/2,clip_cover_width],[clip_cover_sz/2,clip_cover_width],[clip_cover_sz/2,0]]);
				//orange pi stands
				translate([opi_shift_x,opi_shift_y,0])
					rotate(a=90,v=[0,0,1])
					for(i=[true,false],j=[true,false])
						translate([(i?1:-1.025)*ostand_mvx,(j?1:-1)*ostand_mvy,base_sz])
							stand(height=stand_height,inner_diam=3,
								top_diam=screw_diam+2*stand_wall_sz,bottom_diam=screw_diam+3*stand_wall_sz,
								attach=attach_clearance,quality=quality,center_xy=true);
				//sdcard cut
				translate([opi_shift_x-sdcut_shift_x,(-size_y+sdcut_length)/2,(sdcut_height+base_sz)/2])
					cube(size=[sdcut_width+2*wall_sz,sdcut_length,sdcut_height+base_sz],center=true);
				translate([opi_shift_x-sdcut_shift_x,(-size_y+sdcut_shield_length)/2,(sdcut_shield_height/2)+base_sz])
					cube(size=[sdcut_width+2*wall_sz,sdcut_shield_length,sdcut_shield_height+attach_clearance],center=true);
				//dub e100/e1 holder
				translate(dub_holder_move)
					cube_vround(size=dub_holder_size,rounding=dub_rounding+dub_holder_wall_sz,round_corners=[true,false,false,true],
						attach=attach_clearance,center_xy=true);
			}
			translate([size_x/2-psu_cable_mvx-wall_sz,-(size_y-wall_sz)/2,psu_wires_height])
				rotate(a=90,v=[1,0,0])
					cylinder(d=cable_diam,h=wall_sz+attach_clearance,center=true,$fn=12*quality);
			translate([0,-size_y/2,height-clip_z])
				rotate(a=90,v=[0,1,0])
					linear_extrude(height=size_x*2, center = true)
						polygon(points = [[-clip_int_sz/2-clip_clearance,-attach_clearance],[-clip_ext_sz/2-clip_clearance,clip_width+clip_clearance],[clip_ext_sz/2+clip_clearance,clip_width+clip_clearance],[clip_int_sz/2+clip_clearance,-attach_clearance]]);
			//sdcard cut
			translate([opi_shift_x-sdcut_shift_x,(-size_y+sdcut_length)/2,sdcut_height/2])
				cube(size=[sdcut_width,sdcut_length+2*attach_clearance,sdcut_height+attach_clearance],center=true);
			//cuts for dub e100/e1 usb network adapter
			translate(dub_holder_cut1_move)
				cube_vround(size=dub_holder_cut1_size,rounding=dub_rounding,round_corners=[true,true,true,true],
					attach=attach_clearance,center_xy=true);
			translate(dub_holder_cut2_move)
				cube_vround(size=dub_holder_cut2_size,rounding=dub_rounding,round_corners=[false,false,false,false],
					attach=attach_clearance,center_xy=true);
			translate(dub_holder_cut3_move)
				cube_vround(size=dub_holder_cut3_size,rounding=dub_rounding,round_corners=[false,false,false,false],
					attach=attach_clearance,center_xy=true);
			translate([dub_holder_move[0]-(dub_holder_cut1_size[0]/2+dub_clip2_size[0]/2),dub_holder_move[1],-attach_clearance])
					cube_vround(size=[dub_clip2_size[0],dub_clip2_size[1],base_sz+2*attach_clearance],
							rounding=min(dub_clip2_size[0],dub_clip2_size[1])/2,round_corners=[true,true,true,true],
							center_xy=true);
			translate([dub_holder_move[0]+(dub_holder_cut1_size[0]/2+dub_clip2_size[0]/2),dub_holder_move[1],-attach_clearance])
					cube_vround(size=[dub_clip2_size[0],dub_clip2_size[1],base_sz+2*attach_clearance],
							rounding=min(dub_clip2_size[0],dub_clip2_size[1])/2,round_corners=[true,true,true,true],
							center_xy=true);
		}
		//draw payload box for reference
		/*if($preview)
			color([0.75,0.75,0.75,0.33])
			translate([psu_mvx,0,opi_payload_size[2]/2+base_sz])
				cube(size=opi_payload_size,center=true);*/
		//draw orange pi zero
		if($preview)
			translate([opi_shift_x,opi_shift_y,0])
				rotate(a=90,v=[0,0,1])
					translate([0,0,opi_move_z])
						orange_pi_zero(center_xy=true);
	}
}

opi_section(center_xy=true,center_z=true);
