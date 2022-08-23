use <../OpenSCAD_Modules/cube_vround.scad>

module HNutPocket
(
	nutDiam=6.75,
	nutHeight=2.4,
	pocketLen=100,
)
{
	m=(nutDiam/2)*sqrt(3)/2;
	union()
	{
		cylinder(d=nutDiam,h=nutHeight,center=true,$fn=6);
		translate([pocketLen/2,0,0])
		cube(size=[pocketLen,m*2,nutHeight],center=true);
	}
}

module Case
(
	ext_size=[122,17],
	front_clip_size=[10,60,10,3.5,1,2],
	wall_size=1.6,
	base_size=2,
	pcb_size=[99.2,34],
	pcb_cut=[2,80,23,10,1.6,10],
	eth_cut=[18,13.6,0.6],
	screw_size=3,
	screw_diff=[27,3],
	side_screw_size=3.5,
	side_screw_shift=[0,5],
	nut_size=6,
	nut_shift=10,
	quality=2,
)
{
	cutClr=5;
	cutSmall=0.01;
	rounding=5;
	int_rounding=rounding-wall_size;

	difference()
	{
		union()
		{
			//base
			cube_vround(size=[ext_size[0],pcb_size[1]+2*wall_size,ext_size[1]],
				center_xy=true,quality=quality,rounding=rounding);
			translate([ext_size[0]/2-front_clip_size[0]/2,0,0])
			cube_vround(size=[front_clip_size[0],front_clip_size[1],front_clip_size[2]],
				center_xy=true,quality=quality,rounding=front_clip_size[5]);
		}
		//front clip scew cuts
		for(i=[-1:2:1])
		{
			holeCenter=(front_clip_size[1]/2-pcb_size[1]/2-wall_size)/2+pcb_size[1]/2+wall_size;
			hull()
			for(s=[-1:2:1])
			{
				translate([ext_size[0]/2-front_clip_size[0]/2,i*holeCenter+s*front_clip_size[4],front_clip_size[2]/2])
				rotate(a=90,v=[0,1,0])
				cylinder(d=front_clip_size[3],h=front_clip_size[0]+2*cutClr,center=true,$fn=12*quality);
			}
		}
		//main pcb cut
		translate([ext_size[0]/2-pcb_size[0]/2-wall_size/2,0,base_size+pcb_cut[0]])
		cube_vround(size=[pcb_size[0]-wall_size,pcb_size[1],ext_size[1]+cutClr],round_corners=[true,true,false,false],
			center_xy=true,quality=quality,rounding=int_rounding);
		//pcb cut 1
		translate([ext_size[0]/2-pcb_cut[1]/2-wall_size/2,0,base_size])
		cube_vround(size=[pcb_cut[1]-wall_size,pcb_size[1],pcb_cut[0]+cutClr],
				center_xy=true,quality=quality,rounding=int_rounding);
		//pcb cut 2
		translate([ext_size[0]/2-wall_size/2,0,base_size+pcb_cut[3]/2])
		cube(size=[wall_size+2*cutClr,pcb_cut[2],pcb_cut[3]],center=true);
		//pcb cut 3
		translate([ext_size[0]/2-wall_size/2,0,base_size+pcb_cut[4]/2+pcb_cut[0]])
		cube(size=[wall_size+2*cutClr, pcb_size[1], pcb_cut[4]],center=true);
		//eth board cut 1
		ethBackCut=ext_size[0]-pcb_size[0];
		translate([-ext_size[0]/2+ethBackCut/2,0,base_size+eth_cut[1]/2+cutClr/2+pcb_cut[0]-eth_cut[2]])
		cube(size=[ethBackCut+2*cutClr,eth_cut[0],eth_cut[1]+cutClr],center=true);
		//eth board cut 2 (pcb top)
		translate([-ext_size[0]/2+ethBackCut/2,0,base_size+eth_cut[1]+pcb_cut[0]-eth_cut[2]+ext_size[1]/2])
		cube(size=[ethBackCut+2*cutClr,pcb_size[1],ext_size[1]],center=true);
		//eth screw holes
		for(i=[-1:2:1])
		{
			translate([-ext_size[0]/2+screw_diff[1],i*screw_diff[0]/2,base_size])
			{
				translate([0,0,nut_shift])
				rotate(a=180,v=[0,0,1])
				HNutPocket();
				cylinder(d=screw_size,h=2*ext_size[1],$fn=12*quality,center=true);
			}
		}
		//eth back cut for ease of insertion of main pcb
		rotate(a=90,v=[1,0,0])
		linear_extrude(height=pcb_size[1],center=true)
		polygon(points=[
			[0,base_size+pcb_cut[0]+pcb_cut[4]],
			[-ext_size[0]/2+ethBackCut,base_size+pcb_cut[0]+pcb_cut[4]],
			[-ext_size[0]/2+ethBackCut-pcb_cut[5],ext_size[1]+cutSmall],
			[0,ext_size[1]+cutSmall],
		]);
		//eth side clip screw hole
		translate([side_screw_shift[0],0,ext_size[1]-side_screw_shift[1]])
		rotate(a=90,v=[1,0,0])
		cylinder(d=side_screw_size,h=pcb_size[1]+2*wall_size+2*cutClr,$fn=12*quality,center=true);
	}
}

Case();
