use <../OpenSCAD_Modules/cube_vround.scad>

module plate
(
	size=[269,220,6],
	outer_cut_sz=5,
	clip_cut_sz=[13,20,3],
	clip_shift=160,
	clip_rounding=3,
	quality=8,
)
{
	cutClr=1;
	difference()
	{
		//base
		cube_vround(
			size=size,
			round_corners=[false,false,false,false],
			center_xy=true,quality=quality
		);
		//corner cuts
		for(i=[-1:2:1],j=[-1:2:1])
		translate([size[0]/2*i,size[1]/2*j,-cutClr])
		rotate(v=[0,0,1],a=
			(i>0&&j>0)?180:
			(i<0&&j<0)?0:
			(i>0&&j<0)?90:270)
		linear_extrude(height=size[2]+2*cutClr)
		polygon(points=[
			[-cutClr,-cutClr],
			[-cutClr,outer_cut_sz],
			[0,outer_cut_sz],
			[outer_cut_sz,0],
			[outer_cut_sz,-cutClr]]);
		//side clip cuts
		for(i=[-1:2:1],j=[-1:2:1])
		translate(
			[i*(size[0]/2-clip_cut_sz[0]/2+cutClr/2),
			j*clip_shift/2,
			size[2]-clip_cut_sz[2]])
		cube_vround(
			size=[clip_cut_sz[0]+cutClr,clip_cut_sz[1]+clip_rounding*2,clip_cut_sz[2]+cutClr],
			round_corners=[i<0,i<0,i>0,i>0],
			rounding=clip_rounding,
			center_xy=true,
			quality=quality
		);
	}

}

plate();
