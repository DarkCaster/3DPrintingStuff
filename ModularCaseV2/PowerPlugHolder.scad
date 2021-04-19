use <../OpenSCAD_Modules/cube_vround.scad>

module NylonTieCut
(
//tie
	tieHeight=4.5,
	tieWidth=1.5,
	tieDepth=5,
	tieShift=5,
//lock cut
	cutShift=2.5,
	cutHeight=7,
	cutDepth=20,
)
{
	cutClr=0.1;
	union()
	{
		translate([0,0,tieHeight/2])
		{
			translate([tieShift,-cutClr,-tieHeight/2])
				cube([tieWidth,tieDepth+2*cutClr,tieHeight]);
			translate([-cutClr,tieDepth,-cutHeight/2])
				cube([cutClr+tieShift+tieWidth+cutShift,cutDepth,cutHeight]);
		}
	}
}

//NylonTieCut();

module PowerPlugHolder
(
	height=70,
	width=35,
	depth=50,
	cornerCutL=18,
	cornerCutH=14,
	cornerCutD=14,
	cornerCutR=6/2,
	quality=1,
)
{
	cutClr=0.1;
	difference()
	{
		//case base
		cube_vround(size=[width,height,depth],rounding=2,quality=quality);
		translate([-cutClr,-cutClr,depth-cornerCutD])
			cube([cornerCutL+cutClr,cornerCutH+cutClr,cornerCutD+cutClr]);
		translate([-cutClr,0,depth])
			rotate(a=90,v=[0,1,0])
				cylinder(h=width+2*cutClr,r=cornerCutR,$fn=24*quality);
		translate([0,-cutClr,depth])
			rotate(a=90,v=[-1,0,0])
				cylinder(h=height+2*cutClr,r=cornerCutR,$fn=24*quality);
		translate([0,0,-cutClr])
			cylinder(h=depth+2*cutClr,r=cornerCutR,$fn=24*quality);
		//holes for nylon ties
		translate([width-6,0,depth])
			rotate(a=90,v=[0,0,1])
				rotate(a=90,v=[-1,0,0])
					NylonTieCut();
		translate([0,0,5])
			mirror([0,1,0])
				rotate(a=90,v=[0,0,-1])
					NylonTieCut(cutDepth=15);
		translate([0,0,25])
			mirror([0,1,0])
				rotate(a=90,v=[0,0,-1])
					NylonTieCut(cutDepth=15);
		translate([0,21,depth])
			rotate(a=90,v=[-1,0,0])
				NylonTieCut();
		translate([0,57,depth])
			rotate(a=90,v=[-1,0,0])
				NylonTieCut();
		translate([0,39,depth])
			rotate(a=90,v=[-1,0,0])
				NylonTieCut();
	}
}

PowerPlugHolder();


