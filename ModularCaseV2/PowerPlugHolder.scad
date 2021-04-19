use <../OpenSCAD_Modules/cube_vround.scad>

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
	}
}

PowerPlugHolder();


