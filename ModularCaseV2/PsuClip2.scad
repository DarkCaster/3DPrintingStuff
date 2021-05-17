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

module PSUClip1
(
	height=(126-105)/2,
	width=40,
	depth=236-175,
	cornerCutR=6/2,
	screwHolesH=236-175-5,
	screwHolesDiff=18,
	screwHolesD=4.5,
	screwHatD=9,
	screwSlotL=10,
	quality=1,
)
{
	cutClr=0.1;
	difference()
	{
		//case base
		cube_vround(size=[width,height,depth],rounding=2,quality=quality);
		translate([-cutClr,0,depth])
			rotate(a=90,v=[0,1,0])
				cylinder(h=width+2*cutClr,r=cornerCutR,$fn=24*quality);
		translate([width/2+11.25,0,depth])
			rotate(a=90,v=[0,-1,0])
				rotate(a=90,v=[0,0,1])
					NylonTieCut();
		translate([width/2-6.75,0,depth])
			rotate(a=90,v=[0,-1,0])
				rotate(a=90,v=[0,0,1])
					NylonTieCut();
		//screw holes
		hull()
		{
			translate([width/2-screwHolesDiff/2,-cutClr,depth-screwHolesH])
				rotate(a=90,v=[-1,0,0])
					cylinder(h=height+2*cutClr,d=screwHolesD,$fn=24*quality);
			translate([width/2-screwHolesDiff/2,-cutClr,depth-screwHolesH+screwSlotL])
				rotate(a=90,v=[-1,0,0])
					cylinder(h=height+2*cutClr,d=screwHolesD,$fn=24*quality);
		}
		hull()
		{
			translate([width/2+screwHolesDiff/2,-cutClr,depth-screwHolesH])
				rotate(a=90,v=[-1,0,0])
					cylinder(h=height+2*cutClr,d=screwHolesD,$fn=24*quality);
			translate([width/2+screwHolesDiff/2,-cutClr,depth-screwHolesH+screwSlotL])
				rotate(a=90,v=[-1,0,0])
					cylinder(h=height+2*cutClr,d=screwHolesD,$fn=24*quality);
		}
		
		//screw caps
		hull()
		{
			translate([width/2-screwHolesDiff/2,-cutClr,depth-screwHolesH])
				rotate(a=90,v=[-1,0,0])
					cylinder(h=9+cutClr,d=screwHatD,$fn=24*quality);
			translate([width/2-screwHolesDiff/2,-cutClr,depth-screwHolesH+screwSlotL])
				rotate(a=90,v=[-1,0,0])
					cylinder(h=9+cutClr,d=screwHatD,$fn=24*quality);
		}
		hull()
		{
			translate([width/2+screwHolesDiff/2,-cutClr,depth-screwHolesH])
				rotate(a=90,v=[-1,0,0])
					cylinder(h=9+cutClr,d=screwHatD,$fn=24*quality);
			translate([width/2+screwHolesDiff/2,-cutClr,depth-screwHolesH+screwSlotL])
				rotate(a=90,v=[-1,0,0])
					cylinder(h=9+cutClr,d=screwHatD,$fn=24*quality);
		}
	}
}

PSUClip1();


