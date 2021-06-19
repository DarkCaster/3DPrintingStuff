use <../OpenSCAD_Modules/cube_vround.scad>


module AuxConnectorHolder
(
	screwDiam=3.25,
	holderSize=[50,16,11],
	iCutSize=[29,11,1],
	eCutSize=[40,13,6],
	iScrewDiff=33.5,
	eScrewDiff=45,
	quality=1,
)
{
	cutClr=0.1;
	topCutHeight=holderSize[2]-eCutSize[2]-iCutSize[2];
	difference()
	{
		cube_vround(size=[holderSize[0],holderSize[1],holderSize[2]],rounding=2,center_xy=true,quality=quality);
		translate([0,0,-cutClr])
			cube_vround(size=[eCutSize[0],eCutSize[1],eCutSize[2]+cutClr],rounding=1,center_xy=true,quality=quality);
		translate([0,0,holderSize[2]-topCutHeight])
			cube_vround(size=[eCutSize[0],eCutSize[1],topCutHeight+cutClr],rounding=1,center_xy=true,quality=quality);
		cube_vround(size=[iCutSize[0],iCutSize[1],holderSize[2]],rounding=1,center_xy=true,quality=quality);
		translate([iScrewDiff/2,0,0])
			cylinder(d=screwDiam,h=holderSize[2],$fn=quality*12);
		translate([-iScrewDiff/2,0,0])
			cylinder(d=screwDiam,h=holderSize[2],$fn=quality*12);
		translate([eScrewDiff/2,0,-cutClr])
			cylinder(d=screwDiam,h=holderSize[2]+2*cutClr,$fn=quality*12);
		translate([-eScrewDiff/2,0,-cutClr])
			cylinder(d=screwDiam,h=holderSize[2]+2*cutClr,$fn=quality*12);
	}
	color(c=[0,0,0])
	{

	}
}

AuxConnectorHolder();