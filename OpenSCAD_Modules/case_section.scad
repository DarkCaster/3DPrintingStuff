use <cube_vround.scad>

module case_section(
size=[100,50,25],
screw_diam=3,
screw_clearance=0.2,
wall_sz=2,
base_sz=2,
center_xy=false,
center_z=false,
attach=0,
quality=2,
vents=[true,true,true,true],
vent_size=[3,2],
vent_period=[5,4],
vent_angle=0,
)
{
	assert(len(vents)==4);
	assert(len(vent_size)==2);
	assert(len(vent_period)==2);
	assert(vent_angle==0);
	assert(len(size)==3);
	size_x=size[0];
	size_y=size[1];
	height=size[2];
	assert(screw_diam>1);
	assert(screw_clearance>=0);
	assert(screw_clearance<0.5);
	assert(wall_sz>0);
	assert(base_sz>0);
	assert(height>base_sz);
	assert(quality>0);
	assert(attach>=0);
	min_sz=4*wall_sz+2*screw_diam;
	assert(size_x>=min_sz);
	assert(size_y>=min_sz);

	cstand_width=2*wall_sz+screw_diam;
	cstand_mvx=(size_x-cstand_width)/2;
	cstand_mvy=(size_y-cstand_width)/2;

	translate([center_xy?0:size_x/2,center_xy?0:size_y/2,center_z?-height/2:0])
	{
		difference()
		{
			union()
			{
				//corner stands base
				for(i=[true,false],j=[true,false])
					translate([(i?1:-1)*cstand_mvx,(j?1:-1)*cstand_mvy])
						cube_vround(round_corners=[(i==j?true:false),(i==j?false:true),(i==j?true:false),(i==j?false:true)],
							size=[cstand_width,cstand_width,height],
							rounding=screw_diam/2+wall_sz,
							attach=attach,wall_attach=0,quality=quality,center_xy=true,center_z=false);
				//walls
				for(i=[-1,1])
					translate([0,i*(size_y-wall_sz)/2,(height-attach)/2])
						cube([size_x-cstand_width,wall_sz,height+attach],center=true);
				for(i=[-1,1])
					translate([i*(size_x-wall_sz)/2,0,(height-attach)/2])
						cube([wall_sz,size_y-cstand_width,height+attach],center=true);
				//bottom
				cube_vround(size=[size_x-wall_sz,size_y-wall_sz,base_sz],
					rounding=(screw_diam+wall_sz)/2,
					attach=attach,center_xy=true);
			}
			//corner stands screws
			for(i=[true,false],j=[true,false])
				translate([(i?1:-1)*cstand_mvx,(j?1:-1)*cstand_mvy,-attach-0.1])
					cylinder(d=screw_diam+screw_clearance,h=height+attach+0.2,$fn=12*quality);
			//vents
		}
	}
}

//examples
case_section();

translate([0,-20,0])
	case_section(size=[8,10,5],wall_sz=0.5,screw_diam=2,base_sz=1,center_z=true);
