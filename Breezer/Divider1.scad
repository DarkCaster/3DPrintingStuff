use <../OpenSCAD_Modules/cube_vround.scad>

module Divider1
(
	size=[160,160],
	wallSize=2,
	baseDiam=[120,118,4,1],
	baseElevation=20,
	baseCutHeight=10,
	cutDiam=146,
	wallSize=2,
	edgeClr=0.2,
	quality=2,
)
{
	cutClr=0.1;
	baseSize=[size[0]-wallSize,size[1]-wallSize];
	baseCutSz=(baseSize[1]-baseDiam[0])/2;
	
	union()
	{
		translate([0,0,baseElevation])
		difference()
		{
			translate([0,(baseCutSz-edgeClr-cutClr)/2,0])
			cube_vround(size=[baseSize[0],baseSize[1]-baseCutSz+edgeClr+cutClr,baseDiam[2]],center_xy=true,rounding=5,round_corners=[true,false,false,true],quality=quality);
			translate([0,0,-cutClr])
				cylinder(d=baseDiam[1]+2*edgeClr,h=baseDiam[2]+2*cutClr,$fn=12*quality);
			translate([0,0,-2*cutClr])
				cylinder(d=baseDiam[0]+2*edgeClr,h=baseDiam[2]-baseDiam[3]+2*cutClr,$fn=12*quality);
		}
		translate([0,-(baseDiam[2]+baseDiam[0])/2-edgeClr,(baseElevation+baseDiam[2])/2])
		cube(size=[baseSize[0],baseDiam[2],baseElevation+baseDiam[2]],center=true);
	}


	//cutHole
	translate([0,0,-cutClr])
		cylinder(d=cutDiam,h=baseCutHeight+cutClr);
}

Divider1();
