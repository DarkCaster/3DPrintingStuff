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
	
	quality=2,
)
{
	cutClr=1;

	difference()
	{
		union()
		{
			difference()
			{
				//base
				rounding=5;
				cube_vround(size=ext_size,center_xy=true,rounding=rounding,quality=quality);
				//main cut
				rounding_diff=(ext_size[0]-int_size[0])>0?(ext_size[0]-int_size[0])/2:4.99;
				echo(rounding_diff);
				int_rounding=rounding_diff>=rounding?0.01:rounding-rounding_diff;
				translate([0,0,-cutClr])
					cube_vround(size=[int_size[0],int_size[1],int_size[2]+cutClr],center_xy=true,rounding=int_rounding,quality=quality);
				translate([0,0,-cutClr])
					cylinder(d=int_size[3],h=int_size[4]+cutClr,$fn=quality*12);
				translate([0,0,-cutClr])
					cylinder(d=int_size[5],h=ext_size[2]+2*cutClr,$fn=quality*12);
				for (j=[-1:2:1])
				translate([0,j*ext_size[0]/2,corner_bottom_cuts_shift_z])
				for (i=[-1:2:1])
				translate([i*ext_size[1]/2,0,0])
				rotate(a=90,v=[-i*j,1,0])
				cylinder(d=corner_bottom_cuts_diam,h=rounding*10,center=true,$fn=quality*12);
			}
		}

		for(d=[0:1])
		rotate(a=90,v=[0,0,d])
		for (j=[-1:2:1])
		translate([0,j*ext_size[1-d]/2,0])
		for (i=[-1:2:1])
		translate([i*extClipDiff[d]/2,0,extClipHoleHeight])
		rotate(a=90,v=[1,0,0])
		cylinder(d=extClipHoleDiam,h=(d>0?ext_size[0]-int_size[0]:ext_size[1]-int_size[1])+2*cutClr,center=true,$fn=quality*12);
	}

}

CaseCover1();
HNutPocket();
VNutPocket();
