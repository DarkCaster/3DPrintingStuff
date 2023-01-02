//Simple do-(sh)it-yourself joints
use <../OpenSCAD_Modules/cube_vround.scad>

module InnerJoint
(
	shaft_diam=3,
	clip_length=29, //1 extra mm kept for 2x0.5mm washers
	clip_width=10, //1 extra mm kept for 2x0.5mm washers
	screw_hole_diam=2.95,
	droplet_cut=0.4,
	face_size=9,
	hull_facet=[1,0.5],
	center_cut_diam=4,
	quality=10,
)
{
	cutClr=0.1;
	difference()
	{
		hull()
		{
			//x dimension
			cube(size=[clip_length,face_size,face_size-hull_facet[0]*2],center=true);
			cube(size=[clip_length-hull_facet[1]*2,face_size-hull_facet[1]*2,face_size],center=true);
			//y dimention
			cube(size=[face_size,clip_width,face_size-hull_facet[0]*2],center=true);
			cube(size=[face_size,clip_width-hull_facet[1]*2,face_size],center=true);
		}
		//center cut
		cylinder(d=center_cut_diam,h=face_size+cutClr*2,$fn=quality*10,center=true);
		//main cut (x dimension)
		rotate(a=-90,v=[0,1,0])
		{
			hull()
			{
				cylinder(d=screw_hole_diam,h=clip_length+2*cutClr,center=true,$fn=quality*12);
				linear_extrude(height=clip_length+2*cutClr,center=true)
					polygon(points=[
						[0,-screw_hole_diam/2],
						[screw_hole_diam/2+droplet_cut,0],
						[0,screw_hole_diam/2],
					]);
			}
		}

		//side cut (y dimension)
		rotate(a=90,v=[1,0,0])
		{
			hull()
			{
				//main cut
				cylinder(d=shaft_diam,h=clip_width+2*cutClr,center=true,$fn=quality*12);
				//droplet cut for shaft for better printing wthout supports
				linear_extrude(height=clip_width+2*cutClr,center=true)
				polygon(points=[
					[-shaft_diam/2,0],
					[0,shaft_diam/2+droplet_cut],
					[shaft_diam/2,0],
				]);
			}
		}
	}
	
}

module OuterJoint
(
	shaft_diam=3.075,
	screw_hole_diam=3.2,
	handle_height=45,
	clip_width_int=10+1,
	clip_width=10+1+2+2,
	clip_height=15,//face_size/2
	clip_cut_size=11, //1 for 2x0.5mm washers
	droplet_cut=0.4,
	face_size=9,
	handle_cuts_pos1=25,
	handle_cuts_pos2=45-9/2,//face_size
	holes_facet=[0.5,0.6],
	quality=10,
)
{
	face_shift=face_size/2;
	cutClr=0.01;

	difference()
	{
		//handle
		translate([0,0,handle_height/2-face_shift])
		rotate(a=90,v=[0,1,0])
		rotate(a=90,v=[1,0,0])
		cube_vround(size=[handle_height,face_size,clip_width],center_xy=true,center_z=true,rounding=face_size/2,quality=quality);

		//hinge clip
		translate([0,0,clip_height/2-face_shift])
		cube(size=[face_size+2*cutClr,clip_width_int,clip_height],center=true);

		union()
		{
			rotate(a=90,v=[1,0,0])
			cylinder(d=shaft_diam,h=clip_width+2*cutClr,center=true,$fn=quality*12);

			for(i=[-1:2:1])
			rotate(a=i*90,v=[1,0,0])
			translate([0,0,-clip_width/2+holes_facet[1]/2])
			cylinder(d1=shaft_diam+holes_facet[0]*2,d2=shaft_diam,h=holes_facet[1]+2*cutClr,center=true,$fn=quality*12);
		}

		//handle cuts
		union()
		{
			translate([0,0,handle_cuts_pos1-face_shift])
			rotate(a=90,v=[1,0,0])
			cylinder(d=screw_hole_diam,h=clip_width+2*cutClr,center=true,$fn=quality*12);

			translate([0,0,handle_cuts_pos1-face_shift])
			for(i=[-1:2:1])
			rotate(a=i*90,v=[1,0,0])
			translate([0,0,-clip_width/2+holes_facet[1]/2])
			cylinder(d1=screw_hole_diam+holes_facet[0]*2,d2=screw_hole_diam,h=holes_facet[1]+2*cutClr,center=true,$fn=quality*12);
		}

		union()
		{
			translate([0,0,handle_cuts_pos2-face_shift])
			rotate(a=90,v=[1,0,0])
			cylinder(d=screw_hole_diam,h=clip_width+2*cutClr,center=true,$fn=quality*12);

			translate([0,0,handle_cuts_pos2-face_shift])
			for(i=[-1:2:1])
			rotate(a=i*90,v=[1,0,0])
			translate([0,0,-clip_width/2+holes_facet[1]/2])
			cylinder(d1=screw_hole_diam+holes_facet[0]*2,d2=screw_hole_diam,h=holes_facet[1]+2*cutClr,center=true,$fn=quality*12);
		}
	}

}


InnerJoint();

//half of the joint handle
difference() { OuterJoint(); translate([0,-50,0]) cube(size=[100,100,100], center=true); }