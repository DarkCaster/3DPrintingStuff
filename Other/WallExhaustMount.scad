use <../OpenSCAD_Modules/cube_vround.scad>

module Plate
(
	wallSz=2.5,
	backExtSize=[190,90,30],
	interfaceShift=[0,40,100],
	frontExtSize=[204+(2*2.5)+1,60+(2*2.5)+1,30],
	extRounding=5+2.5,
)
{
	cutClr=0.01;
	difference()
	{
		union()
		{
			//back part
			translate([0,-backExtSize[1]/2,0])
			cube_vround(size=[backExtSize[0],backExtSize[1],backExtSize[2]],rounding=extRounding, center_xy=true);

			//interface back (top) to front (bottom)
			hull()
			{
				translate([0,-backExtSize[1]/2,0])
				cube_vround(size=[backExtSize[0],backExtSize[1],cutClr],rounding=extRounding,center_xy=true);

				translate([interfaceShift[0],interfaceShift[1]-frontExtSize[1]/2,-interfaceShift[2]])
				cube_vround(size=[frontExtSize[0],frontExtSize[1],cutClr],rounding=extRounding,center_xy=true);
			}

			//front part
			translate([interfaceShift[0],interfaceShift[1]-frontExtSize[1]/2,-interfaceShift[2]-frontExtSize[2]])
			cube_vround(size=[frontExtSize[0],frontExtSize[1],frontExtSize[2]+cutClr],rounding=extRounding, center_xy=true);
		}

		union()
		{
			//back part
			translate([0,-backExtSize[1]/2,0])
			cube_vround(size=[backExtSize[0]-wallSz*2,backExtSize[1]-wallSz*2,backExtSize[2]+cutClr],rounding=extRounding-wallSz, center_xy=true);

			//interface back (top) to front (bottom)
			hull()
			{
				translate([0,-backExtSize[1]/2,0])
				cube_vround(size=[backExtSize[0]-wallSz*2,backExtSize[1]-wallSz*2,cutClr],rounding=extRounding-wallSz,center_xy=true);

				translate([interfaceShift[0],interfaceShift[1]-frontExtSize[1]/2,-interfaceShift[2]])
				cube_vround(size=[frontExtSize[0]-wallSz*2,frontExtSize[1]-wallSz*2,cutClr],rounding=extRounding-wallSz,center_xy=true);
			}

			//front part
			translate([interfaceShift[0],interfaceShift[1]-frontExtSize[1]/2,-interfaceShift[2]-frontExtSize[2]-cutClr])
			cube_vround(size=[frontExtSize[0]-wallSz*2,frontExtSize[1]-wallSz*2,frontExtSize[2]+2*cutClr],rounding=extRounding-wallSz, center_xy=true);
		}
	}
}

module PlateHalf
(
	top=false,
	wallSz=2.5,
	backExtSize=[190,90,30],
	interfaceShift=[0,40,100],
	frontExtSize=[204+(2*2.5)+1,60+(2*2.5)+1,30],
	extRounding=5+2.5,
)
{
	i=top?1:0;
	translate([-500*i,-250,-250])
	cube(size=[500,500,500], center=false);
}

difference()
{
	Plate();
	PlateHalf(top=false);
}
