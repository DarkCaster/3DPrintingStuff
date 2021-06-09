use <../OpenSCAD_Modules/cube_vround.scad>

module NylonTieCut
(
	extra_width=2,
	width=3.2,
	//lock cut
	cutHeight=7,
	cutWidth=2,
)
{
	cutClr=0.1;
	translate([-extra_width-cutClr,-cutClr,0])
		cube(size=[width+2*cutClr+extra_width, cutWidth+2*cutClr, cutHeight]);
}

module DB15Cut
(
	extra_width=2,
	width=3.2,
	screw_diam=3.25,
	conn_width=28,
	conn_length=13,
	screw_diff=33.5,
	quality=1,
)
{
	cutClr=0.1;
	union()
	{
		translate([0,0,-width-cutClr])
			cube_vround(size=[conn_width,conn_length,width+extra_width+2*cutClr],rounding=2,center_xy=true);
		translate([-screw_diff/2,0,-width-cutClr])
			cylinder(d=screw_diam,h=width+extra_width+2*cutClr,$fn=quality*12);
		translate([screw_diff/2,0,-width-cutClr])
			cylinder(d=screw_diam,h=width+extra_width+2*cutClr,$fn=quality*12);
	}
}

module SquareCut
(
	extra_width=2,
	width=3.2,
	screw_diam=3.25,
	conn_width=35,
	conn_length=13,
	screw_diff=42,
	quality=1,
)
{
	cutClr=0.1;
	union()
	{
		translate([0,0,-width-cutClr])
			cube_vround(size=[conn_width,conn_length,width+extra_width+2*cutClr],rounding=2,round_corners=[false,false,false,false],center_xy=true);
		translate([-screw_diff/2,0,-width-cutClr])
			cylinder(d=screw_diam,h=width+extra_width+2*cutClr,$fn=quality*12);
		translate([screw_diff/2,0,-width-cutClr])
			cylinder(d=screw_diam,h=width+extra_width+2*cutClr,$fn=quality*12);
	}
}


module PowerPlugHolder
(
	height=65,
	width=2,
	extra_width=5,
	depth=125,
	cornerCutR=6/2,
	quality=1,
//lock cut
	cutShift=5,
	cutHeight=7,
	cutWidth=2,
)
{
	cutClr=0.1;
	difference()
	{
		//case base
		translate([-extra_width,0,0])
			cube(size=[extra_width,height,depth]);

		translate([0,-cutClr,depth])
			rotate(a=90,v=[-1,0,0])
				cylinder(h=height+2*cutClr,r=cornerCutR,$fn=24*quality);
		translate([0,-cutClr,0])
		rotate(a=90,v=[-1,0,0])
			cylinder(h=depth+2*cutClr,r=cornerCutR,$fn=24*quality);

		translate([0,5,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,20,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,35,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,50,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);

		//translate([0,5+7,cutShift])
		//	rotate(a=90,v=[1,0,0])
		//		NylonTieCut(extra_width=extra_width);
		translate([0,20+7,cutShift])
			rotate(a=90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,35+7,cutShift])
			rotate(a=90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,50+7,cutShift])
			rotate(a=90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);

		translate([0,50,40])
			rotate(a=-90,v=[0,1,0])
				DB15Cut(extra_width=extra_width);

		translate([-extra_width/2,8,35])
			rotate(a=-90,v=[0,1,0])
				SquareCut(extra_width=extra_width);

		//corner cut
		translate([-extra_width-cutClr,8,-depth+8])
			cube(size=[extra_width+cutClr*2,8,depth]);
		//inner cut
		translate([-4,5,65])
			cube(size=[extra_width,55,50]);
	}

}

PowerPlugHolder();


