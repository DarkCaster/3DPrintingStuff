use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand.scad>

module bottom_section
(
	size=[110,175],
	eth_adapter_size=[15,23.5,80],
	eth_adapter_dy=10,
	eth_clip_sz=[10,5,55,20,10],
	eth_clip_clr=[0.25,0.4],
	psu_clearance=40,
	psu_block_sz=[10,10],
	psu_block_shift=3,
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
					cube_vround([eth_adapter_size[0]+eth_clip_sz[0],(eth_clip_sz[2]-eth_clip_sz[3])/2,eth_adapter_size[1]+eth_clip_sz[1]],attach=cutClr,center_xy=true);
					translate([0,(eth_clip_sz[2]-eth_clip_sz[3])/4+eth_clip_sz[3]/2,0])
					cube_vround([eth_adapter_size[0]+eth_clip_sz[0],(eth_clip_sz[2]-eth_clip_sz[3])/2,eth_adapter_size[1]+eth_clip_sz[1]],attach=cutClr,center_xy=true);
				}
				translate([size[0]/2-(eth_adapter_size[0]+2*eth_clip_clr[0])/2-wall_sz ,size[1]/2-eth_adapter_size[2]/2-wall_sz,(eth_adapter_size[1]+eth_clip_clr[1])/2+inner_base_sz])
				cube([eth_adapter_size[0]+2*eth_clip_clr[0], eth_adapter_size[2]+2*cutClr, eth_adapter_size[1]+eth_clip_clr[1]],center=true);
			}
		}

			
			
			
			//orange pi stands
}

bottom_section();
