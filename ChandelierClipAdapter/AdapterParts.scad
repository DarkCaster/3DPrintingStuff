use <../OpenSCAD_Modules/cube_vround.scad>

module HNut
(
	nutDiam=6.75,
	nutHeight=3,
)
{
	cylinder(d=nutDiam,h=nutHeight,center=false,$fn=6);
}

module Plate
(
	ext_diameter=100,
	base_height=4,
	pwr_wires_cut_size=[20,5,30],
	metal_bar_size=[21,1.2],
	metal_bar_clips=[5,5,85],
	clip_wires_cut_diam=4,
	stiffener_rays_count=7,
	stiffener_rays_size=[3,3,90],
	screw_diam=3.5,
	screw_diff=26,
	quality=2,
	stub_layer_size=0.2,
)
{
	cutClr=1;
	union()
	{
		difference()
		{
			//base
			cylinder(h=base_height,d=ext_diameter,center=false,$fn=48*quality);
			//wires_cut
			hull()
			{
				translate([-pwr_wires_cut_size[0]/2,pwr_wires_cut_size[2],-cutClr])
				cylinder(h=base_height+2*cutClr,d=pwr_wires_cut_size[1],center=false,$fn=12*quality);
				translate([pwr_wires_cut_size[0]/2,pwr_wires_cut_size[2],-cutClr])
				cylinder(h=base_height+2*cutClr,d=pwr_wires_cut_size[1],center=false,$fn=12*quality);
			}
			translate([0,0,(metal_bar_size[1]+cutClr)/2+base_height-metal_bar_size[1]])
			{
				difference()
				{
					//metal bar top cut
					cube(size=[ext_diameter*2,metal_bar_size[0],metal_bar_size[1]+cutClr],center=true);
					//metal_bar_clips
					for(i=[-1,1])
					{
						hull()
						{
							translate([i*metal_bar_clips[2]/2,-metal_bar_clips[1]/2,0])
							cylinder(h=metal_bar_size[1]+2*cutClr,d=metal_bar_clips[0],center=true,$fn=12*quality);
							translate([i*metal_bar_clips[2]/2,metal_bar_clips[1]/2,0])
							cylinder(h=metal_bar_size[1]+2*cutClr,d=metal_bar_clips[0],center=true,$fn=12*quality);
						}
					}
				}
			}
			//metal bar clip wires
			for(i=[-1,1])
			{
				translate([i*(metal_bar_clips[2]/2-metal_bar_clips[0]/2+clip_wires_cut_diam/2),0,-cutClr])
				cylinder(h=base_height+2*cutClr,d=clip_wires_cut_diam,center=false,$fn=12*quality);
			}
			//stiffener rays
			for(i=[0:1:stiffener_rays_count-1])
			{
				rotate(a=i*(180/stiffener_rays_count),v=[0,0,1])
				rotate(a=90,v=[1,0,0])
				linear_extrude(h=stiffener_rays_size[2],center=true)
				polygon(points=[
					[0,-stiffener_rays_size[1]+base_height],
					[-stiffener_rays_size[0]/2,base_height],
					[-stiffener_rays_size[0]/2,cutClr+base_height],
					[stiffener_rays_size[0]/2,cutClr+base_height],
					[stiffener_rays_size[0]/2,base_height],
				]);
			}
			//screw holes
			for(i=[-1,1])
			{
				translate([0,i*(screw_diff/2),-cutClr])
				cylinder(h=base_height+2*cutClr,d=screw_diam,center=false,$fn=12*quality);
			}
		}

		//stub layer
		cylinder(h=stub_layer_size,d=ext_diameter,center=false,$fn=48*quality);
	}
}

module TopClip
(
	ext_diameter=40,
	base_height=4,
	screw_diam=3.5,
	screw_diff=26,
	quality=2,
	stub_layer_size=0.2,
)
{
	cutClr=1;
	union()
	{
		difference()
		{
			//base
			cylinder(h=base_height,d=ext_diameter,center=false,$fn=48*quality);
			//screw holes
			for(i=[-1,1])
			{
				translate([0,i*(screw_diff/2),-cutClr])
				cylinder(h=base_height+2*cutClr,d=screw_diam,center=false,$fn=12*quality);
			}
		}
		//stub layer
		cylinder(h=stub_layer_size,d=ext_diameter,center=false,$fn=48*quality);
	}
}

module BackPlate
(
	backplate_size=[85,34],
	center_cut_size=[18,2],
	rounding=2,
	base_height=5,
	screw_diam=3.5,
	screw_diff=26,
	nut_height=2,
	side_screw_diam=3,
	side_screw_pos=[80,3],
	quality=2,
	stub_layer_size=0.2,
)
{
	cutClr=1;
	union()
	{
		difference()
		{
			//base
			cube_vround(size=[backplate_size[0],backplate_size[1],base_height],rounding=rounding,center_xy=true);
			//screw holes
			for(i=[-1,1])
			{
				translate([0,i*(screw_diff/2),-cutClr])
				cylinder(h=base_height+2*cutClr,d=screw_diam,center=false,$fn=12*quality);
				
				translate([0,i*(screw_diff/2),base_height-nut_height])
				HNut(nutHeight=base_height);
			}
			//center cut
			translate([-backplate_size[0],-center_cut_size[0]/2,base_height-center_cut_size[1]])
			cube(size=[backplate_size[0]*2,center_cut_size[0],base_height]);
			//side cuts
			for(i=[-1,1])
			{
				translate([i*(side_screw_pos[0]/2-side_screw_diam/2),0,side_screw_pos[1]])
				rotate(a=90,v=[1,0,0])
				cylinder(h=backplate_size[1]+2*cutClr,d=side_screw_diam,center=true,$fn=12*quality);

				translate([i*(backplate_size[0]/2),0,-cutClr])
				cube_vround(size=[(backplate_size[0]-side_screw_pos[0]),center_cut_size[0],base_height+2*cutClr],rounding=rounding,center_xy=true);
			}
		}
		//stub layer
		cube_vround(size=[backplate_size[0],backplate_size[1],stub_layer_size],rounding=rounding,center_xy=true);
	}
}

if($preview)
{
	Plate(stub_layer_size=0);

	translate([0,0,4])
	color([0.75, 1, 0.75, 0.5])
	render()
	TopClip(stub_layer_size=0);

	rotate(a=180,v=[1,0,0])
	color([1, 0.75, 0.75, 0.5])
	render()
	BackPlate(stub_layer_size=0);
}

