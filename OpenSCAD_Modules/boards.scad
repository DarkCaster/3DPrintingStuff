module board(
	size_x=50,
	size_y=50,
	width=1.5,
	hole_diam=3,
	rounding=1,
	hole1=[3,3],
	hole2=[3,3],
	hole3=[3,3],
	hole4=[3,3],
	center_xy=false,
	center_z=false,
	board_color=[0.3,0.5,0.3],
	quality=2, //integer from 1 to infinity
)
{
	assert(size_x>0);
	assert(size_y>0);
	assert(width>0);
	assert(hole_diam>0);
	assert(rounding>0);
	assert(rounding<=size_x/2);
	assert(rounding<=size_y/2);
	assert(quality>0)

	color(board_color)
		translate([center_xy?-size_x/2:0,center_xy?-size_y/2:0,center_z?-width/2:0])
			difference()
			{
				//base
				translate([rounding,rounding])
					resize([size_x,size_y,width])
						minkowski()
						{
							cube([size_x-rounding*2,size_y-rounding*2,width]);
							cylinder(r=rounding,h=width,$fn=12*quality);
						};
				//holes
				if(hole1!=false && len(hole1)==2)
					translate([hole1[0],hole1[1],-width/2])
						cylinder(r=hole_diam/2,h=width*2,$fn=12*quality);
				if(hole2!=false && len(hole2)==2)
					translate([size_x-hole2[0],hole2[1],-width/2])
						cylinder(r=hole_diam/2,h=width*2,$fn=12*quality);
				if(hole3!=false && len(hole3)==2)
					translate([size_x-hole3[0],size_y-hole3[1],-width/2])
						cylinder(r=hole_diam/2,h=width*2,$fn=12*quality);
				if(hole4!=false && len(hole4)==2)
					translate([hole4[0],size_y-hole4[1],-width/2])
						cylinder(r=hole_diam/2,h=width*2,$fn=12*quality);
			}
}

//example
board(size_x=30,size_y=80,hole1=[15,3],hole2=false,center_xy=true,center_z=true,rounding=3);
