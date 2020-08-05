use <../OpenSCAD_Modules/cube_vround.scad>

module fan_shroud_1 (
	quality=2, //integer from 1 to infinity
)
{
	cube_vround(
		size=[147,77,0.4],
		rounding=10+4,
		attach=0,
		center_xy=true,quality=quality);
}

module fan_shroud_1_cut (
	quality=2, //integer from 1 to infinity
)
{
	color([0.5,0.5,0.5])
		cube_vround(
		size=[147-4*2,77-4*2,0.5],
		rounding=10,
		attach=0.1,
		center_xy=true,quality=quality);
}

module fan_shroud_2 (
	quality=2, //integer from 1 to infinity
)
{
	cube_vround(
		size=[147,94,0.4],
		rounding=10+4,
		attach=0,
		center_xy=true,quality=quality);
}

module fan_shroud_2_cut (
	quality=2, //integer from 1 to infinity
)
{
	color([0.5,0.5,0.5])
		cube_vround(
		size=[147-4*2,94-4*2,0.5],
		rounding=10,
		attach=0.1,
		center_xy=true,quality=quality);
}

//fan_shroud_1();
//fan_shroud_1_cut();

fan_shroud_2();
fan_shroud_2_cut();