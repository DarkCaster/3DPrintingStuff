use <../OpenSCAD_Modules/cube_vround.scad>

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

module VNutPocket
(
	nutDiam=6.75,
	nutHeight=3,
	pocketLen=100,
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

module PSUCaseBottom
(
	ext_size=[170,110,85],
	socket_cut=[76.5,50,5,24.6],
	wall_size=2.4,
	left_cut=36,
	right_cut=35,
	top_cut=10,
	screw_hole_size=3.5,
	screw_hole_corner_shift=5,
	screw_hole_depth=[20,10],
	plug_clip_cut=[55,39],
	plug_clip_cut_clr=0.4,
	plug_clip_screw_diff=[38,37],
	plug_clip_screw_depth=[55,48],
	right_cut_screw_diff=[55,40.5+2.4],
	right_output_cut_size=5.5,
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
		//left cut
		translate([-ext_size[0]/2+left_cut/2+screw_hole_corner_shift+screw_hole_size/2+wall_size,0,wall_size])
		cube_vround(size=[left_cut,ext_size[1]-2*wall_size,ext_size[2]], center_xy=true, quality=quality, rounding=rounding-wall_size);
		//right cut
		translate([ext_size[0]/2-right_cut/2-screw_hole_corner_shift-screw_hole_size/2-wall_size,0,wall_size])
		cube_vround(size=[right_cut,ext_size[1]-2*wall_size,ext_size[2]], center_xy=true, quality=quality, rounding=rounding-wall_size);
		//top cut
		translate([0,0,ext_size[2]-top_cut])
		cube_vround(size=[ext_size[0]-2*(screw_hole_corner_shift+screw_hole_size/2+wall_size),ext_size[1]-2*wall_size,top_cut+cutClr], center_xy=true, quality=quality, rounding=rounding-wall_size);
		//screw holes
		for(i=[-1:2:1],j=[-1:2:1])
		{
			translate([i*(ext_size[0]/2-screw_hole_corner_shift),j*(ext_size[1]/2-screw_hole_corner_shift),ext_size[2]-screw_hole_depth[0]])
			cylinder(d=screw_hole_size, h=screw_hole_depth[0]+cutClr, center=false, $fn=12*quality);
			translate([i*(ext_size[0]/2-screw_hole_corner_shift),j*(ext_size[1]/2-screw_hole_corner_shift),ext_size[2]-screw_hole_depth[1]])
			rotate(a=i>0?45*j:135*j,v=[0,0,1])
			HNutPocket();
		}
		//plug clip cut
		translate([0,-ext_size[1]/2+plug_clip_cut[1]/2+wall_size+plug_clip_cut_clr,-cutClr])
		cube_vround(size=[plug_clip_cut[0]+2*plug_clip_cut_clr,plug_clip_cut[1]+2*plug_clip_cut_clr,ext_size[2]+2*cutClr], center_xy=true, quality=quality, rounding=pc_rounding);
		//plug clip screw holes
		for(i=[-1:2:1])
		{
			translate([i*plug_clip_screw_diff[0]/2,-(ext_size[1]/2-plug_clip_screw_depth[0]),ext_size[2]-plug_clip_screw_diff[1]])
			rotate(a=90,v=[1,0,0])
			cylinder(d=screw_hole_size,h=plug_clip_screw_depth[0]+cutClr,center=false,$fn=12*quality);

			translate([i*plug_clip_screw_diff[0]/2,-(ext_size[1]/2-plug_clip_screw_depth[1]),ext_size[2]-plug_clip_screw_diff[1]])
			VNutPocket(pocketLen=ext_size[2]);
		}
		//right side screw holes
		for(i=[-1:2:1])
		{
			translate([ext_size[0]/2-(screw_hole_corner_shift+screw_hole_size/2+wall_size)-cutClr,i*right_cut_screw_diff[0]/2,right_cut_screw_diff[1]])
			rotate(a=90,v=[0,1,0])
			cylinder(d=screw_hole_size,h=screw_hole_corner_shift+screw_hole_size/2+wall_size+2*cutClr,center=false,$fn=12*quality);
		}
		//right side cut
		translate([ext_size[0]/2-right_cut-screw_hole_corner_shift-screw_hole_size/2-wall_size+right_output_cut_size/2,0,wall_size+right_output_cut_size/2])
		rotate(a=-90,v=[1,0,0])
		cylinder(d=right_output_cut_size,h=ext_size[1]/2+cutClr,center=false,$fn=12*quality);
	}
}

module PSUPlugHolder
(
	size=[55,39,53],
	adj_clip_diff=[38,11],
	plug_diam=34.2,
	plug_clip_diff=[37,5],
	plug_clip_ext_diam=7,
	screw_hole_size=3.5,
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
			for(j=[-1:2:1])
			{
				translate([i*adj_clip_diff[0]/2,0,size[2]/2+j*(size[2]/2-adj_clip_diff[1])])
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
	}
}


PSUCaseBottom();

translate([0,-55+39/2+2.4+0.4,29])
PSUPlugHolder();