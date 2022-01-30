use <../OpenSCAD_Modules/cube_vround.scad>

module knife
(
	size=[19.5,1.1,61],
	screw_diam=4,
	screw_diff=6,
	angles=[51.71,2],
	height_extra=50,
	shift=15,
	quality=2,
)
{
	cutClt=1;
	rotate(v=[0,0,1],a=angles[1])
	translate([-shift,0,0])
	difference()
	{
		rotate(v=[0,1,0],a=90-angles[0])
		union()
		{
			translate([0,-size[1]/2,0])
				cube(size=[size[0],size[1],size[2]+height_extra]);
			rotate(v=[0,0,1],a=-angles[1])
			translate([0,0,size[2]/2])
			{
				translate([size[0]-screw_diam/2,0,screw_diff/2])
					rotate(v=[1,0,0],a=90)
						cylinder(d=screw_diam,h=size[2],$fn=12*quality,center=true);
				translate([size[0]-screw_diam/2,0,-screw_diff/2])
					rotate(v=[1,0,0],a=90)
						cylinder(d=screw_diam,h=size[2],$fn=12*quality,center=true);
			}
		}
	}
}

module bottle_cutter_base
(
	ext_size=2,
	ext_cut=[10,25],
	ext_ledge=[8,40,35],
	size=[50,20,48],
	screw_diam=3.5,
	case_shift=20,
	base_sz=10,
	band_sz=5,
	band_wd=1.25,
	quality=2,
)
{
	cutClt=0.1;
	difference()
	{
		union()
		{

			difference()
			{
				union()
				{
					translate([-case_shift, -size[1]+base_sz+band_sz, 0])
						cube_vround(size=size);
					translate([band_wd/2,-ext_ledge[1],-ext_size])
						cube_vround(size=[ext_ledge[0],ext_ledge[1],ext_ledge[2]],round_corners=[false,true,true,false]);
				}
				knife();
			}
			translate([-case_shift, -size[1]+base_sz+band_sz, -ext_size])
				cube_vround(size=[size[0],size[1],ext_size+cutClt]);
		}
		translate([-band_wd/2, -size[1]+band_sz, -cutClt-ext_size])
			cube([band_wd,size[1],size[2]+ext_size+2*cutClt]);
		translate([0, band_sz, size[2]-ext_cut[1]])
		{
			rotate(v=[1,0,0],a=90)
			linear_extrude(height=size[1]+ext_ledge[1])
			polygon(points=[[0,0],[0,ext_cut[1]],[0,ext_cut[1]+cutClt],[ext_cut[0],ext_cut[1]+cutClt],[ext_cut[0],ext_cut[1]]]);		
		}
	}
}

difference()
{
	bottle_cutter_base();
	
}
