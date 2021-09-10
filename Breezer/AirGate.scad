use <../OpenSCAD_Modules/MCAD/involute_gears.scad>

//based on bevel_gear_pair example
function GearRadius(toothCnt,pitch) = toothCnt * pitch / 360;
function GearPitch(toothCnt,radius) = radius / toothCnt * 360;
function ConeDistance(smallGearRadius,bigGearRadius,axisAngle) = sqrt (pow (smallGearRadius * sin (axisAngle) + (smallGearRadius * cos (axisAngle) + bigGearRadius) / tan (axisAngle), 2) + pow (bigGearRadius, 2));

module _SectorFinalize(negative=false)
{
	if(negative)
		intersection_for(i=[0:$children-1]) {children(i);}
	else
		difference()
		{
			children(0);
			if($children>1)
				children([1:$children-1]);
		}
}

module Sector
(
	height=10,
	diam=50,
	angle=90,
	negative=false,
	quality=2,
)
{
	cutClr=0.1;
	radius=diam/2;
	_SectorFinalize(negative)
	{
		cylinder(d=diam,h=height,$fn=12*quality);
		for(cutAngle=[angle/2:180-angle:180-angle/2])
			rotate(a=cutAngle,v=[0,0,1])
				translate([-radius,0,-cutClr])
					cube([diam+cutClr,radius,height+2*cutClr]);
	}
}

module ValvePart
(
	intDiam=93,
	extDiam=120,
	wallWidth=2,
	valveShrink=1,
	valveGap=10,
	shaftExtDiam=8,
	shaftIntDiam=4,
	bigGearToothCnt=60,
	smallGearToothCnt=10,
	pressureAngle=20,
	gearSectorArc=130,
	gearSectorRotate=54,
	gearsClr=0.2,
	quality=2,
)
{
	shaftLen=extDiam/2;
	border=(extDiam-intDiam)/2-2*wallWidth;
	bigGearDiam=extDiam-2*wallWidth;
	bigGearRadius=bigGearDiam/2;

	//some constant values
	cutClr=0.1;
	axisAngle=90;

	pitch=GearPitch(bigGearToothCnt,bigGearRadius);
	smallGearRadius = GearRadius(smallGearToothCnt,pitch);
	coneDistance = ConeDistance(smallGearRadius,bigGearRadius,axisAngle);
	smallGearAngle = asin (smallGearRadius / coneDistance);
	face=border/cos(smallGearAngle);
	//bigGearAngle = axisAngle - smallGearAngle;

	difference()
	{
		union()
		{
			//gear sector
			difference()
			{
				translate([-intDiam/2-wallWidth-border,0,0])
				rotate(a=90,v=[0,1,0])
				bevel_gear(
					number_of_teeth=smallGearToothCnt,
					cone_distance=coneDistance,
					outside_circular_pitch=pitch,
					pressure_angle=pressureAngle,
					bore_diameter=0,
					face_width=face,
					clearance=gearsClr
				);
				translate([-intDiam/2-wallWidth-border-cutClr,0,0])
				rotate(a=gearSectorRotate,v=[1,0,0])
				rotate(a=90,v=[0,1,0])
				Sector(negative=true,diam=smallGearRadius*10,height=border+2*cutClr,angle=gearSectorArc);
			}

			//main shaft
			rotate(a=-90,v=[0,1,0])
			cylinder(d=shaftExtDiam, h=shaftLen, $fn=quality*24);

			//valve cover
			difference()
			{
				cylinder(d1=intDiam, d2=intDiam-2*valveShrink, h=shaftExtDiam/2, $fn=quality*24);

				translate([-intDiam/2-cutClr,0,0])
				rotate(a=90,v=[0,0,1])
				rotate(a=90,v=[1,0,0])
				linear_extrude(height = intDiam/2+2*cutClr)
				polygon(points=[
					[-intDiam/2-cutClr,shaftExtDiam/2+cutClr],
					[-valveGap,shaftExtDiam/2+cutClr],
					[-valveGap,shaftExtDiam/2],
					[-valveGap+valveShrink,0],
					[-valveGap+valveShrink,-cutClr],
					[-intDiam/2-cutClr,-cutClr]]);

				rotate(a=90,v=[0,0,1])
				rotate(a=90,v=[1,0,0])
				linear_extrude(height = intDiam/2+cutClr)
				polygon(points=[
					[-intDiam/2-cutClr,shaftExtDiam/2+cutClr],
					[valveGap,shaftExtDiam/2+cutClr],
					[valveGap,shaftExtDiam/2],
					[valveGap-valveShrink,0],
					[valveGap-valveShrink,-cutClr],
					[-intDiam/2-cutClr,-cutClr]]);
			}
		}

		rotate(a=-90,v=[0,1,0])
		translate([0,0,-cutClr])
		cylinder(d=shaftIntDiam, h=shaftLen+2*cutClr, $fn=quality*24);

		translate([-intDiam,-intDiam,shaftExtDiam/2])
		cube(size=[intDiam*2,intDiam*2,intDiam*2]);
	}
}

ValvePart();

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
	border=(extDiam-intDiam)/2-2*wallWidth;
	bigGearDiam=extDiam-2*wallWidth;
	bigGearRadius=bigGearDiam/2;

	//some constant values
	cutClr=0.1;
	axisAngle=90;

	pitch=GearPitch(bigGearToothCnt,bigGearRadius);
	smallGearRadius = GearRadius(smallGearToothCnt,pitch);
	coneDistance = ConeDistance(smallGearRadius,bigGearRadius,axisAngle);
	bigGearAngle = axisAngle - asin (smallGearRadius / coneDistance);
	face=border/sin(bigGearAngle);

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
			Sector(height=extDiam,diam=extDiam+cutClr*2,angle=gearCutAngle,negative=false,quality=quality);
	}
}

//GateBase();
