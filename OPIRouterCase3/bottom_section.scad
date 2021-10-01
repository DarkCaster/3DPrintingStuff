use <../OpenSCAD_Modules/case_section.scad>
use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand.scad>


module bottom_section
(
	size=[110,175],
	fan_size=[80,25,80],
	fan_screw_diff=[71.5,71.5],
	fan_screw_extsize=[5,6],
	fan_cut_size=[79,79,20],
	fan_shift=-14,
	eth_adapter_size=[15,23.5,1],
	eth_adapter_dy=10,
	mainboard_size=[105,105,2],
	mainboard_shift=-28,
	mainboard_stands=[97,75,10,10,6,4],
	stepdown_converter_size=[43,21,2],
	stepdown_converter_stands=[30,16,4,2.5,2,4],
	stepdown_converter_shift=[-23,35.5],
	rs35_12_psu_size=[99,35.5,81.5],
	psu_screw_dx1=23,
	psu_screw_dx2=78,
	psu_screw_dy=40.5,
	psu_screw_diam=3.75,
	clearance=1,
	wall_sz=1.6,
	base_sz=2,
	psu_stand_sz=4,
	screw_diam=3,
	screw_clearance=0,
	quality=2,
)
{
	cutClr=0.1;
	height=rs35_12_psu_size[2]+clearance+base_sz;
	psu_clr_mode=rs35_12_psu_size[0]>rs35_12_psu_size[1];

	difference()
	{
		union()
		{
			//case base
			translate([0,0,-base_sz])
				case_section(size=[size[0],size[1],height],
					screw_diam=screw_diam,
					screw_clearance=screw_clearance,
					wall_sz=wall_sz,
					base_sz=base_sz,
					attach=0,
					quality=quality,
					vents=[false,false,false,false],
					center_xy=true);
			//psu clip
			translate([rs35_12_psu_size[0]/2-psu_screw_dx1,(size[1]-psu_stand_sz)/2-wall_sz,0])
				cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz], rounding=psu_stand_sz/2, quality=quality,round_corners=[false,true,true,false],attach=cutClr,center_xy=true);
			translate([rs35_12_psu_size[0]/2-psu_screw_dx2,(size[1]-psu_stand_sz)/2-wall_sz,0])
				cube_vround(size=[psu_stand_sz,psu_stand_sz,height-base_sz], rounding=psu_stand_sz/2, quality=quality,round_corners=[false,true,true,false],attach=cutClr,center_xy=true);
			//mainboard stands
			for(x=[-1:2:1],y=[-1:2:1])
				translate([x*mainboard_stands[0]/2,y*mainboard_stands[1]/2+mainboard_shift-(mainboard_size[1]-mainboard_stands[1])/2+mainboard_stands[5],0])
					stand(height=mainboard_stands[2],inner_diam=screw_diam,top_diam=mainboard_stands[4],bottom_diam=mainboard_stands[3],attach=cutClr,quality=quality,center_xy=true);
			//stepdown converter stands
			for(x=[-1:2:1])
			translate([x*stepdown_converter_stands[0]/2+stepdown_converter_shift[0],-x*stepdown_converter_stands[1]/2+stepdown_converter_shift[1],-cutClr])
			{
				cylinder(d=stepdown_converter_stands[2],h=stepdown_converter_stands[4]+cutClr,$fn=12*quality);
				cylinder(d=stepdown_converter_stands[3],h=stepdown_converter_stands[5]+cutClr,$fn=12*quality);
			}
			//fan clip
			translate([fan_shift,-size[1]/2,fan_size[2]/2])
			rotate(a=90,v=[1,0,0])
				for(x=[-1:2:1],y=[-1:2:1])
					translate([x*fan_screw_diff[0]/2,y*fan_screw_diff[1]/2,-wall_sz/2])
						cylinder(d=fan_screw_extsize[0],h=fan_screw_extsize[1],$fn=12*quality);
		}
		//psu clip holes
		translate([rs35_12_psu_size[0]/2-psu_screw_dx1,(size[1]-psu_stand_sz-wall_sz)/2,psu_screw_dy])
			rotate(a=-90,v=[1,0,0])
				cylinder(d=psu_screw_diam,h=psu_stand_sz+wall_sz+2*cutClr,center=true,$fn=12*quality);
		translate([rs35_12_psu_size[0]/2-psu_screw_dx2,(size[1]-psu_stand_sz-wall_sz)/2,psu_screw_dy])
			rotate(a=-90,v=[1,0,0])
				cylinder(d=psu_screw_diam,h=psu_stand_sz+wall_sz+2*cutClr,center=true,$fn=12*quality);
		//fan clip hole
		translate([fan_shift,-size[1]/2+wall_sz,fan_size[2]/2])
			rotate(a=90,v=[1,0,0])
				cube_vround(size=[fan_cut_size[0],fan_cut_size[1],wall_sz+2*cutClr], rounding=fan_cut_size[2], quality=quality,attach=wall_sz+screw_diam+cutClr,center_xy=true);
		//eth adapter holes
		translate([size[0]/2-wall_sz-eth_adapter_size[0],-size[1]/2+wall_sz,height-base_sz-eth_adapter_size[1]-eth_adapter_dy])
		{
			cube(size=[eth_adapter_size[0],screw_diam+wall_sz+cutClr,eth_adapter_size[1]]);
			translate([eth_adapter_size[2],-wall_sz-cutClr,eth_adapter_size[2]])
			cube(size=[eth_adapter_size[0]-eth_adapter_size[2]*2,screw_diam+wall_sz+cutClr,eth_adapter_size[1]-eth_adapter_size[2]*2]);
		}
	}

	//draw PSU on preview
	if($preview)
	color([0.25,0.25,0.25])
	translate([-rs35_12_psu_size[0]/2,size[1]/2-rs35_12_psu_size[1]-wall_sz-psu_stand_sz, 0])
		cube(size=rs35_12_psu_size);

	//draw mainboard on preview
	if($preview)
	color([0.25,0.25,0.25])
	translate([0,mainboard_shift,0])
	cube_vround(size=mainboard_size, quality=quality,attach=cutClr,center_xy=true);

	//draw stepdown converter on preview
	if($preview)
	color([0.25,0.25,0.25])
	translate([stepdown_converter_shift[0],stepdown_converter_shift[1],0])
	cube_vround(size=stepdown_converter_size,quality=quality,attach=cutClr,center_xy=true);

	//draw fan on preview
	if($preview)
	color([0.25,0.25,0.25])
	translate([-fan_size[0]/2+fan_shift,-size[1]/2-fan_size[1], 0])
		cube(size=fan_size);
}

bottom_section();
