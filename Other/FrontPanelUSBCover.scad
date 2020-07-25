use <../OpenSCAD_Modules/cube_vround.scad>

module front_panel(
width=2,
quality=2,
)
{
	difference()
	{
		cube_vround(size=[58,31,width],rounding=1,center_xy=true,center_z=true,quality=quality);
		translate([0,0.5,0])
			cube_vround(size=[15,16,width+1],rounding=1,center_xy=true,center_z=true,quality=quality);
		translate([0,0.5,0])
			cube_vround(size=[25,25,width],rounding=1,center_xy=true,quality=quality);
	}
}

module front_panel_clip_cut(
width=1,
quality=2,
)
{
	union()
	{
		translate([-20,0.5,-width])
			cube_vround(size=[10,10,width],rounding=1,center_xy=true,quality=quality);
		translate([20,0.5,-width])
			cube_vround(size=[10,10,width],rounding=1,center_xy=true,quality=quality);
	}
}

front_panel();
front_panel_clip_cut();
