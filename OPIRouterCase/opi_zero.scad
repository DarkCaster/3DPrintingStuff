use <../OpenSCAD_Modules/headers.scad>
use <../OpenSCAD_Modules/boards.scad>

module orange_pi_zero(center=false)
{
	translate([center?0:48/2,center?0:46/2,center?0:1.5/2])
	{
		board(size_x=48,size_y=46,center_xy=true,center_z=true);
		//connectors
		color([0.75,0.75,0.75])
		{
			translate([48/2-15.5/2+3,0,13/2+1.5/2])
				cube([15.5,16,13],center = true);
			translate([48/2-14/2+4,46/2-9.5,13/2+1.5/2])
				cube([14,6,13],center = true);
			translate([-48/2+2.5,46/2-9.5,3/2+1.5/2])
				cube([5.5,7.5,3],center=true);
			translate([-48/2+15/2,-46/2+16.5,-1-1.5/2])
				cube([15,14.6,2], center=true);
		}
		//sd card
		color([0.25,0.25,0.25])
			translate([-48/2+15/2-2.5,-46/2+15.1,-1.4-1.5/2])
				cube([15,11,1], center=true);
		//headers
		{
			translate([-6*2.54,46/2-2.54/2])
				headers(cols=13,board_center=true);
			translate([-6*2.54,-46/2+2.54/2])
				headers(cols=13,rows=2,board_center=true);
			translate([48/2-2.54*2-2.54/2,-46/2+9.5])
				headers(cols=3,board_center=true);
		}
	}
}

orange_pi_zero();
//orange_pi_zero(center=true);
