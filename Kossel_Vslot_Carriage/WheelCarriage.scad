use <../OpenSCAD_Modules/cube_vround.scad>

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

module CarriageFrontHull
(
	wheel_dist,
	carriage_thickness,
	carriage_rounding_diam,
	payload_mount_diam,
	payload_mount_size,
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
		//payload mount points
		for(i=[-1:2:1],j=[-1:2:1])
		{
			translate([i*payload_mount_size[0]/2,j*payload_mount_size[1]/2,0])
			cylinder(d=payload_mount_diam,h=carriage_thickness,$fn=quality*12,center=true);
		}
	}
}

module NutPocket
(
	nut_diam=6.75,
	pocket_len=100,
)
{
	m=(nut_diam/2)*sqrt(3)/2;
	cylinder(d=nut_diam,h=pocket_len,center=false,$fn=6);
}

module CarriageBackSide
(
	wheel_dist=[60.75,50],
	carriage_thickness=4,
	carriage_rounding_diam=12,
	wheel_clip_diam=[5.2,8],
	wheel_clip_height=5,
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

module CarriageFrontSide
(
	wheel_dist=[60.75,50],
	carriage_thickness=4,
	carriage_rounding_diam=12,
	wheel_clip_diam=[5.2,8],
	wheel_clip_height=5,
	eccentric_hole_diam=8,
	eccentric_hole_chamfer=0.5,
	central_cut_mult=0.75,
	payload_handles_width=4,
	payload_mount_size=[40,30],
	payload_mount_diam=10,
	payload_screw_diam=3.25,
	nut_diam=6.5,
	nut_pocket_depth=2,
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
			//main carriage triangle
			translate([-tmove,0,0])
			difference()
			{
				translate([tmove,0,carriage_thickness/2])
				CarriageFrontHull(wheel_dist=wheel_dist,
					carriage_thickness=carriage_thickness,
					carriage_rounding_diam=carriage_rounding_diam,
					payload_mount_diam=payload_mount_diam,
					payload_mount_size=payload_mount_size,
					quality=quality);
				translate([tmove*central_cut_mult,0,carriage_thickness/2])
				scale([central_cut_mult,central_cut_mult,1])
				CarriageFrontHull(wheel_dist=wheel_dist,
					carriage_thickness=carriage_thickness+cutClr,
					carriage_rounding_diam=carriage_rounding_diam,
					payload_mount_diam=payload_mount_diam,
					payload_mount_size=payload_mount_size,
					quality=quality);
			}
			//single wheel from one side
			translate([wheel_dist[0]/2,0,0])
			cylinder(d=carriage_rounding_diam,h=carriage_thickness,$fn=quality*12);
			//two wheels' clip base
			for(i=[-1:2:1])
			{
				translate([-wheel_dist[0]/2, i*wheel_dist[1]/2, 0])
				hull()
				{
					cylinder(d=carriage_rounding_diam,h=carriage_thickness,$fn=quality*12);
					translate([0,0,-wheel_clip_height])
					cylinder(d=wheel_clip_diam[1],h=wheel_clip_height,$fn=quality*12);
				}
			}
			//payload mounts
			for(i=[-1:2:1],j=[-1:2:1])
			{
				translate([i*payload_mount_size[0]/2,j*payload_mount_size[1]/2,carriage_thickness/2])
				cylinder(d=payload_mount_diam,h=carriage_thickness,$fn=quality*12,center=true);
			}
			//payload vertical handles
			intersection()
			{
				translate([0,0,carriage_thickness/2])
				CarriageFrontHull(wheel_dist=wheel_dist,
					carriage_thickness=carriage_thickness,
					carriage_rounding_diam=carriage_rounding_diam,
					payload_mount_diam=payload_mount_diam,
					payload_mount_size=payload_mount_size,
					quality=quality);
				for(i=[-1:2:1])
				{
					translate([i*payload_mount_size[0]/2,0,carriage_thickness/2])
					cube(size=[payload_handles_width,wheel_dist[1]*2,carriage_thickness],center=true);
				}
			}
			//payload horisontal handles
			intersection()
			{
				translate([0,0,carriage_thickness/2])
				CarriageFrontHull(wheel_dist=wheel_dist,
					carriage_thickness=carriage_thickness,
					carriage_rounding_diam=carriage_rounding_diam,
					payload_mount_diam=payload_mount_diam,
					payload_mount_size=payload_mount_size,
					quality=quality);
				for(i=[-1:2:1])
				{
					translate([0,i*payload_mount_size[1]/2,carriage_thickness/2])
					cube(size=[wheel_dist[0]*2,payload_handles_width,carriage_thickness],center=true);
				}
			}
		}
		//two wheels' screw hole
		for(i=[-1:2:1])
		translate([-wheel_dist[0]/2, i*wheel_dist[1]/2, -wheel_clip_height-cutClr])
		cylinder(d=wheel_clip_diam[0],h=wheel_clip_height+carriage_thickness+2*cutClr,$fn=quality*12);
		//hole for eccentic spacer
		translate([wheel_dist[0]/2, 0, -cutClr])
		cylinder(d=eccentric_hole_diam,h=carriage_thickness+2*cutClr,$fn=quality*12);
		//eccentric hole chamfer
		for(i=[-1:2:1])
		translate([0,0,i>0?0:carriage_thickness])
		mirror([0,0,i>0?1:0])
		hull()
		{
			translate([wheel_dist[0]/2, 0, 0])
			cylinder(d=eccentric_hole_diam+2*eccentric_hole_chamfer,h=cutClr,$fn=quality*12);
			translate([wheel_dist[0]/2, 0, -eccentric_hole_chamfer])
			cylinder(d=eccentric_hole_diam,h=eccentric_hole_chamfer+cutClr,$fn=quality*12);
		}
		//payload mount screw holes and nuts holes
		for(i=[-1:2:1],j=[-1:2:1])
		{
			translate([i*payload_mount_size[0]/2,j*payload_mount_size[1]/2,carriage_thickness/2])
			cylinder(d=payload_screw_diam,h=carriage_thickness+2*cutClr,$fn=quality*12,center=true);
			translate([i*payload_mount_size[0]/2,j*payload_mount_size[1]/2,-cutClr])
			NutPocket(nut_diam=nut_diam,pocket_len=nut_pocket_depth+cutClr);
		}
	}
}

