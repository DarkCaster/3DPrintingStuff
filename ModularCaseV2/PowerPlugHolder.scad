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
	height=105,
	width=40,
	depth=30,
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
		translate([width-3,0,depth])
			rotate(a=90,v=[0,0,1])
				rotate(a=90,v=[-1,0,0])
					NylonTieCut();
		translate([width-14,0,depth])
			rotate(a=90,v=[0,0,1])
				rotate(a=90,v=[-1,0,0])
					NylonTieCut();

		translate([0,0,5])
			mirror([0,1,0])
				rotate(a=90,v=[0,0,-1])
					NylonTieCut(cutDepth=13);

		translate([0,20,depth])
			rotate(a=90,v=[-1,0,0])
				NylonTieCut();
		translate([0,35,depth])
			rotate(a=90,v=[-1,0,0])
				NylonTieCut();
		translate([0,50,depth])
			rotate(a=90,v=[-1,0,0])
				NylonTieCut();
		translate([0,65,depth])
			rotate(a=90,v=[-1,0,0])
				NylonTieCut();
		translate([0,80,depth])
			rotate(a=90,v=[-1,0,0])
				NylonTieCut();
		translate([0,95,depth])
			rotate(a=90,v=[-1,0,0])
				NylonTieCut();
		//power-plug cut
		translate([11,20,-cutClr])
			cube([20,27.5,depth+2*cutClr]);
		//fuse box
		translate([11,53,-cutClr])
			cube([24.5,10,depth+2*cutClr]);
		//switch cut
		translate([10,68,-cutClr])
			cube([22,31,depth+2*cutClr]);
	}
}

PowerPlugHolder();


