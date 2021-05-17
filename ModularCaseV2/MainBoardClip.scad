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
	cutDepth=100,
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

module MBClip
(
	height=11,
	width=25,
	depth=25,
	cornerCutR=6/2,
	screwHoleX=10,
	screwHoleD=3.5,
	cutX=11,
	cutY=10,
	cutD=2,
	cutXShift=1,
	quality=1,
)
{
	tieHeight=4.5;
	cutClr=0.1;
	difference()
	{
		//case base
		cube_vround(size=[width,depth,height],rounding=2,quality=quality,round_corners=[false,false,false,true]);
		//corner rod cut
		translate([0,0,-cutClr])
			cylinder(h=height+2*cutClr,r=cornerCutR,$fn=24*quality);
		translate([0,0,(height-tieHeight)/2])
			NylonTieCut(tieHeight=tieHeight);
		translate([cutX,-cutY,-cutClr])
			cube_vround(size=[width,depth,height+cutClr*2],rounding=2,quality=quality,round_corners=[false,false,false,true]);
		translate([cutX,(depth-cutY)+cutY/2-cutD/2,-cutClr])
			cube_vround(size=[width,cutD,height+cutClr*2],rounding=cutD/2,quality=quality,round_corners=[false,false,true,true]);
		translate([(width-cutX)+cutX/2-screwHoleD/2+cutXShift,-cutClr,height/2])
			rotate(a=90,v=[-1,0,0])
				cylinder(h=depth+2*cutClr,d=screwHoleD,$fn=24*quality);
	}

}

MBClip();


