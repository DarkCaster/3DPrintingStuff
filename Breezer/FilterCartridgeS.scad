use <../OpenSCAD_Modules/cube_vround.scad>


module HNut
(
	nutDiam=6.75,
	nutHeight=3,
	topClr=0.1,
)
{
	union()
	{
		translate([0,0,topClr/2])
		cylinder(d=nutDiam,h=nutHeight+topClr,center=true,$fn=6);
	}
}

module HHead
(
	headDiam=6.5,
	headHeight=3,
	topClr=0.1,
	quality=2,
)
{
	union()
	{
		translate([0,0,topClr/2])
		cylinder(d=headDiam,h=headHeight+topClr,center=true,$fn=12*quality);
	}
}

module VNutPocket
(
	nutDiam=6.75,
	nutHeight=3,
	pocketLen=10,
)
{
	m=(nutDiam/2)*sqrt(3)/2;
	rotate(a=90,v=[0,0,1])
		rotate(a=90,v=[0,-1,0])
			union()
			{
				cylinder(d=nutDiam,h=nutHeight,center=true,$fn=6);
				translate([pocketLen/2,0,0])
				cube(size=[pocketLen,m*2,nutHeight],center=true);
			}
}

module CartridgeCaseHalf
(
	ext_size=[160,134,5],
	int_size=[150,118,3],
	handle_size=[8.8,150],
	handle_shift=-4.9,
	xshift=5,
	vscrew_diam=3.25,
	hscrew_diam=3.75,
	vscrew_diff=[140,134-(134-118)/2-0.4],
	hscrew_diff=142,
	vhscrew_diff=50,
	vents_size=[33,10,3],
	vents_period=[35,12],
	vents_count=[4,9],
	vents_pos=[-70,-53],
	nutHeight=3,
	quality=2
)
{
	cutClr=1;
	rounding=5;
	translate([xshift,0,0])
	difference()
	{
		union()
		{
			//base
			translate([cutClr/2,0,0])
			cube_vround(size=[ext_size[0]+cutClr,ext_size[1],ext_size[2]],center_xy=true,rounding=rounding,quality=quality,round_corners=[false,false,true,true]);
			//handle
			translate([ext_size[0]/2+handle_size[0]/2+handle_shift,0,0])
			cube_vround(size=[handle_size[0],handle_size[1],ext_size[2]],center_xy=true,rounding=0.001,quality=quality,round_corners=[false,false,false,false]);
		}
		//filter place
		translate([0,0,ext_size[2]-int_size[2]])
		cube_vround(size=[int_size[0],int_size[1],int_size[2]+cutClr],center_xy=true,round_corners=[false,false,false,false]);
		//screw holes with nuts/head cuts
		for (i=[-1:2:1],j=[-1:2:1])
		{
			translate([i*vscrew_diff[0]/2,j*vscrew_diff[1]/2,0])
			cylinder(d=vscrew_diam, h=(ext_size[2]+cutClr)*2, center=true, $fn=12*quality);

			translate([i*vscrew_diff[0]/2,j*vscrew_diff[1]/2,nutHeight/2-cutClr])
			if(j<0)
				HNut(topClr=cutClr,nutHeight=nutHeight);
			else
				HHead(topClr=cutClr,headHeight=nutHeight);
		}
		//horizontal screw holes
		for (j=[-1:2:1])
		{
			translate([0,j*hscrew_diff/2,ext_size[2]])
			rotate(a=90,v=[0,1,0])
			cylinder(d=hscrew_diam, h=ext_size[0]*2, center=true, $fn=12*quality);
		}
		//vertical handle screw holes
		for (j=[-1:2:1])
		{
			translate([ext_size[0]/2+handle_size[0]/2+handle_shift,j*vhscrew_diff/2,0])
			cylinder(d=vscrew_diam, h=(ext_size[2]+cutClr)*2, center=true, $fn=12*quality);

			translate([ext_size[0]/2+handle_size[0]/2+handle_shift,j*vhscrew_diff/2,nutHeight/2-cutClr])
			if(j<0)
				rotate(a=180/6,v=[0,0,1])
				HNut(topClr=cutClr,nutHeight=nutHeight);
			else
				HHead(topClr=cutClr,headHeight=nutHeight);
		}
		//vents
		for (vx=[0:vents_count[0]-1],vy=[0:vents_count[1]-1])
		{
			translate([vents_pos[0]+vx*vents_period[0],vents_pos[1]+vy*vents_period[1],0])
			cube_vround(size=[vents_size[0],vents_size[1],ext_size[2]*2],center_z=true,quality=quality,rounding=vents_size[2]);
		}
	}
}


module CartridgeCarrier
(
	ext_size=[160,160,12],
	int_size=[160,134,10],
	int_clr=0.8,
	base_clr=0.4,
	int_clip_size=2,
	xshift=5,
	screw_hole_diam=3.75,
	corner_clip_shift=5,
	center_clip_shift=5,
	hscrew_diff=142,
	hscrew_size=[30,12],
	quality=2
)
{
	cutClr=1;
	rounding=5;
	difference()
	{
		//base
		cube_vround(size=ext_size,center_xy=true,quality=quality,rounding=rounding);
		//main cut
		translate([xshift,0,-cutClr])
		cube_vround(size=[int_size[0]+int_clr,int_size[1]+int_clr,int_size[2]+base_clr+cutClr],center_xy=true,quality=quality,rounding=rounding,round_corners=[false,false,true,true]);
		//corner clip cuts
		for (i=[-1:2:1],j=[-1:2:1])
		translate([i*(ext_size[0]/2-corner_clip_shift),j*(ext_size[1]/2-corner_clip_shift),-cutClr])
		cylinder(d=screw_hole_diam,h=ext_size[2]+2*cutClr,$fn=quality*12,center=false);
		//clip
		translate([0,0,-cutClr])
		cube_vround(size=[int_size[0]-2*int_clip_size-2*xshift,int_size[1]-2*int_clip_size,ext_size[2]+2*cutClr],center_xy=true,quality=quality,rounding=rounding,round_corners=[true,true,true,true]);
		//center clips
		for (j=[-1:2:1])
		translate([0,j*(ext_size[1]/2-center_clip_shift),-cutClr])
		cylinder(d=screw_hole_diam,h=ext_size[2]+2*cutClr,$fn=quality*12,center=false);
		//horizontal screw holes
		for (j=[-1:2:1])
		{
			translate([ext_size[0]/2,j*hscrew_diff/2,int_size[2]/2])
			{
				rotate(a=90,v=[0,1,0])
				cylinder(d=screw_hole_diam, h=hscrew_size[0]*2, center=true, $fn=12*quality);
				translate([-hscrew_size[1],0,0])
				rotate(a=180,v=[1,0,0])
				rotate(a=90,v=[0,0,1])
				VNutPocket(pocketLen=int_size[2]);
			}
		}
	}

}

CartridgeCaseHalf();

translate([0,0,10])
rotate(a=180,v=[1,0,0])
CartridgeCaseHalf();

CartridgeCarrier();
