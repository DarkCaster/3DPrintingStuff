module cube_vround(
	size=[10,10,10],
	rounding=3,
	center_xy=false,
	center_z=false,
	attach=0,
	quality=2, //integer from 1 to infinity
)
{
	assert(len(size)==3);
	assert(rounding>0);
	assert(rounding<size[0]/2);
	assert(rounding<size[1]/2);
	assert(quality>0);
	assert(attach>=0);

	translate([center_xy?-size[0]/2:0,center_xy?-size[1]/2:0,center_z?-size[2]/2:0])
		translate([rounding,rounding,-attach])
			resize([size[0],size[1],size[2]+attach])
				minkowski()
				{
					cube([size[0]-rounding*2,size[1]-rounding*2,size[2]]);
					cylinder(r=rounding,h=size[2],$fn=12*quality);
				};
}

//example
cube_vround(size=[10,20,2],rounding=2,center_xy=true,center_z=true);