module EssentricHalf
(
	eccentric_clip_height=4,
	eccentric_clip_diam=7.8,
	eccentric_ext_diam=8,
	eccentric_int_diam=5,
	eccentric_shift=0.6,
	eccentric_height=5,
	handle_diam=12,
	handle_width=20,
	handle_height=4,
	handle_rounding=2,
	handle_screw_size=3.2,
	handle_screw_pos=[15,3],
	mirror=false,
	quality=10,
)
{
	cutClr=0.1;

	mirror([0,0,mirror?1:0])
	difference()
	{
		union()
		{
			//clip
			translate([0,0,-eccentric_clip_height])
			cylinder(d=eccentric_clip_diam, h=eccentric_clip_height+cutClr, $fn=quality*12);
			//handle
			cylinder(d=handle_diam, h=handle_height, $fn=quality*12);
			translate([0,-handle_diam/2,0])
			cube_vround(size=[handle_width,handle_diam,handle_height],rounding=handle_rounding,round_corners=[true,true,false,false],center_z=false,quality=quality);
			//external clip
			cylinder(d=eccentric_ext_diam, h=eccentric_height, $fn=quality*12);
		}
		//eccentric hole
		translate([0,eccentric_shift,-cutClr-eccentric_clip_height])
		cylinder(d=eccentric_int_diam, h=eccentric_height+eccentric_clip_height+2*cutClr, $fn=quality*12);
		//screw holes
		translate([handle_screw_pos[0],handle_screw_pos[1],-cutClr])
		cylinder(d=handle_screw_size, h=eccentric_height+2*cutClr, $fn=quality*12);
		translate([handle_screw_pos[0],-handle_screw_pos[1],-cutClr])
		cylinder(d=handle_screw_size, h=eccentric_height+2*cutClr, $fn=quality*12);
	}
}

//bottom half
CarriageBackSide();
translate([60.75/2,0,0])
EssentricHalf();

//top half
translate([0,0,15])
{
	CarriageFrontSide();
	translate([60.75/2,0,0])
	EssentricHalf(mirror=true);
}
