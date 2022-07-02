use <../OpenSCAD_Modules/cube_vround.scad>


module HNutPocket
(
	nutDiam=6.75,
	nutHeight=3,
	pocketLen=10,
)
{
	m=(nutDiam/2)*sqrt(3)/2;
	union()
	{
		cylinder(d=nutDiam,h=nutHeight,center=true,$fn=6);
		translate([pocketLen/2,0,0])
		cube(size=[pocketLen,m*2,nutHeight],center=true);
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

module CaseCover1
(
	ext_size=[160,160,37],
	int_size=[157,157,33,122,34,116],
	extClipHoleHeight=5-0.1,
	extClipHoleDiam=3.75,
	extClipDiff=[100,100],
	corner_bottom_cuts_diam=20,
	corner_bottom_cuts_shift_z=-5,
	corner_hubs_size=[10,23,16],
	corner_clip_shift=[5,6],
	vent_lever_cut_shift=11,
	vent_lever_cut_size=[35,5.5],
	vent_lever_clip_diff=130,
	center_hubs_size=[15,10,8.4],
	center_clip_shift=[5,6],
	quality=2,
)
{
	cutClr=1;
	rounding=5;

	difference()
	{
		union()
		{
			difference()
			{
				//base
				cube_vround(size=ext_size,center_xy=true,rounding=rounding,quality=quality);
				//main vent cut
				rounding_diff=(ext_size[0]-int_size[0])>0?(ext_size[0]-int_size[0])/2:4.99;
				echo(rounding_diff);
				int_rounding=rounding_diff>=rounding?0.01:rounding-rounding_diff;
				translate([0,0,-cutClr])
					cube_vround(size=[int_size[0],int_size[1],int_size[2]+cutClr],center_xy=true,rounding=int_rounding,quality=quality);
				translate([0,0,-cutClr])
					cylinder(d=int_size[3],h=int_size[4]+cutClr,$fn=quality*12);
				translate([0,0,-cutClr])
					cylinder(d=int_size[5],h=ext_size[2]+2*cutClr,$fn=quality*12);
			}

			//corner hubs
			for (i=[-1:2:1],j=[-1:2:1])
			translate([i*(ext_size[0]/2-corner_hubs_size[0]/2),j*(ext_size[1]/2-corner_hubs_size[1]/2),ext_size[2]-corner_hubs_size[2]])
			cube_vround(size=corner_hubs_size,center_xy=true,rounding=rounding,quality=quality,round_corners=[i*j>0, i*j<0, i*j>0, i*j<0]);

			//center hubs
			for (j=[-1:2:1])
			translate([0,j*(ext_size[1]/2-center_hubs_size[1]/2),ext_size[2]-center_hubs_size[2]])
			cube_vround(size=center_hubs_size,center_xy=true,rounding=rounding,quality=quality,round_corners=[j<0,j>0,j>0,j<0]);
		}

		//corner bottom cuts
		for (i=[-1:2:1],j=[-1:2:1])
		translate([i*ext_size[0]/2,j*ext_size[1]/2,corner_bottom_cuts_shift_z])
		rotate(a=90,v=[-i*j,1,0])
		cylinder(d=corner_bottom_cuts_diam,h=rounding*10,center=true,$fn=quality*12);

		//center clips
		for (j=[-1:2:1])
		translate([0,j*(ext_size[1]/2-center_clip_shift[0]),ext_size[2]-center_clip_shift[1]])
		{
			cylinder(d=extClipHoleDiam,h=ext_size[2]+2*cutClr,center=true,$fn=quality*12);
			rotate(a=j*270,v=[0,0,1])
			HNutPocket();
		}

		//corner clip cuts
		for (i=[-1:2:1],j=[-1:2:1])
		translate([i*(ext_size[0]/2-corner_clip_shift[0]),j*(ext_size[1]/2-corner_clip_shift[0]),0])
		{
			cylinder(d=extClipHoleDiam,h=ext_size[2]+cutClr,$fn=quality*12,center=false);
			translate([0,0,ext_size[2]-corner_clip_shift[1]])
			rotate(a=i>0?180:0,v=[0,0,1])
			HNutPocket();
		}

		//bottom corner cuts
		for(d=[0:1])
		rotate(a=90,v=[0,0,d])
		for (i=[-1:2:1],j=[-1:2:1])
		translate([i*extClipDiff[d]/2,j*ext_size[1-d]/2,extClipHoleHeight])
		rotate(a=90,v=[1,0,0])
		cylinder(d=extClipHoleDiam,h=(d>0?ext_size[0]-int_size[0]:ext_size[1]-int_size[1])+2*cutClr,center=true,$fn=quality*12);

		//vent lever cut
		translate([-ext_size[0], -vent_lever_cut_size[0]/2, ext_size[2]-vent_lever_cut_size[1]/2-vent_lever_cut_shift])
		cube([ext_size[0],vent_lever_cut_size[0],vent_lever_cut_size[1]]);
		//vent lever clip holes
		for (i=[-1:2:1])
		translate([-ext_size[0]/2,i*vent_lever_clip_diff/2, ext_size[2]-vent_lever_cut_shift])
		{
			rotate(a=90,v=[0,1,0])
			cylinder(d=extClipHoleDiam,h=ext_size[0],center=true,$fn=quality*12);
			//vent lever nut holes
			translate([corner_clip_shift[0],0,0])
			rotate(a=180,v=[1,0,0])
			rotate(a=90,v=[0,0,1])
			VNutPocket(pocketLen=ext_size[2]);
		}
	}
}

CaseCover1();


