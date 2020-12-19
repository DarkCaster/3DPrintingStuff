use <../OpenSCAD_Modules/cube_vround.scad>

module bracket()
{
	adapter_szx=90;
	adapter_holes_szx=79;
	bracket_sz=10;
	difference()
	{
		cube_vround(size=[adapter_szx,bracket_sz,2], round_corners=[true,true,true,true],
			rounding=2, center_xy=true, center_z=false, attach=0, wall_attach=0, quality=2);
		translate([adapter_holes_szx/2,-1,0])
			cylinder(d=3,h=30,center=true,$fn=24);
		translate([-adapter_holes_szx/2,-1,0])
			cylinder(d=3,h=30,center=true,$fn=24);
		translate([0,bracket_sz/2-0.5+0.01,0.5-0.01])
			cube([adapter_szx+1,1,1],center=true);
	}
}

bracket();
