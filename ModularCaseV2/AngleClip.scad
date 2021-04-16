use <../OpenSCAD_Modules/cube_vround.scad>

module Nut
(
width=8,
height=4,
extraCutLen=10,
)
{
	fudge = 1/cos(180/6);
	union()
	{
		cylinder(h=height,d=width*fudge,$fn=6);
		translate([extraCutLen/2,0,height/2])
				cube([extraCutLen,width,height],center=true);
	}
}

module 3DClip
(
rodDiam=6,
rodShell=12,
nutWidth=10,
nutHeight=5,
clipSize=20,
quality=1,
)
{
	rodShift=rodDiam+rodShell/2-rodDiam/2;
	extraCut=0.1;
	//color(alpha=0.75)
	//union()
	difference()
	{
		cube_vround(size=[clipSize,clipSize,clipSize],rounding=2,quality=quality);
		translate([rodShell/2,rodShell/2,-extraCut/2+rodShift])
			rotate(a=0, v=[0,0,0])
				cylinder(h=clipSize+extraCut,d=rodDiam,$fn=24*quality);
		translate([-extraCut/2+rodShift,rodShell/2,rodShell/2])
			rotate(a=90, v=[0,1,0])
				cylinder(h=clipSize+extraCut,d=rodDiam,$fn=24*quality);
		translate([rodShell/2,-extraCut/2+rodShift,rodShell/2])
			rotate(a=90, v=[-1,0,0])
				cylinder(h=clipSize+extraCut,d=rodDiam,$fn=24*quality);
		
		translate([rodShell/2,rodShell/2,-extraCut/2+rodShell])
			rotate(a=45, v=[0,0,1])
				Nut(width=nutWidth,height=nutHeight,extraCutLen=clipSize);
		translate([-extraCut/2+rodShell,rodShell/2,rodShell/2])
			rotate(a=90, v=[1,0,0])
				rotate(a=90, v=[0,1,0])
					Nut(width=nutWidth,height=nutHeight,extraCutLen=clipSize);
		translate([rodShell/2,-extraCut/2+rodShell,rodShell/2])
			rotate(a=90, v=[-1,0,0])
				Nut(width=nutWidth,height=nutHeight,extraCutLen=clipSize);
		translate([rodShell,rodShell,-extraCut/2])
			cube([clipSize-rodShell+extraCut,clipSize-rodShell+extraCut,clipSize+extraCut*2]);
	}
}

3DClip();