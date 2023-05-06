module NutPocket
(
	nut_diam=6.75,
	pocket_len=100,
)
{
	//m=(nut_diam/2)*sqrt(3)/2;
	cylinder(d=nut_diam,h=pocket_len,center=false,$fn=6);
}

module MCUMount
(
	base_size=[40,20.5,8.5],
	cut_size=[35,18.5,6.5],
	clip_size=[38,18.5,2],
	clip_depth=1,
	front_cut=[7,11,3.5],
	side_cut=[9,4],
	side_cut_shift=-12.5,
	rear_clip_len=5.5,
	rear_clip_diam=7.5,
	rear_clip_z_shift=-1,
	nut_depth=2,
	nut_diam=6.75,
	screw_diam=3.5,
	quality=2,
)
{
	cutClr=0.1;
	difference()
	{
		union()
		{
			difference()
			{
				//base
				translate([0,-base_size[1]/2,-base_size[2]])
				cube(size=base_size,center=false);
				//internal cut
				translate([base_size[0]/2-cut_size[0]/2,-cut_size[1]/2,-cut_size[2]])
				cube(size=[cut_size[0],cut_size[1],cut_size[2]+cutClr],center=false);
				//clip cut
				translate([base_size[0]/2-clip_size[0]/2,-clip_size[1]/2,-clip_size[2]-clip_depth])
				cube(size=clip_size,center=false);
				//rear cut
				translate([base_size[0]/2-clip_size[0]/2,-clip_size[1]/2,-clip_size[2]-clip_depth])
				cube(size=[clip_size[0]/2,clip_size[1],clip_size[2]+clip_depth+cutClr],center=false);
				//front usb cut
				translate([base_size[0]-front_cut[0],-front_cut[1]/2,-front_cut[2]-clip_depth-clip_size[2]])
				cube(size=[front_cut[0]+cutClr,front_cut[1],front_cut[2]+cutClr],center=false);
				//side cut
				side_pos=base_size[0]-(base_size[0]-clip_size[0])/2;
				translate([side_pos-side_cut[0]/2+side_cut_shift,base_size[1]/2-side_cut[1],-base_size[2]-cutClr])
				cube(size=[side_cut[0],side_cut[1]+cutClr,base_size[2]+2*cutClr],center=false);
			}
			//rear clip
			wallsz=(base_size[0]-clip_size[0])/2;
			translate([-rear_clip_len/2+wallsz/2,0,-rear_clip_diam/2+rear_clip_z_shift])
			rotate(a=90,v=[0,1,0])
			cylinder(d=rear_clip_diam,h=rear_clip_len+wallsz,center=true,$fn=quality*12);
		}
		//rear clip screw
		wallsz=(base_size[0]-clip_size[0])/2;
		translate([-rear_clip_len/2+wallsz/2,0,-rear_clip_diam/2+rear_clip_z_shift])
		rotate(a=90,v=[0,1,0])
		cylinder(d=screw_diam,h=rear_clip_len+wallsz+2*cutClr,center=true,$fn=quality*12);

		translate([-nut_depth,0,-rear_clip_diam/2+rear_clip_z_shift])
		rotate(a=90,v=[0,1,0])
		NutPocket(nut_diam=nut_diam,pocket_len=(base_size[0]-cut_size[0])/2+cutClr+nut_depth);
	}
}

module PololuDriverMount
(
	base_size=[28,9,7],
	main_cut_size=[21,9,5],
	central_cut_size=[21,7,7],
	quality=2,
)
{
	cutClr=0.1;
			difference()
			{
				//base
				translate([0,0,-base_size[2]/2])
				cube(size=base_size,center=true);

				translate([0,0,-main_cut_size[2]/2])
				cube(size=[main_cut_size[0],main_cut_size[1]+2*cutClr,main_cut_size[2]+cutClr],center=true);

				translate([0,0,-central_cut_size[2]/2-cutClr])
				cube(size=[central_cut_size[0],central_cut_size[1],central_cut_size[2]+cutClr],center=true);

			}
}

//PololuDriverMount();

MCUMount();
