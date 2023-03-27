module Insert
(
	inner_diam=3,
	outer_diam=5,
	insert_height=10,
	base_height=1,
	base_diam=8,
	quality=2,
)
{
	cutClr=0.01;
	difference()
	{
		union()
		{
			translate([0,0,-cutClr])
			cylinder(d=outer_diam,h=insert_height+cutClr,$fn=quality*12);
			translate([0,0,-base_height])
			cylinder(d=base_diam,h=base_height,$fn=quality*12);
		}
		translate([0,0,-base_height-cutClr])
		cylinder(d=inner_diam,h=base_height+insert_height+2*cutClr,$fn=quality*12);
	}
}

module Spacer
(
	inner_diam=3,
	base_diam=8,
	spacer_height=4,
	quality=2,
)
{
	cutClr=0.01;
	difference()
	{
		cylinder(d=base_diam,h=spacer_height,$fn=quality*12);
		translate([0,0,-cutClr])
		cylinder(d=inner_diam,h=spacer_height+2*cutClr,$fn=quality*12);
	}
}

Insert();

translate([10,0])
Spacer();