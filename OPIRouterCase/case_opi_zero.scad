use <opi_zero.scad>
use <../OpenSCAD_Modules/stand.scad>
use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand_vround.scad>

module case_opi_zero(
screw_diam=3,
screw_clearance=0.2,
stand_wall_sz=1.2,
stand_height=3,
wall_sz=2,
base_sz=2,
height=24,
size_x=100,
size_y=62,
center_xy=false,
center_z=false,
attach=0,
opi_height=15,
opi_szx=48,
opi_szy=46,
opi_clearance=1,
quality=2,
)
{
	assert(opi_height>0);
	assert(opi_szx>=48);
	assert(opi_szy>=46);
	assert(opi_clearance>0);

	assert(attach>=0);
	assert(stand_height>0);
	assert(screw_diam>1);
	assert(screw_diam<4);
	assert(screw_clearance>=0);
	assert(screw_clearance<0.5);
	assert(stand_wall_sz>0.399);
	assert(screw_diam+stand_wall_sz*2<8);
	assert(wall_sz>0);
	assert(base_sz>0);
	assert(height>base_sz+stand_height+opi_height);
	min_szx=opi_szx+2*(2*wall_sz+opi_clearance+screw_diam);
	min_szy=opi_szy+2*(2*wall_sz+opi_clearance+screw_diam);
	assert(size_x>=min_szx);
	assert(size_y>=min_szy);

	cstand_width=2*wall_sz+screw_diam;
	cstand_mvx=(size_x-cstand_width)/2;
	cstand_mvy=(size_y-cstand_width)/2;

	opi_move_x=size_x/2-wall_sz-opi_clearance-opi_szx/2;
	opi_move_z=base_sz+stand_height;
	ostand_mvx=opi_szx/2-3;
	ostand_mvy=opi_szy/2-3;

	//center_xy;center_z
	translate([center_xy?0:0,center_xy?0:0,center_z?-height/2:0])
	{
		//case base
		difference()
		{
			union()
			{
				difference()
				{
					cube_vround(size=[size_x,size_y,height],
						rounding=wall_sz+screw_diam/2,
						attach=attach,center_xy=true,quality=quality);
					translate([0,0,base_sz])
						cube_vround(size=[size_x-2*wall_sz,size_y-2*wall_sz,height],
							rounding=screw_diam/2,center_xy=true,quality=quality);
				}
				//corner stands base
				for(i=[true,false],j=[true,false])
					translate([(i?1:-1)*cstand_mvx,(j?1:-1)*cstand_mvy,base_sz])
						cube_vround(round_corners=[(i==j?true:false),(i==j?false:true),(i==j?true:false),(i==j?false:true)],
							size=[cstand_width,cstand_width,height-base_sz],
							rounding=(screw_diam-screw_clearance)/2+wall_sz,
							attach=0.005,wall_attach=0,quality=quality,center_xy=true,center_z=false);
				//orange pi stands
				for(i=[true,false],j=[true,false])
					translate([opi_move_x+(i?1:-1)*ostand_mvx,(j?1:-1)*ostand_mvy,base_sz])
						stand(height=stand_height,
							inner_diam=screw_diam,
							top_diam=screw_diam+2*stand_wall_sz,bottom_diam=screw_diam+3*stand_wall_sz,
									attach=0.005,quality=quality,center_xy=true);
			}
			//corner stands screws
			for(i=[true,false],j=[true,false])
				translate([(i?1:-1)*cstand_mvx,(j?1:-1)*cstand_mvy,base_sz])
					cylinder(d=screw_diam+screw_clearance,h=height,$fn=12*quality);
		}

		//draw orange pi zero
		translate([opi_move_x,0,opi_move_z])
			orange_pi_zero(center_xy=true);
	}
}

case_opi_zero();