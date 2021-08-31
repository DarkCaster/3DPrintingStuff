use <../OpenSCAD_Modules/cube_vround.scad>

module FanDriversHolder
(
	size=[50,15,60],
	cutSize=[36,13,58],
	holeSize=[4,12],
	screwDiam=3.5,
	screwDiff=42,
	quality=1,
)
{
	cutClr=0.1;
	length=size[0];
	width=size[1];
	height=size[2];
	difference()
	{
		cube_vround(size=[length,width,height],rounding=2,center_xy=true,quality=quality);
		//main cut
		translate([-cutSize[0]/2,(width-2*cutSize[1])/2+cutClr,-cutClr])
			cube(size=[cutSize[0],cutSize[1]+cutClr,cutSize[2]+cutClr]);
		//screw cuts
		translate([-screwDiff/2,0,-cutClr])
			cylinder(h=height+2*cutClr,d=screwDiam,$fn=quality*12);
		translate([screwDiff/2,0,-cutClr])
			cylinder(h=height+2*cutClr,d=screwDiam,$fn=quality*12);
		translate([0,(size[1]-holeSize[1])/2+cutClr,0])
			cube_vround(size=[holeSize[0],holeSize[1]+cutClr,height+cutClr],rounding=2,round_corners=[false,true,true,false],center_xy=true,quality=quality);
	}
}

FanDriversHolder();