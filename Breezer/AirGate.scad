use <../OpenSCAD_Modules/MCAD/involute_gears.scad>

//based on bevel_gear_pair example
function GearRadius(toothCnt,pitch) = toothCnt * pitch / 360;
function GearPitch(toothCnt,radius) = radius / toothCnt * 360;
function ConeDistance(smallGearRadius,bigGearRadius,axisAngle) = sqrt (pow (smallGearRadius * sin (axisAngle) + (smallGearRadius * cos (axisAngle) + bigGearRadius) / tan (axisAngle), 2) + pow (bigGearRadius, 2));

module Sector
(
	height=10,
	diam=50,
	angle=60,
	quality=2,
)
{
	cutClr=0.1;
	radius=diam/2;
	difference()
	{
		cylinder(d=diam,h=height,$fn=12*quality);
		for(cutAngle=[angle/2:180-angle:180-angle/2])
			rotate(a=cutAngle,v=[0,0,1])
				translate([-radius,0,-cutClr])
					cube([diam+cutClr,radius,height+2*cutClr]);
	}
}

module GateBase
(
	intDiam=93,
	extDiam=120,
	wallWidth=2,
	bigGearToothCnt=60,
	smallGearToothCnt=10,
	pressureAngle=20,
	baseHeight=4,
	gearSectorAngle=54,
	gearsClr=0.2,
	quality=2,
)
{
	gearCutAngle=180-gearSectorAngle;
	face=(extDiam-intDiam)/2-2*wallWidth;
	bigGearDiam=extDiam-2*wallWidth;
	bigGearRadius=bigGearDiam/2;

	//some constant values
	cutClr=0.1;
	axisAngle=90;

	pitch=GearPitch(bigGearToothCnt,bigGearRadius);
	smallGearRadius = GearRadius(smallGearToothCnt,pitch);
	coneDistance = ConeDistance(smallGearRadius,bigGearRadius,axisAngle);

	//calculations taken from bevel_gear module
	faceConeDescentExt = (1 / ( bigGearToothCnt / bigGearDiam ) + gearsClr) * (bigGearRadius/coneDistance);

	render() //preview is too slow!
	difference()
	{
		union()
		{
			
			translate([0,0,faceConeDescentExt])
				bevel_gear(
					number_of_teeth=bigGearToothCnt,
					cone_distance=coneDistance,
					outside_circular_pitch=pitch,
					pressure_angle=pressureAngle,
					bore_diameter=0,
					gear_thickness=cutClr,
					face_width=face,
					clearance=gearsClr
				);
			translate([0,0,-baseHeight])
				cylinder(d=extDiam, h=baseHeight, $fn=12*quality);
		}
		translate([0,0,-baseHeight-cutClr])
			cylinder(d=intDiam, h=baseHeight+2*cutClr, $fn=12*quality);
			
		for(i=[-1:2:1])
			rotate(a=i*90,v=[0,0,1])
			Sector(height=extDiam,diam=extDiam+cutClr*2,angle=gearCutAngle,quality=quality);
	}
}

GateBase();

/*bevel_gear(
		number_of_teeth=smallGearToothCnt,
		cone_distance=coneDistance,
		outside_circular_pitch=pitch,
		pressure_angle=pressureAngle,
		bore_diameter=0,
		face_width=face,
		clearance=gearsClr
	);*/