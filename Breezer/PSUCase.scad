use <../OpenSCAD_Modules/cube_vround.scad>

module HNutPocket
(
	nutDiam=6.75,
	nutHeight=3,
	pocketLen=10,
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

module PSUCaseBottom
(
	ext_size=[170,110,60],
	socket_cut=[60,30,5,20],
	wall_size=2.4,
	left_cut=36,
	right_cut=35,
	top_cut=5,
	screw_hole_size=3.5,
	screw_hole_corner_shift=5,
	screw_hole_depth=[20,10],
	plug_clip_cut=[55,39],
	plug_clip_cut_clr=0.4,
	plug_clip_screw_diff=[38,20],
	plug_clip_screw_depth=[55,48],
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
	}
}

PSUCaseBottom();
