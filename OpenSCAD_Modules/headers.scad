module headers(
	cols=1,
	rows=1,
	center=false,
	step=2.54,
	pin_width=0.65,
	pin_height=9,
	pin_depth=3,
	pin_color=[0.9,0.75,0.4],
	spacer_height=2.5,
	spacer_color=[0.2,0.2,0.6],
	board_width=1.5,
	board_center=false,
)
{
	assert(rows>0);
	assert(cols>0);
	assert(step>0);
	assert(pin_width>0);
	assert(pin_height>0);
	assert(pin_depth>0);
	assert(spacer_height>0);
	assert(board_width>0);

	lim_x=cols-1;
	lim_y=rows-1;
	move_all=center?[-lim_x*step/2,-lim_y*step/2]:[0,0];
	move_pin_z=board_center?(pin_height-pin_depth)/2+board_width/2:(pin_height-pin_depth)/2;
	move_spacer_z=board_center?spacer_height/2+board_width/2:spacer_height/2;

	translate(move_all)
	{
		for(x=[0:lim_x],y=[0:lim_y])
			translate([step*x, step*y])
			{
				//pin
				color(pin_color)
					translate([0,0,move_pin_z])
						cube([pin_width,pin_width,pin_height+pin_depth],center = true);
				//spacer
				color(spacer_color)
					translate([0,0,move_spacer_z])
						resize([step,step,spacer_height])
							rotate([0,0,360/16])
								cylinder($fn=8,center=true);
			}
	}
}

//examples

translate([0,0,20])
//do not center pins (default, z axis will go thru the center of first pin)
	headers(cols=10,rows=2);

translate([0,0,0])
//center pins for x+y planes only (z axis will go thru center of central pin)
	headers(cols=5,rows=3,center=true);

translate([20,0,0])
{
	//lift pins up
	//so spacer (blue part) will be on top of the board (cube) that is aligned at center
	headers(cols=5,rows=3,center=true,board_center=true,board_width=2);
	cube([15,10,2],center=true);
}
