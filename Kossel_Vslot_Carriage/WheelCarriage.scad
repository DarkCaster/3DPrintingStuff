use <../OpenSCAD_Modules/cube_vround.scad>
use <gt2.scad>

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
	eccentric_shift=0.4,
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

module GT2Belt
(
	length=10,
	h=6,
	width_clearance=0.00,
	center=false
)
{
	cutClr=0.01;
	offset=0.254;
	width=0.63;
	translate([center?-length/2:0,0,center?-h/2:0])

	if(width_clearance>0)
	{
		union()
		{
			//orig belt, with offfset
			translate([0,offset,0])
			gt2_belt(length=length,h=h,center=false);
			//add extra width
			translate([0,width-cutClr,0])
			cube(size=[length,width_clearance+cutClr,h],center=false);
		}
	}
	else
	{
		difference()
		{
			//orig belt, with offfset
			translate([0,offset,0])
			gt2_belt(length=length,h=h,center=false);
			//remove some width
			translate([-cutClr,width-(-width_clearance),-cutClr])
			cube(size=[length+2*cutClr,cutClr+(-width_clearance),h+2*cutClr],center=false);
		}
	}
}

module EffectorArmsMount
(
	mount_thickness=4,
	payload_handles_width=4,
	payload_handles_frame_width=5,
	payload_mount_size=[40,30],
	payload_mount_diam=10,
	payload_mount_spot_extra_height=5,
	payload_screw_diam=3.25,
	payload_screw_top_diam=7,
	payload_triangles_cut=[60.75,16,-1],
	clip_length_int=30, //1 extra mm kept for 2x0.5mm washers
	clip_length_ext=41,
	clip_pos=[90,5,13,2.5],
	clip_cut=[30,13.5, 17,19, 8,22, 5,31], //len1,diam1,len2,diam2,len3,diam3,
	shaft_diam=3.12,
	droplet_cut=0.4,
	joint_face_size=9,
	belt_clip_size=[12,6+0.5+2], //clip height: 6mm + 0.5 edge clearance + 2mm extra clearance
	belt_clip_shift=6,
	belt_cut_par=[6,0.1,3,1.6], //6mm belt width, belt-base thickness + 0.1mm, side cut x, side cut y
	belt_cut2_par=[8,4],
	belt_cut3_par=[6,6],
	tie_clip_size=[1,3,1.175],
	use_brim=true,
	corners_brim_par=[26,0.4,-3,-12],
	center_brim_par=[10,4,0.4],
	quality=10,
)
{
	cutClr=0.01;

	belt_clip_length=payload_mount_size[1]+payload_handles_width;
	belt_clip_height=belt_clip_size[1]+mount_thickness;

	difference()
	{
		union()
		{
			//payload mounts
			for(i=[-1:2:1],j=[-1:2:1])
			{
				extra_height=j<0?payload_mount_spot_extra_height:0;
				translate([i*payload_mount_size[0]/2,j*payload_mount_size[1]/2,-mount_thickness/2+extra_height/2])
				cylinder(d=payload_mount_diam,h=mount_thickness+extra_height,$fn=quality*12,center=true);
			}
			//connect mount points with handles
			for(i=[-1:2:1])
			{
				translate([i*payload_mount_size[0]/2,0,-mount_thickness/2])
				cube(size=[payload_handles_width,payload_mount_size[1],mount_thickness],center=true);
				translate([0,i*payload_mount_size[1]/2,-mount_thickness/2])
				cube(size=[payload_mount_size[0],payload_handles_width,mount_thickness],center=true);
			}
			//arm-clips hub
			translate([0,clip_pos[3],0])
			hull()
			{
				translate([0,-payload_mount_size[1]/2,-mount_thickness/2])
				cube([clip_length_ext+clip_pos[0],joint_face_size,mount_thickness],center=true);

				translate([0,-clip_pos[1]-payload_mount_size[1]/2,clip_pos[2]])
				rotate(a=90,v=[0,1,0])
				cylinder(d=joint_face_size,h=clip_length_ext+clip_pos[0],center=true,$fn=quality*10);
			}
			//extra stiffness triangles
			clip_triangle_top=payload_mount_size[1]/2+payload_handles_width/2;
			clip_triangle_bottom=-payload_mount_size[1]/2+joint_face_size/2+clip_pos[3];
			clip_triangle_center=payload_mount_size[0]/2;
			clip_triangle_side=clip_pos[0]/2+clip_length_ext/2;
			translate([0,0,-mount_thickness/2])
			for(i=[-1:2:1])
			linear_extrude(height=mount_thickness,center=true)
			polygon(points=[
				[i*clip_triangle_center,clip_triangle_top],
				[i*clip_triangle_center,clip_triangle_bottom],
				[i*clip_triangle_center,clip_triangle_bottom-cutClr],
				[i*clip_triangle_side,clip_triangle_bottom-cutClr],
				[i*clip_triangle_side,clip_triangle_bottom],
			]);
			//center X frame
			for(i=[-1:2:1])
			{
				hull()
				{
					translate([-payload_mount_size[0]/2,i*payload_mount_size[1]/2,-mount_thickness/2])
					cylinder(d=payload_handles_frame_width,h=mount_thickness,center=true,$fn=quality*10);
					translate([payload_mount_size[0]/2,-i*payload_mount_size[1]/2,-mount_thickness/2])
					cylinder(d=payload_handles_frame_width,h=mount_thickness,center=true,$fn=quality*10);
				}
			}
			//belt clip base
			translate([-belt_clip_shift,0,belt_clip_height/2-mount_thickness])
			cube(size=[belt_clip_size[0],belt_clip_length,belt_clip_height],center=true);
			//corners brim at clip side - for better plate adhesion here to make sure clip not bent beacuse of bending corners
			if(use_brim)
			{
				for(i=[-1:2:1])
				translate([i*(clip_pos[0]/2+clip_length_ext/2+corners_brim_par[2]),corners_brim_par[3],-mount_thickness])
				cylinder(d=corners_brim_par[0],h=corners_brim_par[1],$fn=quality*10,center=false);

				translate([0,-center_brim_par[0]/2-payload_mount_size[1]/2,-mount_thickness])
				cube_vround(size=[clip_pos[0]+clip_length_ext,center_brim_par[0],center_brim_par[2]],rounding=center_brim_par[1],quality=quality,center_xy=true);
			}
		}
		//center clip cut
		translate([0,-clip_pos[1]-payload_mount_size[1]/2+clip_pos[3],clip_pos[2]])
		rotate(a=atan(clip_pos[1]/clip_pos[2]),v=[1,0,0])
		cube(size=[clip_pos[0]-clip_length_ext,joint_face_size*2,joint_face_size+2*cutClr],center=true);
		//cut from top for belt clip base
		translate([0,0,belt_clip_height/2-mount_thickness+belt_clip_height])
		cube(size=[clip_pos[0]-clip_length_ext,belt_clip_length*2,belt_clip_height],center=true);
		//arms clip cut
		for(i=[-1:2:1])
		{
			translate([i*clip_pos[0]/2,-clip_pos[1]-payload_mount_size[1]/2+clip_pos[3],clip_pos[2]])
			rotate(a=90,v=[0,1,0])
			{
				hull()
				{
					cylinder(d=clip_cut[1], h=clip_cut[0], $fn=quality*10, center=true);
					cylinder(d=clip_cut[3], h=clip_cut[2], $fn=quality*10, center=true);
				}
				cylinder(d=clip_cut[5], h=clip_cut[4], $fn=quality*10, center=true);
				cylinder(d=clip_cut[7], h=clip_cut[6], $fn=quality*10, center=true);
			}
		}
		//cut for gt2 belt
		translate([-belt_clip_shift,-belt_clip_length/2-cutClr,belt_clip_size[1]-belt_cut_par[0]])
		rotate(a=90,v=[0,0,1])
		GT2Belt(length=belt_clip_length+2*cutClr,h=belt_cut_par[0]+cutClr,width_clearance=belt_cut_par[1],center=false);
		//second cut for gt2 belt
		translate([belt_clip_shift,0,belt_clip_size[1]-belt_cut2_par[0]/2+cutClr/2])
		cube([belt_cut2_par[1],belt_clip_length*2,belt_cut2_par[0]+cutClr],center=true);
		//third cut for gt2 belt
		translate([-belt_clip_shift,0,belt_cut3_par[1]/2])
		cube([belt_clip_size[0]+2*cutClr,belt_cut3_par[0],belt_cut3_par[1]],center=true);
		//extra side cuts for belt
		for(i=[-1:2:1])
		translate([-belt_clip_shift,i*belt_clip_length/2,belt_clip_size[1]-belt_cut_par[0]])
		mirror([0,i<0?0:1,0])
		linear_extrude(height=belt_cut_par[0]+cutClr,center=false)
		polygon(points=[
			[-belt_cut_par[2]/2,0],
			[-belt_cut_par[2]/2,-belt_clip_length],
			[belt_cut_par[2]/2,-belt_clip_length],
			[belt_cut_par[2]/2,0],
			[0,belt_cut_par[3]],
		]);
		//nylon ties clips
		for(i=[-1:2:1],j=[-1:2:1])
		translate([i*(belt_clip_size[0]-tie_clip_size[0]+tie_clip_size[2])/2-belt_clip_shift,
				j*(payload_mount_size[1]/2-payload_handles_width/2-tie_clip_size[1]/2),
				belt_clip_height/2-mount_thickness])
		cube([tie_clip_size[0]+tie_clip_size[2],tie_clip_size[1],belt_clip_height+2*cutClr],center=true);
		//cuts at extra stiffness triangles
		for(i=[-1:2:1])
		hull()
		{
			translate([i*payload_triangles_cut[0]/2,0,-mount_thickness/2])
			cylinder(d=payload_triangles_cut[1],h=mount_thickness+2*cutClr,center=true,$fn=quality*10);
			translate([i*(payload_triangles_cut[0]/2+payload_triangles_cut[2]),0,-mount_thickness/2])
			cylinder(d=payload_triangles_cut[1],h=mount_thickness+2*cutClr,center=true,$fn=quality*10);
		}
		//inner clip mount cut (droplet shaped)
		translate([0,-clip_pos[1]-payload_mount_size[1]/2+clip_pos[3],clip_pos[2]])
		rotate(a=-90,v=[0,1,0])
		{
			hull()
			{
				cylinder(d=shaft_diam,h=clip_pos[0]+clip_length_ext+2*cutClr,center=true,$fn=quality*12);
				linear_extrude(height=clip_pos[0]+clip_length_ext+2*cutClr,center=true)
					polygon(points=[
						[0,-shaft_diam/2],
						[shaft_diam/2+droplet_cut,0],
						[0,shaft_diam/2],
					]);
			}
		}
		//payload screws
		for(i=[-1:2:1],j=[-1:2:1])
		translate([i*payload_mount_size[0]/2,j*payload_mount_size[1]/2,-mount_thickness/2])
		cylinder(d=payload_screw_diam,h=mount_thickness+2*cutClr,center=true,$fn=quality*10);
		//payload screw tops
		for(i=[-1:2:1],j=[-1:2:1])
		translate([i*payload_mount_size[0]/2,j*payload_mount_size[1]/2,0])
		cylinder(d=payload_screw_top_diam,h=clip_pos[2]*2,center=false,$fn=quality*10);
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
	translate([0,0,8])
	EffectorArmsMount();
}