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
	conn_height=13,
	screw_diff=25,
)
{
	cutClr=0.1;
	
}

module PowerPlugHolder
(
	height=60 ,
	width=3.2,
	extra_width=2,
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
			NylonTieCut();
		translate([0,cutShift,30])
			NylonTieCut();
		translate([0,cutShift,50])
			NylonTieCut();
		translate([0,cutShift,70])
			NylonTieCut();
		translate([0,20,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut();
		translate([0,30,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut();
		translate([0,40,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut();
		translate([0,50,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut();
	}
}

PowerPlugHolder();


