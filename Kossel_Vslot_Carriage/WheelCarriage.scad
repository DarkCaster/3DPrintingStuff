
module CarriageBackHull
(
	wheel_dist,
	carriage_thickness,
	carriage_rounding_diam,
	quality,
)
{
	hull()
	{
		//single wheel from one side
		translate([wheel_dist[0]/2,0,0])
		cylinder(d=carriage_rounding_diam,h=carriage_thickness,center=true,$fn=quality*12);
		//two wheels from another side
		for(i=[-1:2:1])
		translate([-wheel_dist[0]/2, i*wheel_dist[1]/2,0])
		cylinder(d=carriage_rounding_diam,h=carriage_thickness,center=true,$fn=quality*12);
	}
}

module CarriageBackSide
(
	wheel_dist=[59.6,50],
	carriage_thickness=4,
	carriage_rounding_diam=12,
	wheel_clip_diam=[5,8],
	wheel_clip_height=10,
	eccentric_hole_diam=8,
	eccentric_hole_chamfer=0.5,
	central_cut_mult=0.75,
	quality=10,
)
{
	cutClr=0.1;

	tb=wheel_dist[1];
	ta=sqrt((tb/2)^2+wheel_dist[0]^2);
	tr=tb/2*sqrt((2*ta-tb)/(2*ta+tb));
	tmove=wheel_dist[0]/2-tr;

	difference()
	{
		union()
		{
			translate([-tmove,0,0])
			difference()
			{
				translate([tmove,0,-carriage_thickness/2])
				CarriageBackHull(wheel_dist=wheel_dist,
					carriage_thickness=carriage_thickness,
					carriage_rounding_diam=carriage_rounding_diam,
					quality=quality);
				translate([tmove*central_cut_mult,0,-carriage_thickness/2])
				scale([central_cut_mult,central_cut_mult,1])
				CarriageBackHull(wheel_dist=wheel_dist,
					carriage_thickness=carriage_thickness+cutClr,
					carriage_rounding_diam=carriage_rounding_diam,
					quality=quality);
			}

			//single wheel from one side
			translate([wheel_dist[0]/2,0,-carriage_thickness])
			cylinder(d=carriage_rounding_diam,h=carriage_thickness,$fn=quality*12);

			//two wheels' clip base
			for(i=[-1:2:1])
			{
				translate([-wheel_dist[0]/2, i*wheel_dist[1]/2, 0])
				hull()
				{
					translate([0,0,-carriage_thickness])
						cylinder(d=carriage_rounding_diam,h=carriage_thickness,$fn=quality*12);
					cylinder(d=wheel_clip_diam[1],h=wheel_clip_height,$fn=quality*12);
				}
			}
		}
		//two wheels' screw hole
		for(i=[-1:2:1])
		translate([-wheel_dist[0]/2, i*wheel_dist[1]/2, -carriage_thickness-cutClr])
		cylinder(d=wheel_clip_diam[0],h=wheel_clip_height+carriage_thickness+2*cutClr,$fn=quality*12);
		//hole for eccentic spacer
		translate([wheel_dist[0]/2, 0, -carriage_thickness-cutClr])
		cylinder(d=eccentric_hole_diam,h=carriage_thickness+2*cutClr,$fn=quality*12);
		//eccentric hole chamfer
		for(i=[-1:2:1])
		translate([0,0,i>0?-carriage_thickness:0])
		mirror([0,0,i>0?1:0])
		hull()
		{
			translate([wheel_dist[0]/2, 0, 0])
			cylinder(d=eccentric_hole_diam+2*eccentric_hole_chamfer,h=cutClr,$fn=quality*12);
			translate([wheel_dist[0]/2, 0, -eccentric_hole_chamfer])
			cylinder(d=eccentric_hole_diam,h=eccentric_hole_chamfer+cutClr,$fn=quality*12);
		}
	}
}
	}
}

CarriageBackSide();
