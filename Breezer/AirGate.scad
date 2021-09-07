use <../OpenSCAD_Modules/MCAD/involute_gears.scad>

module ValvePart
(
	diam=93,
	border=10,
	teethExt=60,
	teethInt=10,
	quality=2,
)
{
	//some constant values
	cutClr=0.1;
	gearsClr=0.2;
	axis_angle=90;
	pressure_angle=20; //one of the recommended standard value

	diamExt=diam+border*2;
	radiusExt=diamExt/2;
	outside_circular_pitch=radiusExt/teethExt*360;

	//taken from bevel_gear_pair example
	radiusInt = teethInt * outside_circular_pitch / 360;
	echo("radiusInt",radiusInt);
	pitch_apex=radiusInt * sin (axis_angle) + (radiusInt * cos (axis_angle) + radiusExt) / tan (axis_angle);
	coneDistance = sqrt (pow (pitch_apex, 2) + pow (radiusExt, 2));

	//calculations taken from bevel_gear module
	pitchAngleExt = asin (radiusExt/coneDistance);
	dedendumExt = 1 / ( teethExt / diamExt ) + gearsClr;
	faceConeDescentExt = dedendumExt * sin (pitchAngleExt);

	//bevel_gear_pair(gear1_teeth=teethExt,gear2_teeth=teethInt,outside_circular_pitch=outside_circular_pitch);
	translate([0,0,faceConeDescentExt])
	bevel_gear(
		number_of_teeth=teethExt,
		cone_distance=coneDistance,
		outside_circular_pitch=outside_circular_pitch,
		pressure_angle=pressure_angle,
		bore_diameter=0,
		gear_thickness=cutClr,
		face_width=border,
		clearance=gearsClr
	);

	bevel_gear(
		number_of_teeth=teethInt,
		cone_distance=coneDistance,
		outside_circular_pitch=outside_circular_pitch,
		pressure_angle=pressure_angle,
		bore_diameter=0,
		face_width=border,
		clearance=gearsClr
	);
}

ValvePart();
