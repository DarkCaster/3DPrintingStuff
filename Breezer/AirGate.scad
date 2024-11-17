use <../OpenSCAD_Modules/MCAD/involute_gears.scad>
use <../OpenSCAD_Modules/cube_vround.scad>

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
	shaftIntDiam=5,
	bigGearToothCnt=60,
	smallGearToothCnt=10,
	pressureAngle=20,
	gearSectorArc=130,
	gearSectorRotate=54,
	gearsClr=0.2,
	edgeClr=0.1,
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
				cylinder(d1=intDiam-2*edgeClr, d2=intDiam-2*valveShrink-2*edgeClr, h=shaftExtDiam/2, $fn=quality*24);

				translate([-intDiam/2-cutClr,0,0])
				rotate(a=90,v=[0,0,1])
				rotate(a=90,v=[1,0,0])
				linear_extrude(height = intDiam/2+2*cutClr)
				polygon(points=[
					[-intDiam/2-cutClr,shaftExtDiam/2+cutClr],
					[-valveGap+edgeClr,shaftExtDiam/2+cutClr],
					[-valveGap+edgeClr,shaftExtDiam/2],
					[-valveGap+valveShrink+edgeClr,0],
					[-valveGap+valveShrink+edgeClr,-cutClr],
					[-intDiam/2-cutClr,-cutClr]]);

				rotate(a=90,v=[0,0,1])
				rotate(a=90,v=[1,0,0])
				linear_extrude(height = intDiam/2+cutClr)
				polygon(points=[
					[-intDiam/2-cutClr,shaftExtDiam/2+cutClr],
					[valveGap+edgeClr,shaftExtDiam/2+cutClr],
					[valveGap+edgeClr,shaftExtDiam/2],
					[valveGap-valveShrink+edgeClr,0],
					[valveGap-valveShrink+edgeClr,-cutClr],
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

module HNutPocket
(
	nutDiam=6.75,
	nutHeight=3,
	pocketLen=10,
)
{
	m=(nutDiam/2)*sqrt(3)/2;
	union()
	{
		cylinder(d=nutDiam,h=nutHeight,center=true,$fn=6);
		translate([pocketLen/2,0,0])
		cube(size=[pocketLen,m*2,nutHeight],center=true);
	}
}

module VNutPocket
(
	nutDiam=6.75,
	nutHeight=2.8,
	pocketLen=10,
)
{
	m=(nutDiam/2)*sqrt(3)/2;
	rotate(a=90,v=[0,0,1])
		rotate(a=90,v=[0,-1,0])
			union()
			{
				cylinder(d=nutDiam,h=nutHeight,center=true,$fn=6);
				translate([pocketLen/2,0,0])
				cube(size=[pocketLen,m*2,nutHeight],center=true);
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
	intHolesDepth=3,
	intHolesDiam=3.75,
	intHolesExtDiam=8,
	intClipAngle=45,
	intClipHeight=10,
	nutDiam=6.75,
	nutHeight=3,
	gearSectorAngle=30,
	gearsClr=0.2,
	quality=2,
	stub_layer_width=0.2,
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

	clipHoleDiff=sqrt(extDiam*extDiam/2)+2*intHolesExtDiam;
	union()
	{
		//main part
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

				translate([0,0,-baseHeight])
				cube_vround(size=[clipHoleDiff,clipHoleDiff,baseHeight],center_xy=true,rounding=intHolesExtDiam,quality=quality);
			}
			translate([0,0,-baseHeight-cutClr])
				cylinder(d=intDiam, h=baseHeight+2*cutClr, $fn=12*quality);

			for(i=[-1:2:1])
				rotate(a=i*90,v=[0,0,1])
				Sector(height=extDiam,diam=extDiam+cutClr*2,angle=gearCutAngle,negative=false,quality=quality);

			for (i=[0:3])
				rotate(a=90*i+45,v=[0,0,1])
					translate([extDiam/2,0,-baseHeight/2])
						cylinder(d=intHolesDiam,h=baseHeight+cutClr*2,center=true,$fn=12*quality);

			for (i=[0:3])
				rotate(a=90*i+45,v=[0,0,1])
					translate([extDiam/2,0,-intHolesDepth])
						cylinder(d=intHolesExtDiam,h=intHolesDepth+cutClr,$fn=12*quality);
			//trim gear edges
			cylinder(d=intDiam+2*wallWidth,h=intClipHeight+cutClr,$fn=48*quality);
			difference()
			{
				cylinder(d=extDiam,h=intClipHeight,$fn=48*quality);
				translate([0,0,-cutClr])
					cylinder(d=extDiam-2*wallWidth,h=intClipHeight+2*cutClr,$fn=48*quality);
			}
		}
		//top clip part
		difference()
		{
			union()
			{
				difference()
				{
					translate([0,0,-cutClr])
						cylinder(d=extDiam-2*wallWidth,h=intClipHeight+cutClr,$fn=48*quality);
					translate([0,0,-2*cutClr])
						cylinder(d=intDiam+2*wallWidth,h=intClipHeight+3*cutClr,$fn=48*quality);
					for(i=[-1:2:1])
						rotate(a=90+i*90,v=[0,0,1])
						translate([0,0,-3*cutClr])
						Sector(height=extDiam,diam=extDiam+cutClr*4,angle=180-intClipAngle,negative=false,quality=quality);
				}
				for(a=[-intClipAngle/2:intClipAngle:intClipAngle/2],i=[0:1])
					rotate(a=a-i*180,v=[0,0,1])
						translate([0,intDiam/2+(extDiam-intDiam)/4,-cutClr])
							cylinder(d=border,h=intClipHeight+cutClr,$fn=48*quality);
			}
			for(i=[0:1],a=[-intClipAngle/2:intClipAngle:intClipAngle/2])
				rotate(a=a-i*180,v=[0,0,1])
				{
					translate([0,intDiam/2+(extDiam-intDiam)/4,intClipHeight/2])
						rotate(a=a>0?180:0,v=[0,0,1])
							HNutPocket(nutDiam=nutDiam,nutHeight=nutHeight);
					translate([0,intDiam/2+(extDiam-intDiam)/4,0])
						cylinder(d=intHolesDiam,h=intClipHeight+cutClr,$fn=12*quality);
				}
		}
		//stub layer at the bottom screw holes
		for (i=[0:3])
			rotate(a=90*i+45,v=[0,0,1])
				translate([extDiam/2,0,-baseHeight])
					cylinder(d=intHolesDiam*2,h=stub_layer_width,center=false,$fn=12*quality);
	}
}

module GateClip1
(
	intDiam=93,
	extDiam=120,
	wallWidth=2,
	clipHeight=16,
	shaftClipPos=[67,-7,12],
	shaftIntDiam=5,
	shaftExtDiam=8,
	lockSize=[150,30],
	lockRounding=3,
	lockCutSize=[12,25],
	nutDiam=6.75,
	nutHeight=3,
	intHolesDiam=3.75,
	guideAngle=70,
	gearSectorAngle=28,
	gearSectorHeight=6,
	valveShrink=1,
	valveEdgeClr=0.1,
	gearsClr=0.2,
	guideClr=0.2,
	quality=2,
)
{
	cutClr=0.1;
	border=(extDiam-intDiam)/2-2*wallWidth;

	difference()
	{
		//ring base
		union()
		{
			cylinder(d=extDiam,h=clipHeight,$fn=12*quality);
			cube_vround(size=[lockSize[0],lockSize[1],clipHeight],center_xy=true,rounding=lockRounding);
		}
		//ring internal cuts
		translate([0,0,-cutClr])
			cylinder(d=intDiam-2*valveShrink+2*valveEdgeClr,h=clipHeight+2*cutClr,$fn=quality*24);
		translate([0,0,-cutClr])
			cylinder(d=intDiam+2*valveEdgeClr,h=shaftClipPos[2]+2*cutClr,$fn=quality*24);
		translate([0,0,shaftClipPos[2]])
			cylinder(d1=intDiam+2*valveEdgeClr,d2=intDiam-2*valveShrink+2*valveEdgeClr,h=shaftExtDiam/2,$fn=quality*24);
		translate([0,0,clipHeight/2])
		intersection()
		{
			cube(size=[intDiam+2*valveEdgeClr,lockCutSize[1],clipHeight+2*cutClr],center=true);
			cylinder(d=intDiam+2*valveEdgeClr,h=clipHeight+2*cutClr,center=true,$fn=quality*24);
		}

		//cuts for gears
		difference()
		{
			translate([0,0,-cutClr])
				cylinder(d=gearsClr+extDiam-2*wallWidth,h=gearSectorHeight+cutClr,$fn=48*quality);
			translate([0,0,-2*cutClr])
				cylinder(d=intDiam+2*wallWidth-gearsClr,h=gearSectorHeight+3*cutClr,$fn=48*quality);
			for(i=[-1:2:1])
				rotate(a=i*90,v=[0,0,1])
				translate([0,0,-3*cutClr])
				Sector(height=extDiam,diam=extDiam,angle=180-2*gearSectorAngle,negative=false,quality=quality);
		}
		for(a=[-gearSectorAngle:2*gearSectorAngle:gearSectorAngle],i=[0:1])
			rotate(a=a-i*180+90,v=[0,0,1])
				translate([0,intDiam/2+(extDiam-intDiam)/4,-cutClr])
					cylinder(d=border+gearsClr,h=gearSectorHeight+cutClr,$fn=48*quality);

		//cuts for guides
		difference()
		{
			translate([0,0,-cutClr])
				cylinder(d=guideClr+extDiam-2*wallWidth,h=clipHeight+2+cutClr,$fn=48*quality);
			translate([0,0,-2*cutClr])
				cylinder(d=intDiam+2*wallWidth-guideClr,h=clipHeight+4*cutClr,$fn=48*quality);
			for(i=[-1:2:1])
				rotate(a=i*90+90,v=[0,0,1])
				translate([0,0,-3*cutClr])
				Sector(height=extDiam,diam=extDiam,angle=180-guideAngle,negative=false,quality=quality);
		}
		for(a=[-guideAngle/2:guideAngle:guideAngle/2],i=[0:1])
			rotate(a=a-i*180,v=[0,0,1])
				translate([0,intDiam/2+(extDiam-intDiam)/4,-cutClr])
					cylinder(d=border+guideClr,h=clipHeight+2*cutClr,$fn=48*quality);

		//cuts for valves' gears
		for(i=[-1:2:1])
		translate([i*(intDiam/2+wallWidth-gearsClr/2+lockCutSize[0]/2),0,-cutClr])
			cube_vround(size=[lockCutSize[0],lockCutSize[1],clipHeight+2*cutClr],center_xy=true,rounding=lockRounding,round_corners=[i>0,i>0,i<0,i<0]);

		//nut holes
		for(i=[-1:2:1])
		translate([i*shaftClipPos[0],i*shaftClipPos[1],shaftClipPos[2]])
			VNutPocket(nutDiam=nutDiam,nutHeight=nutHeight);

		//shaft clip holes
		for(i=[-1:2:1])
		translate([i*shaftClipPos[0],0,shaftClipPos[2]])
		rotate(a=i*90,v=[1,0,0])
		cylinder(d=intHolesDiam,h=lockSize[1]/2+cutClr,center=false,$fn=quality*24);

		//main shaft hole
		translate([0,0,shaftClipPos[2]])
		rotate(a=-90,v=[0,1,0])
		cylinder(d=shaftIntDiam,h=lockSize[0]+2*cutClr,center=true,$fn=quality*24);

		//shaft outer shell
		translate([0,0,shaftClipPos[2]])
		rotate(a=-90,v=[0,1,0])
		cylinder(d=shaftExtDiam,h=intDiam+2*wallWidth+2*cutClr,center=true,$fn=quality*24);

		//top cut for main shaft
		translate([0,0,shaftClipPos[2]+(clipHeight-shaftClipPos[2]+cutClr)/2])
		cube(size=[intDiam+2*wallWidth+2*cutClr,shaftExtDiam,clipHeight-shaftClipPos[2]+cutClr],center=true);
	}
}

module GateClip2
(
	intDiam=93,
	extDiam=120,
	wallWidth=2,
	baseHeight=3.4,
	clipHeight=6,
	intHolesDiam=3.75,
	intClipAngle=45,
	quality=2,
	stub_layer_width=0.2,
)
{
	cutClr=0.1;
	border=(extDiam-intDiam)/2-2*wallWidth;

	union()
	{

	difference()
	{
		union()
		{
			translate([0,0,-baseHeight])
			difference()
			{
				//ring base
				cylinder(d=extDiam,h=baseHeight,$fn=12*quality);
				//ring internal cuts
				translate([0,0,-cutClr])
					cylinder(d=intDiam,h=baseHeight+2*cutClr,$fn=quality*24);
			}
			difference()
			{
				translate([0,0,-cutClr])
					cylinder(d=extDiam-2*wallWidth,h=clipHeight+cutClr,$fn=48*quality);
				translate([0,0,-2*cutClr])
					cylinder(d=intDiam+2*wallWidth,h=clipHeight+3*cutClr,$fn=48*quality);
				for(i=[-1:2:1])
					rotate(a=90+i*90,v=[0,0,1])
					translate([0,0,-3*cutClr])
					Sector(height=extDiam,diam=extDiam+cutClr*4,angle=180-intClipAngle,negative=false,quality=quality);
			}
			for(a=[-intClipAngle/2:intClipAngle:intClipAngle/2],i=[0:1])
				rotate(a=a-i*180,v=[0,0,1])
					translate([0,intDiam/2+(extDiam-intDiam)/4,-cutClr])
						cylinder(d=border,h=clipHeight+cutClr,$fn=48*quality);
		}
		for(i=[0:1],a=[-intClipAngle/2:intClipAngle:intClipAngle/2])
			rotate(a=a-i*180,v=[0,0,1])
				translate([0,intDiam/2+(extDiam-intDiam)/4,-baseHeight-cutClr])
					cylinder(d=intHolesDiam,h=clipHeight+baseHeight+2*cutClr,$fn=12*quality);
	}

	translate([0,0,-baseHeight])
	difference()
	{
		//ring base
		cylinder(d=extDiam,h=stub_layer_width,$fn=12*quality);
		//ring internal cuts
		translate([0,0,-cutClr])
			cylinder(d=intDiam,h=stub_layer_width+2*cutClr,$fn=quality*24);
	}

	}
}

GateBase();

//color([1,1,1,0.25])
rotate(a=12,v=[0,0,1])
GateClip1();

translate([0,0,12])
rotate(a=12,v=[0,0,1])
ValvePart();

rotate(a=12,v=[0,0,1])
translate([0,0,16])
rotate(a=180,v=[1,0,0])
GateClip2();