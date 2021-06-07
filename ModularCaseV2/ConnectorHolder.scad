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

module DB9Cut
(
	extra_width=2,
	width=3.2,
	screw_diam=3.25,
	conn_width=19,
	conn_length=13,
	screw_diff=25,
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

//DB9Cut();

module PowerPlugHolder
(
	height=105,
	width=2,
	bottom_clip_width=2.1,
	extra_width=5,
	depth=125-30,
	extra_height=2,
	cornerCutL=18,
	cornerCutH=14,
	cornerCutD=14,
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
		translate([-extra_width,0,-extra_height])
			cube(size=[width+extra_width,height,depth+extra_height]);
		translate([-cutClr-extra_width,-cutClr,depth-cornerCutD])
			cube([cornerCutL+extra_width+cutClr,cornerCutH+cutClr,cornerCutD+cutClr]);
		translate([-cutClr,0,depth])
			rotate(a=90,v=[0,1,0])
				cylinder(h=width+2*cutClr,r=cornerCutR,$fn=24*quality);
		translate([0,-cutClr,depth])
			rotate(a=90,v=[-1,0,0])
				cylinder(h=height+2*cutClr,r=cornerCutR,$fn=24*quality);
		translate([0,0,-cutClr-extra_height])
			cylinder(h=depth+2*cutClr+extra_height,r=cornerCutR,$fn=24*quality);
		translate([0,-cutClr,-cutClr-extra_height])
			cube(size=[width+cutClr,height+2*cutClr,2*cutClr+extra_height]);

		translate([0,cutShift,10])
			NylonTieCut(extra_width=extra_width);
		translate([0,cutShift,30])
			NylonTieCut(extra_width=extra_width);
		translate([0,cutShift,50])
			NylonTieCut(extra_width=extra_width);
		translate([0,cutShift,70])
			NylonTieCut(extra_width=extra_width);

		translate([0,30,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,50,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,70,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,90,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);

		translate([0,20,68])
			rotate(a=-90,v=[0,1,0])
				DB9Cut(extra_width=extra_width);
		translate([0,40,68])
			rotate(a=-90,v=[0,1,0])
				DB9Cut(extra_width=extra_width);
		translate([0,20,35])
			rotate(a=-90,v=[0,1,0])
				DB9Cut(extra_width=extra_width);
		translate([0,40,35])
			rotate(a=-90,v=[0,1,0])
				DB9Cut(extra_width=extra_width);
		//rear cut
		translate([0,0,bottom_clip_width])
			cube(size=[width+cutClr,height+cutClr,depth+cutClr]);
		//corner cut
		translate([-extra_width-cutClr,80,depth-8])
			cube(size=[extra_width+width+cutClr*2,8,depth]);
	}
}

PowerPlugHolder();


