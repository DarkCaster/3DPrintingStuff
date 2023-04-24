
module Holder
(
	size=[32,10,5],
	holes_diff=[20,3],
	screw_diam=3.1,
	sensor_size=[4.1,1.6,3.05],
	sensor_shift=1,
	quality=2,
)
{
	cutClr=0.1;
	difference()
	{
		cube(size=size,center=false);
		for(i=[-1,1])
		translate([size[0]/2-holes_diff[0]/2*i, size[1]-holes_diff[1], -cutClr])
		cylinder(d=3.1,h=size[2]+2*cutClr,$fn=12*quality);
		//hole for sensor
		translate([size[0]/2-sensor_size[0]/2,sensor_shift,size[2]-sensor_size[2]])
		cube(size=[sensor_size[0],sensor_size[1],sensor_size[2]+cutClr]);
	}
}


module MagnetHolder
(
	size=[12,6],
	clip_shift=-5,
	car_sz=[60.75,50,4],
	car_shift=-10,
	magnet_shift=-1,
	magnet_size=[5.02,2.02],
	service_hole_diam=2,
	quality=2,
)
{
	cutClr=0.1;
	holder_size=[size[0],car_sz[1]/2+car_shift,size[1]];

	difference()
	{
		translate([-size[0]/2,clip_shift,0])
		cube(size=holder_size,center=false);
		//carriage cut
		translate([0,car_shift,-cutClr])
		linear_extrude(height=car_sz[2]+cutClr)
		polygon(points=[
			[-car_sz[0]/2,0],
			[car_sz[0]/2,car_sz[1]/2],
			[car_sz[0]/2,-car_sz[1]/2]
			]);
		//magnet cut
		translate([-magnet_size[0]/2,holder_size[1]-magnet_size[1]+magnet_shift+clip_shift,-cutClr])
		cube(size=[magnet_size[0],magnet_size[1],magnet_size[0]+cutClr],center=false);

		translate([0,holder_size[1]-magnet_size[1]+magnet_shift+clip_shift,magnet_size[0]-service_hole_diam/2])
		rotate(a=-90,v=[1,0,0])
		cylinder(d=service_hole_diam, h=holder_size[1], center=false, $fn=quality*12);
	}
}

//Holder();
MagnetHolder();
