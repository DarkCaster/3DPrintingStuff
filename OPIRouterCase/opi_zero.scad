use <../OpenSCAD_Modules/headers.scad>
use <../OpenSCAD_Modules/boards.scad>

function opi_board_width() = 1.5;
function opi_height() = 14.5+opi_board_width();
function opi_szx() = 48;
function opi_szy() = 46;
function opi_size() = [opi_szx(),opi_szy(),opi_height()];
function opi_holes() = [[2.5,3],[3,3],[3,3],[2.5,3]];

module orange_pi_zero(
center_xy=false,
center_z=false,
)
{
	translate([center_xy?0:opi_szx()/2,center_xy?0:opi_szy()/2,center_z?0:opi_board_width()/2])
	{
		union()
		{
		board(size_x=opi_szx(),
			size_y=opi_szy(),
			width=opi_board_width(),
			hole1=opi_holes()[0],
			hole2=opi_holes()[1],
			hole3=opi_holes()[2],
			hole4=opi_holes()[3],
			center_xy=true,
			center_z=true);
		//connectors
		color([0.75,0.75,0.75])
		{
			translate([opi_szx()/2-15.5/2+3,0,13/2+opi_board_width()/2])
				cube([15.5,16,13],center = true);
			translate([opi_szx()/2-14/2+4,opi_szy()/2-9.5,13/2+opi_board_width()/2])
				cube([14,6,13],center = true);
			translate([-opi_szx()/2+2.5,opi_szy()/2-9.5,3/2+opi_board_width()/2])
				cube([5.5,7.5,3],center=true);
			translate([-opi_szx()/2+15/2,opi_szy()/2-34+14.6/2,-1-opi_board_width()/2])
				cube([15,14.6,2], center=true);
		}
		//sd card
		color([0.25,0.25,0.25])
			translate([-opi_szx()/2+15/2-2.5,opi_szy()/2-34+14.6/2-1,-1.4-opi_board_width()/2])
				cube([15,11,1], center=true);
		//headers
		{
			translate([-6*2.54,opi_szy()/2-2.54/2])
				headers(cols=13,pin_depth=1.5+opi_board_width(),
					board_width=opi_board_width(),board_center=true);
			translate([-6*2.54,-opi_szy()/2+2.54/2])
				headers(cols=13,pin_depth=1.5+opi_board_width(),rows=2,
					board_width=opi_board_width(),board_center=true);
			translate([opi_szx()/2-2.54*2-2.54/2,-opi_szy()/2+9.5])
				headers(cols=3,pin_depth=1.5+opi_board_width(),
					board_width=opi_board_width(),board_center=true);
		}
		}
	}
}

//orange_pi_zero();
orange_pi_zero(center_xy=true);
//orange_pi_zero(center_xy=true,center_z=true);