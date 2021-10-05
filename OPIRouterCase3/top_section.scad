use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand.scad>
use <../OPIRouterCase1/opi_zero.scad>

module top_section
(
	size=[110,175],
	eth_adapter_size=[15,23.5,80],
	eth_adapter_dy=10,
	eth_clip_sz=[5,5,55,20,10],
	eth_clip_clr=[0.25,0.4],
	psu_clearance=42,
	psu_block_sz=[10,10],
	psu_block_shift=3,
	opi_shift_x=-25,
	opi_shift_y=25,
	opi_stands=[5,10,6],
	opi_sdcut=[5,14,15,2,5,2.6],
	opi_sdcut_shift_x=-13.5,
	antennas_cuts=[100,6],
	antennas_shift=[28,25],
	cord_cut=[6,5,-103],
	psu_vent_sz=[8,1.2,0.4,0.4],
	psu_vents_pos=[9,22,-40,-85],
	wall_sz=1.6,
	base_sz=2,
	inner_base_sz=2,
	inner_base_clr=0.25,
	ext_lock_sz=[2,0.25,1],
	psu_stand_sz=4,
	screw_diam=3,
	screw_clearance=0.25,
	quality=2,
)
{
	cutClr=0.1;
	opi_board_width=opi_board_width();
	ostand_mvx=opi_szx()/2-3;
	ostand_mvy=opi_szy()/2-3;

	difference()
	{
		union()
		{
			//case base
			translate([0,0,-base_sz])
				case_section(size=[size[0],size[1],base_sz],
					screw_diam=screw_diam,
					screw_clearance=screw_clearance,
					wall_sz=wall_sz,
					base_sz=base_sz,
					attach=0,
					quality=quality,
					vents=[false,false,false,false],
					center_xy=true);
			//inner base
			translate([0,(psu_clearance-wall_sz)/2,0])
				cube_vround([size[0]-2*(2*wall_sz+screw_diam),size[1]-psu_clearance-wall_sz,inner_base_sz],center_xy=true,attach=cutClr);
			translate([0,(psu_clearance-2*wall_sz-screw_diam)/2,0])
				cube_vround([size[0]-2*wall_sz-inner_base_clr*2, size[1]-(2*wall_sz+screw_diam)-psu_clearance, inner_base_sz],center_xy=true,attach=cutClr);
			//ext locks
			for(i=[0,1])
			rotate(a=i*180,v=[0,0,1])
			{
				translate([0,(size[1]+ext_lock_sz[0]+cutClr)/2-cutClr,-base_sz/2])
					cube([size[0]-2*(2*wall_sz+screw_diam),ext_lock_sz[0]+cutClr,base_sz],center=true);
				translate([0,(size[1]+ext_lock_sz[0]-ext_lock_sz[1])/2+ext_lock_sz[1],(inner_base_sz+base_sz)/2-base_sz])
					cube([size[0]-2*(2*wall_sz+screw_diam),ext_lock_sz[0]-ext_lock_sz[1],inner_base_sz+base_sz],center=true);
			}
			//psu air-block
			translate([0,-size[1]/2+psu_clearance+psu_block_shift,inner_base_sz])
			rotate([90,0,90])
			linear_extrude(size[0]-2*wall_sz-inner_base_clr*2,center=true)
			polygon([
				[0,-cutClr],
				[0,0],
				[0,psu_block_sz[1]],
				[psu_block_sz[0],0],
				[psu_block_sz[0],-cutClr],
			]);
			//eth_adapter_clip
			difference()
			{
				translate([size[0]/2-(eth_adapter_size[0]+eth_clip_sz[0])/2-wall_sz-inner_base_clr,size[1]/2-eth_clip_sz[2]/2-wall_sz-eth_clip_sz[4],inner_base_sz])
				{
					translate([0,-(eth_clip_sz[2]-eth_clip_sz[3])/4-eth_clip_sz[3]/2,0])
					cube_vround([eth_adapter_size[0]+eth_clip_sz[0],(eth_clip_sz[2]-eth_clip_sz[3])/2,eth_adapter_size[1]+eth_clip_sz[1]+eth_adapter_dy-inner_base_sz],attach=cutClr,center_xy=true);
					translate([0,(eth_clip_sz[2]-eth_clip_sz[3])/4+eth_clip_sz[3]/2,0])
					cube_vround([eth_adapter_size[0]+eth_clip_sz[0],(eth_clip_sz[2]-eth_clip_sz[3])/2,eth_adapter_size[1]+eth_clip_sz[1]+eth_adapter_dy-inner_base_sz],attach=cutClr,center_xy=true);
				}
				translate([size[0]/2-(eth_adapter_size[0]+2*eth_clip_clr[0])/2-wall_sz ,size[1]/2-eth_adapter_size[2]/2-wall_sz,(eth_adapter_size[1]+eth_clip_clr[1])/2+inner_base_sz+eth_adapter_dy-inner_base_sz])
				cube([eth_adapter_size[0]+2*eth_clip_clr[0], eth_adapter_size[2]+2*cutClr, eth_adapter_size[1]+eth_clip_clr[1]],center=true);
			}
			//orange pi stands
			translate([opi_shift_x,opi_shift_y,inner_base_sz])
			rotate(a=-90,v=[0,0,1])
			for(i=[true,false],j=[true,false])
				translate([(i?1:-1.025)*ostand_mvx,(j?1:-1)*ostand_mvy,0])
				stand(height=opi_stands[0], inner_diam=screw_diam, bottom_diam=opi_stands[1],
				top_diam=opi_stands[2], attach=cutClr, quality=quality, center_xy=true);
			//orange pi sd cut
			translate([opi_shift_x+opi_sdcut_shift_x,opi_shift_y+opi_szy()/2+1.25,inner_base_sz-cutClr])
			cube([opi_sdcut[1]+2*opi_sdcut[3],opi_sdcut[2],opi_sdcut[0]+opi_sdcut[3]+cutClr]);
			//orange pi sd cut 2
			translate([opi_shift_x+opi_sdcut_shift_x+opi_sdcut[1]/2+opi_sdcut[3],opi_shift_y+opi_szy()/2+1.25+opi_sdcut[2],inner_base_sz])
			rotate([90,0,90])
			linear_extrude(opi_sdcut[1]+opi_sdcut[3]*2,center=true)
			polygon([
				[-cutClr,-inner_base_sz-base_sz-cutClr],
				[-cutClr,0],
				[-cutClr,opi_sdcut[0]+opi_sdcut[3]],
				[0,opi_sdcut[0]+opi_sdcut[3]],
				[opi_sdcut[0]+opi_sdcut[3],0],
				[opi_sdcut[0]+opi_sdcut[3],-inner_base_sz-base_sz-cutClr],
			]);
			//orange pi sd cut 3
			translate([opi_shift_x+opi_sdcut_shift_x,opi_shift_y+opi_szy()/2+1.25-opi_sdcut[4],inner_base_sz-cutClr])
			cube([opi_sdcut[1]+2*opi_sdcut[3],opi_sdcut[4]+cutClr,opi_sdcut[5]+cutClr]);
		}
		//orange pi sd cut
		translate([opi_shift_x+opi_sdcut_shift_x,opi_shift_y+opi_szy()/2+1.25,inner_base_sz-cutClr])
			translate([opi_sdcut[3],-cutClr,-inner_base_sz-base_sz-cutClr])
				cube([opi_sdcut[1],opi_sdcut[2]+2*cutClr,opi_sdcut[0]+inner_base_sz+base_sz+cutClr]);
		//orange pi sd cut 2
		translate([opi_shift_x+opi_sdcut_shift_x+opi_sdcut[1]/2+opi_sdcut[3],opi_shift_y+opi_szy()/2+1.25+opi_sdcut[2],inner_base_sz])
		rotate([90,0,90])
		linear_extrude(opi_sdcut[1],center=true)
		polygon([
			[-2*cutClr,-inner_base_sz-base_sz-2*cutClr],
			[-2*cutClr,0],
			[-2*cutClr,opi_sdcut[0]],
			[0,opi_sdcut[0]],
			[opi_sdcut[0],0],
			[opi_sdcut[0],-inner_base_sz-base_sz-2*cutClr],
		]);
		//router antennas cut
		translate([antennas_shift[0],antennas_shift[1],0])
		for(i=[-1,1])
			translate([0,i*antennas_cuts[0]/2,-inner_base_sz-cutClr])
				cylinder(d=antennas_cuts[1],h=base_sz+inner_base_sz+2*cutClr,$fn=quality*12);
		//power cord cut
		translate([-size[0]/2+cord_cut[0]/2+wall_sz+inner_base_clr+cord_cut[1], cord_cut[2]/2,-inner_base_sz-cutClr])
			cylinder(d=cord_cut[0],h=base_sz+inner_base_sz+2*cutClr,$fn=quality*12);
		translate([-size[0]/2-cord_cut[0]/2+wall_sz+inner_base_clr, cord_cut[2]/2-cord_cut[0]/2,-inner_base_sz-cutClr])
			cube([cord_cut[0]+cord_cut[1],cord_cut[0],base_sz+inner_base_sz+2*cutClr]);
		//psu vent cuts
		for(x=[0:psu_vents_pos[0]],y=[0:psu_vents_pos[1]])
		{
			translate([psu_vents_pos[2]+x*(psu_vent_sz[0]+psu_vent_sz[2]),psu_vents_pos[3]+y*(psu_vent_sz[1]+psu_vent_sz[3]),-base_sz-cutClr])
			cube([psu_vent_sz[0],psu_vent_sz[1],base_sz+inner_base_sz+2*cutClr]);
		}
	}
	//draw orange pi zero
	if($preview)
		translate([opi_shift_x,opi_shift_y,inner_base_sz+opi_stands[0]])
			rotate(a=-90,v=[0,0,1])
				orange_pi_zero(center_xy=true);
}

top_section();
