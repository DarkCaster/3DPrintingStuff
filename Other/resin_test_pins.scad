module pins
(
	count=[2,2],
	diff=[4,4],
	height=10,
	diam=1.5,

	base_height=1,
	base_diam=6,
	quality=2,
)
{
	cutClr=0.1;
	for(i=[1:count[0]], j=[1:count[1]])
	{
		translate([i*diff[0], j*diff[1], -cutClr])
		cylinder(d=diam, h=height+cutClr, center=false, $fn=quality*12);

		translate([i*diff[0], j*diff[1], -base_height])
		cylinder(d=base_diam, h=base_height, center=false, $fn=quality*12);
	}
}

pins();
