module ptfe_tube_clip
(
	side_clip_sz=[15,6],
	size_clip_hole=[7,7,5,3,5],
	ext_diam=10,
	cut_diam=7.7,
	full_len=7+16,
	int_len=7,
	clip_len=18,
	clip_cut=3.5,
	ptfe_ext_diam=4.4,
	ptfe_clip_diam=5.4,
	screw_diam=4.5,
	screw_x=9,
	quality=1,
	attach=0.01,
)
{
	difference()
	{
		union()
		{
			difference()
			{
				cylinder(d=ext_diam,h=full_len,$fn=24*quality);
				
				translate([0,0,-attach])
					difference()
					{
						cylinder(d=ext_diam+attach,h=int_len+attach,$fn=24*quality);
						cylinder(d=cut_diam,h=int_len+attach,$fn=24*quality);
					}
			}
			//clip
			translate([0,-ext_diam/2,int_len])
				cube([clip_len,ext_diam,full_len-int_len]);
			//side clip
			translate([-side_clip_sz[1],-side_clip_sz[0],int_len])
				cube([side_clip_sz[1],side_clip_sz[0],full_len-int_len]);
			translate([-side_clip_sz[1]+attach,-size_clip_hole[0],size_clip_hole[1]+int_len])
				rotate(a=-90,v=[0,1,0])
					cylinder(d=size_clip_hole[2],h=size_clip_hole[4]+attach,center=false,$fn=24*quality);			
		}
		//ptfe
		translate([0,0,-attach])
			cylinder(d=ptfe_ext_diam,h=full_len+2*attach,$fn=24*quality);
		//clip cut
		translate([0,-clip_cut/2,int_len-attach])
				cube([clip_len+attach,clip_cut,full_len-int_len+2*attach]);
		//ptfe clip
		translate([0,0,int_len-attach])
			cylinder(d=ptfe_clip_diam,h=full_len-int_len+2*attach,$fn=24*quality);
			
		translate([screw_x,0,int_len+(full_len-int_len)/2])
			rotate(a=90,v=[1,0,0])
				cylinder(d=screw_diam,h=ext_diam+2*attach,center=true,$fn=24*quality);
		translate([attach,-size_clip_hole[0],size_clip_hole[1]+int_len])
			rotate(a=-90,v=[0,1,0])
				cylinder(d=size_clip_hole[3],h=size_clip_hole[4]+side_clip_sz[1]+2*attach,center=false,$fn=24*quality);
	}



}


ptfe_tube_clip();
