use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/cube_vround.scad>

dub_size=[72,27.4,16.4];

function dub_e100_section_height(base_sz=2) = base_sz+dub_size[2];

module dub_e100_section(
size=[110,64],
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
opi_clearance=1,
)
{
	attach_clearance=0.05;
	dub_clip_size=[6,8.5,7];
	dub_clip_shift=7.5;
	dub_clip2_size=[6,2];
	dub_holder_wall_sz=8;
	dub_plug_size=[16,16];
	dub_rounding=4;
	opi_szx=48;
	assert(len(size)==2);
	size_x=size[0];
	size_y=size[1];
	height=dub_e100_section_height(base_sz=base_sz);
	dub_holder_size=[dub_size[0]+dub_holder_wall_sz,dub_size[1]+2*dub_holder_wall_sz,dub_size[2]];
	dub_holder_rounding=dub_rounding+dub_holder_wall_sz;
	dub_holder_cut1_size=[dub_size[0]+attach_clearance,dub_size[1],dub_size[2]];
	dub_holder_cut1_move=[(size[0]-dub_size[0]+attach_clearance)/2,0,base_sz+attach_clearance];
	dub_holder_cut2_size=[dub_size[0]-dub_rounding*2,2*(dub_holder_wall_sz+attach_clearance)+dub_size[1],dub_size[2]];
	dub_holder_cut2_move=[(size[0]-dub_size[0])/2,0,base_sz+attach_clearance];
	dub_holder_cut3_size=[2*(dub_holder_wall_sz+attach_clearance)+dub_size[0],dub_size[1]-dub_rounding*2,dub_size[2]];
	dub_holder_cut3_move=[(size[0]-dub_size[0]+attach_clearance)/2,0,base_sz+attach_clearance];
	dub_plug_cut_move=[(size[0]-2*dub_size[0]-dub_plug_size[0]+attach_clearance)/2,0,-attach_clearance];
	gpio_cut_size=[opi_szx,(size[1]-2*wall_sz-dub_holder_cut2_size[1])/2];
	gpio_cut_move=[(size[0]-gpio_cut_size[0])/2-(2*wall_sz+screw_diam)-opi_clearance,-(size[1]-gpio_cut_size[1])/2+wall_sz,-attach_clearance];
	dub_holder_cut4_size=[dub_size[0]-dub_clip_shift-dub_clip_size[0]-dub_rounding,dub_size[1]-dub_rounding,base_sz+attach_clearance];
	dub_holder_cut4_move=[(size[0]-dub_holder_cut4_size[0])/2-dub_rounding,0,0];
	assert(screw_diam>1);
	assert(screw_diam<=6);
	assert(attach>=0);
	min_szx=wall_sz+dub_holder_wall_sz+dub_size[0]+(dub_plug_size[0]-dub_holder_wall_sz);
	min_szy=2*(2*wall_sz+screw_diam+dub_holder_wall_sz)+dub_size[1];
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);
	translate([center_xy?0:size_x/2,center_xy?0:size_y/2,center_z?-height/2:0])
	{
		union()
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
						vents=[true,false,true,true],
						vent_size=vent_size,
						vent_period=vent_period,
						vent_angle=vent_angle,
						center_xy=true);
					//draw dub e100/e1 holder
					translate([(size[0]-dub_holder_size[0])/2,0,base_sz])
						cube_vround(size=dub_holder_size,
							rounding=dub_rounding+dub_holder_wall_sz,
							round_corners=[false,false,true,true],
							attach=attach_clearance,center_xy=true);
				}
				//cuts for dub e100/e1 usb network adapter
				translate(dub_holder_cut1_move)
					cube_vround(size=dub_holder_cut1_size,
						rounding=dub_rounding,
						round_corners=[true,true,true,true],
						attach=attach_clearance,center_xy=true);
				translate(dub_holder_cut2_move)
					cube_vround(size=dub_holder_cut2_size,
						rounding=dub_rounding,
						round_corners=[false,false,false,false],
						attach=attach_clearance,center_xy=true);
				translate(dub_holder_cut3_move)
					cube_vround(size=dub_holder_cut3_size,
						rounding=dub_rounding,
						round_corners=[false,false,false,false],
						attach=attach_clearance,center_xy=true);
				//cut for USB plug
				translate(dub_plug_cut_move)
					cube_vround(size=[dub_plug_size[0],dub_plug_size[1],base_sz+2*attach_clearance],
						rounding=dub_rounding,
						round_corners=[true,true,true,true],
						center_xy=true);
				//cut for OPI gpio
				translate(gpio_cut_move)
					cube_vround(size=[gpio_cut_size[0],gpio_cut_size[1],base_sz+2*attach_clearance],
						rounding=min(gpio_cut_size[0],gpio_cut_size[1])/2,
						round_corners=[true,true,true,true],
						center_xy=true);
				//extra cuts
				translate([dub_holder_cut1_move[0]-dub_holder_cut1_size[0]/2+dub_clip_size[0]/2+dub_rounding,-dub_holder_cut1_size[1]/2-dub_holder_wall_sz/2,gpio_cut_move[2]])
					cube_vround(size=[dub_clip2_size[0],dub_clip2_size[1],base_sz+2*attach_clearance],
						rounding=min(dub_clip2_size[0],dub_clip2_size[1])/2,
						round_corners=[true,true,true,true],
						center_xy=true);
				translate([dub_holder_cut1_move[0]-dub_holder_cut1_size[0]/2+dub_clip_size[0]/2+dub_rounding,dub_holder_cut1_size[1]/2+dub_holder_wall_sz/2,gpio_cut_move[2]])
					cube_vround(size=[dub_clip2_size[0],dub_clip2_size[1],base_sz+2*attach_clearance],
						rounding=min(dub_clip2_size[0],dub_clip2_size[1])/2,
						round_corners=[true,true,true,true],
						center_xy=true);
				translate(dub_holder_cut4_move)
					cube_vround(size=dub_holder_cut4_size,
						rounding=min(dub_holder_cut4_size[0],dub_holder_cut4_size[1])/2,
						round_corners=[true,true,true,true],
						attach=attach_clearance,
						center_xy=true);
			}
			//extra clip
			translate([dub_holder_cut1_move[0]-dub_holder_cut1_size[0]/2+dub_clip_size[0]/2+dub_clip_shift,dub_holder_cut1_move[1],base_sz])
				cube_vround(size=dub_clip_size,
					rounding=min(dub_clip_size[0],dub_clip_size[1])/4,
					round_corners=[true,true,true,true],
					attach=attach_clearance,
					center_xy=true);
		}
	}
}

dub_e100_section(center_xy=true,center_z=false);
