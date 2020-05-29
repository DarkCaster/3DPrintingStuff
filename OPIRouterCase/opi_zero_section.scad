use <opi_zero.scad>
use <../OpenSCAD_Modules/stand.scad>
use <../OpenSCAD_Modules/case_section.scad>

function opi_zero_section_height() = 24;

module opi_zero_section(
size=[100,62],
screw_diam=3,
screw_clearance=0.2,
stand_wall_sz=1.2,
stand_height=3,
wall_sz=2,
base_sz=2,
center_xy=false,
center_z=false,
attach=0,
opi_clearance=1,
quality=2,
vent_size=[5,2],
vent_period=[10,3],
vent_angle=70,
)
{
	attach_clearance=0.05;
	opi_height=15;
	opi_szx=48;
	opi_szy=46;
	opi_board_width=1.5;
	assert(len(size)==2);
	size_x=size[0];
	size_y=size[1];
	height=opi_zero_section_height();
	assert(opi_height>0);
	assert(opi_szx>=48);
	assert(opi_szy>=46);
	assert(opi_clearance>0);
	assert(stand_height>0);
	assert(stand_wall_sz>0.399);
	assert(screw_diam+stand_wall_sz*2<8);
	assert(screw_diam>1);
	assert(screw_diam<4);
	assert(attach>=0);
	assert(height>base_sz+stand_height+opi_height);
	min_szx=opi_szx+2*(2*wall_sz+opi_clearance+screw_diam);
	min_szy=opi_szy+2*(2*wall_sz+opi_clearance+screw_diam);
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);
	cstand_width=2*wall_sz+screw_diam;
	cstand_mvx=(size_x-cstand_width)/2;
	cstand_mvy=(size_y-cstand_width)/2;
	opi_move_x=size_x/2-wall_sz-opi_clearance-opi_szx/2;
	opi_move_z=base_sz+stand_height;
	ostand_mvx=opi_szx/2-3;
	ostand_mvy=opi_szy/2-3;
	//front case cut
	front_cut_height=15;
	front_cut_width=26;
	front_cut_shift=4.25;
	//antenna cut diam
	antenna_cut_diam1=5;
	antenna_cut_diam2=5.5;
	antenna_cut_vshift=1;
	antenna_cut_rise=wall_sz;
	//sd cut
	sdcut_width=12;
	sdcut_height=5;
	sdcut_shift_y=-8;
	sdcut_shift_x=-1.5;
	sdcut_shield_height=stand_height-2.2;
	assert(sdcut_shield_height>0);
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
					vents=[true,false,true,false],
					vent_size=vent_size,
					vent_period=vent_period,
					vent_angle=vent_angle,
					center_xy=true);
				//orange pi stands
				for(i=[true,false],j=[true,false])
					translate([opi_move_x+(i?1:-1)*ostand_mvx,(j?1:-1)*ostand_mvy,base_sz])
						stand(height=stand_height,
							inner_diam=screw_diam,
							top_diam=screw_diam+2*stand_wall_sz,bottom_diam=screw_diam+3*stand_wall_sz,
									attach=attach_clearance,quality=quality,center_xy=true);
				//antenna hole
				translate([-size_x/2+wall_sz/2,ostand_mvy,base_sz+stand_height+opi_board_width+antenna_cut_vshift])
					rotate(a=90,v=[0,1,0])
						cylinder(d1=antenna_cut_diam1+antenna_cut_rise,
							d2=antenna_cut_diam2+antenna_cut_rise,
							h=wall_sz+antenna_cut_rise,
							$fn=12*quality,center=true);
				//sdcard hole
				translate([(-size_x/2+sdcut_shift_x)/2,sdcut_shift_y,(sdcut_height+base_sz)/2])
					cube(size=[size_x/2+sdcut_shift_x,sdcut_width+2*wall_sz,sdcut_height+base_sz],center=true);
				translate([sdcut_shift_x+wall_sz/2,sdcut_shift_y,(sdcut_shield_height/2)+base_sz])
					cube(size=[wall_sz,sdcut_width+2*wall_sz,sdcut_shield_height+attach_clearance],center=true);
			}
			translate([(size_x-wall_sz)/2,front_cut_shift,front_cut_height/2+base_sz+opi_board_width-opi_clearance+stand_height])
				cube(size=[wall_sz+0.2,front_cut_width,front_cut_height],
					center=true);
			//antenna hole
			translate([-size_x/2+wall_sz/2,ostand_mvy,base_sz+stand_height+opi_board_width+antenna_cut_vshift])
				rotate(a=90,v=[0,1,0])
					cylinder(d1=antenna_cut_diam1,
						d2=antenna_cut_diam2,
						h=wall_sz+antenna_cut_rise+2*attach_clearance,
						$fn=12*quality,center=true);
			//sdcard hole
			translate([(-size_x/2+sdcut_shift_x)/2,sdcut_shift_y,(sdcut_height-attach_clearance)/2])
				cube(size=[size_x/2+sdcut_shift_x+2*attach_clearance,sdcut_width,sdcut_height+attach_clearance],
					center=true);
		}
		//draw orange pi zero
		if($preview)
			translate([opi_move_x,0,opi_move_z])
				orange_pi_zero(center_xy=true);
	}
}

opi_zero_section(center_xy=true,center_z=true);
