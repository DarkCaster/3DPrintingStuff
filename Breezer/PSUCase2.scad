use <../OpenSCAD_Modules/cube_vround.scad>

module VNutPocket
(
	nutDiam=6.75,
	nutHeight=3,
	pocketLen=10,
)
{
	m=(nutDiam/2)*sqrt(3)/2;
	rotate(a=90,v=[0,0,1])
		rotate(a=90,v=[0,-1,0])
			union()
			{
				cylinder(d=nutDiam,h=nutHeight,center=true,$fn=6);
				translate([pocketLen/2,0,0])
				cube(size=[pocketLen,m*2,nutHeight],center=true);
			}
}

module VNutSidePocket
(
	nutDiam=6.75,
	pocketLen=100,
)
{
	m=(nutDiam/2)*sqrt(3)/2;
	rotate(a=90,v=[1,0,0])
	rotate(a=90,v=[0,-1,0])
	cylinder(d=nutDiam,h=pocketLen,center=false,$fn=6);
}

module HNutPocket
(
	nutDiam=6.75,
	nutHeight=3,
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

module WallSocketClip
(
	ext_size=[88,86,50],
	socket_cut=[76.25,50,5,24.6],
	screw_hole_size=3.5,
	screw_hole_corner_shift=5,
	screw_hole_depth=[20,10],
	wall_size=2,
	plug_clip_cut=[55,39],
	plug_clip_cut_clr=0.4,
	plug_clip_screw_diff=[38,40],
	plug_clip_screw_depth=[55,48],
	side_holes_diff=[50,15],
	switch_hole_size=15.5,
	switch_hole_pos=40,
	wires_hole_size=10,
	wires_hole_pos=[22,43],
	quality=2,
)
{
	cutClr=1;
	rounding=5;
	pc_rounding=rounding+plug_clip_cut_clr;

	difference()
	{
		//base
		cube_vround(size=ext_size, center_xy=true, quality=quality, rounding=rounding);
		//middle plug cut
		rotate(a=90,v=[1,0,0])
		translate([0,0,-ext_size[1]/2-cutClr])
		linear_extrude(height=ext_size[1]+2*cutClr)
		polygon(points=[
			[-socket_cut[0]/2,-cutClr],
			[-socket_cut[0]/2,socket_cut[2]],
			[-socket_cut[1]/2,socket_cut[3]],
			[socket_cut[1]/2,socket_cut[3]],
			[socket_cut[0]/2,socket_cut[2]],
			[socket_cut[0]/2,-cutClr],
		]);
		//plug clip cut
		translate([0,-ext_size[1]/2+plug_clip_cut[1]/2+wall_size+plug_clip_cut_clr,-cutClr])
		cube_vround(size=[plug_clip_cut[0]+2*plug_clip_cut_clr,plug_clip_cut[1]+2*plug_clip_cut_clr,ext_size[2]+2*cutClr], center_xy=true, quality=quality, rounding=pc_rounding);
		//plug clip screw holes
		for(i=[-1:2:1])
		{
			translate([i*plug_clip_screw_diff[0]/2,-(ext_size[1]/2-plug_clip_screw_depth[0]),plug_clip_screw_diff[1]])
			rotate(a=90,v=[1,0,0])
			cylinder(d=screw_hole_size,h=plug_clip_screw_depth[0]+cutClr,center=false,$fn=12*quality);
			translate([i*plug_clip_screw_diff[0]/2,-(ext_size[1]/2-plug_clip_screw_depth[1]),plug_clip_screw_diff[1]])
			VNutPocket(pocketLen=ext_size[2]);
		}
		for(i=[-1:2:1])
		{
			translate([ext_size[1]/2-wall_size,i*side_holes_diff[0]/2,side_holes_diff[1]])
			VNutSidePocket(pocketLen=ext_size[1]/2);
			translate([ext_size[1]/2-wall_size-cutClr,i*side_holes_diff[0]/2,side_holes_diff[1]])
			rotate(a=90,v=[0,1,0])
			cylinder(d=screw_hole_size,h=ext_size[1]/2,center=false,$fn=12*quality);
		}
		//screw holes
		for(i=[-1:2:1],j=[-1:2:1])
		{
			translate([i*(ext_size[0]/2-screw_hole_corner_shift),j*(ext_size[1]/2-screw_hole_corner_shift),ext_size[2]-screw_hole_depth[0]])
			cylinder(d=screw_hole_size, h=screw_hole_depth[0]+cutClr, center=false, $fn=12*quality);
			translate([i*(ext_size[0]/2-screw_hole_corner_shift),j*(ext_size[1]/2-screw_hole_corner_shift),ext_size[2]-screw_hole_depth[1]])
			rotate(a=i>0?45*j:135*j,v=[0,0,1])
			HNutPocket();
		}
		//power switch hole
		translate([0,-ext_size[1]/2+wall_size+plug_clip_cut[1]+2*plug_clip_cut_clr-cutClr,switch_hole_pos])
		rotate(a=-90,v=[1,0,0])
		cylinder(d=switch_hole_size, h=ext_size[1], center=false, $fn=12*quality);
		//wires cut
		translate([0,-ext_size[1]/2+wires_hole_pos[0],wires_hole_pos[1]])
		rotate(a=90,v=[0,1,0])
		cylinder(d=wires_hole_size, h=ext_size[1], center=false, $fn=12*quality);
	}
}

module PSUPlugHolder
(
	size=[55,39,21],
	adj_clip_diff=[38,10.5,3],
	plug_diam=34.2,
	plug_clip_diff=[37,5],
	plug_clip_ext_diam=7,
	screw_hole_size=3.5,
	switch_hole_size=20,
	wires_hole_size=15,
	quality=2,
)
{
	cutClr=1;
	rounding=5;
	difference()
	{
		//base
		cube_vround(size=size, center_xy=true, quality=quality, rounding=rounding);
		//adjustable clip-holes
		for(i=[-1:2:1])
		{
			hull()
			{
				//top
				translate([i*adj_clip_diff[0]/2, 0, size[2]/2+(size[2]/2-adj_clip_diff[2])])
				rotate(a=90,v=[1,0,0])
				cylinder(d=screw_hole_size,h=size[0]+2*cutClr,center=true,$fn=12*quality);
				//bottom
				translate([i*adj_clip_diff[0]/2, 0, size[2]/2-(size[2]/2-adj_clip_diff[1])])
				rotate(a=90,v=[1,0,0])
				cylinder(d=screw_hole_size,h=size[0]+2*cutClr,center=true,$fn=12*quality);
			}
		}
		//plug hole
		translate([0,0,-cutClr])
		cylinder(d=plug_diam,h=size[2]+2*cutClr,center=false,$fn=48*quality);
		//plug clip
		translate([0,0,plug_clip_diff[1]])
		{
			translate([plug_clip_diff[0]/2,0,0])
			rotate(a=90,v=[0,1,0])
			cylinder(d=plug_clip_ext_diam,h=size[1],center=false,$fn=12*quality);

			translate([-plug_clip_diff[0]/2,0,0])
			VNutSidePocket();

			rotate(a=90,v=[0,1,0])
			cylinder(d=screw_hole_size,h=size[1],center=true,$fn=12*quality);
		}
		//power switch hole
		translate([0,0,size[2]])
		rotate(a=-90,v=[1,0,0])
		cylinder(d=switch_hole_size, h=size[1], center=false, $fn=12*quality);
		//wires cut
		translate([0,0,size[2]])
		rotate(a=90,v=[0,1,0])
		cylinder(d=wires_hole_size, h=size[1], center=false, $fn=12*quality);
	}
}

WallSocketClip();

translate([0,-86/2+39/2+2+0.4,29])
PSUPlugHolder();
