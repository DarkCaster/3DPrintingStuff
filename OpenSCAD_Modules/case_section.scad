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
vent_size=[5,2],
vent_period=[7,3],
vent_angle=45,
)
{
	assert(len(vents)==4);
	assert(len(vent_size)==2);
	assert(len(vent_period)==2);
	assert(vent_angle>=0);
	assert(vent_angle<90);
	assert(vent_size[0]>0);
	assert(vent_size[1]>0);
	assert(vent_period[0]>vent_size[0]);
	assert(vent_period[1]>vent_size[1]);
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
	//calculate and check vents sizes
	vent_shift=tan(vent_angle)*wall_sz;
	vent_wall_sz=wall_sz/cos(vent_angle);
	vent_full_szx=vent_size[0]+vent_shift;
	vent_clr=wall_sz/2; //clearance
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
			for(vpar=[
				[vents[0],0,size_x-2*cstand_width,0,1],
				[vents[1],270,size_y-2*cstand_width,1,0],
				[vents[2],180,size_x-2*cstand_width,0,-1],
				[vents[3],90,size_y-2*cstand_width,-1,0]
				])
				if(vpar[0]) //if vents enabled on selected side
					translate([vpar[3]*size_x/2,vpar[4]*size_y/2,vent_size[1]/2+base_sz]) //move to the wall
						rotate(a=vpar[1],v=[0,0,1]) //rotate on selected angle around z axis
						for(row=[0:1:(height-base_sz)/vent_period[1]])
						{
							shift_z=vent_period[1]*row;
							if(shift_z<=height-base_sz-vent_period[1])
								translate([0,0,shift_z])
									rotate(row/2==round(row/2)?0:180,v=[0,1,0])
									for(shift_x=[0:vent_period[0]:vpar[2]]) //iterate over the wall distance and generate vent
										if(shift_x+vent_full_szx<=vpar[2])
										{
											translate([shift_x-vpar[2]/2,0,-vent_size[1]/2])
												//extrude
												linear_extrude(height=vent_size[1])
													//polygon
													polygon(points=[[0,-vent_clr-wall_sz],
														[0,-wall_sz],
														[vent_shift,0],
														[vent_shift,vent_clr],
														[vent_shift+vent_size[0],vent_clr],
														[vent_shift+vent_size[0],0],
														[vent_size[0],-wall_sz],
														[vent_size[0],-vent_clr-wall_sz]]);
										}
						}
		}
	}
}

//examples
case_section();

translate([0,-20,0])
	case_section(size=[8,10,5],
	wall_sz=0.5,
	screw_diam=2,
	base_sz=1,
	vent_angle=25,vent_size=[1,1],vent_period=[1.5,1.5],
	vents=[false,true,true,false],
	center_z=true);
