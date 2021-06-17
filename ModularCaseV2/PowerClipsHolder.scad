use <../OpenSCAD_Modules/cube_vround.scad>

module PowerClipsHolder
(
	size=[50,15,15],
	cutSize=[32,10],
	clipSize=[4,2],
	clipShift=8,
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
			cube(size=[cutSize[0],cutSize[1]+cutClr,height+2*cutClr]);
		//rear cut
		translate([-cutSize[0]/2-clipSize[0],(width-2*cutSize[1])/2-clipSize[0],height-clipSize[1]-clipShift])
			cube(size=[cutSize[0]+clipSize[0]*2,cutSize[1]+clipSize[0]+cutClr,clipSize[1]]);
		//screw cuts
		translate([-screwDiff/2,0,-cutClr])
			cylinder(h=height+2*cutClr,d=screwDiam,$fn=quality*12);
		translate([screwDiff/2,0,-cutClr])
			cylinder(h=height+2*cutClr,d=screwDiam,$fn=quality*12);
	}
//	color(c=[0,0,0])
}

PowerClipsHolder();
