use <../OpenSCAD_Modules/cube_vround.scad>
use <../OpenSCAD_Modules/stand.scad>

module adapter()
{
	// http://support.wdc.com/images/kb/3_5_emount.jpg
	adapter_szx=90;
	adapter_szy=105;
	holes_szx=44.45;
	holes_szy=95.25;
	adapter_holes_szx=79;
	bracket_sz=10;
	ngff_szx=41;
	difference()
	{
		union()
		{
			difference()
			{
				//base
				cube_vround(size=[adapter_szx,adapter_szy,3], round_corners=[true,true,true,true],
				rounding=5, center_xy=true, center_z=false, attach=0, wall_attach=0, quality=2);
				//hdd cliping holes
				translate([holes_szx/2,holes_szy/2,0])
					cylinder(d=3.1,h=6.1,center=true,$fn=12);
				translate([holes_szx/2,-holes_szy/2,0])
					cylinder(d=3.1,h=6.1,center=true,$fn=12);
				translate(-[holes_szx/2,holes_szy/2,0])
					cylinder(d=3.1,h=6.1,center=true,$fn=12);
				translate(-[holes_szx/2,-holes_szy/2,0])
					cylinder(d=3.1,h=6.1,center=true,$fn=12);
				//ngff adapter mount holes 
				translate([adapter_holes_szx/2,-ngff_szx/2,0])
					cylinder(d=3,h=6.1,center=true,$fn=24);
				translate([-adapter_holes_szx/2,-ngff_szx/2,0])
					cylinder(d=3,h=6.1,center=true,$fn=24);
			}
			//ngff stands
			translate([adapter_holes_szx/2,-ngff_szx/2,2.9])
				stand(height=2, inner_diam=3, top_diam=6, bottom_diam=8, center_xy=true, attach=0, quality=3);
			translate([-adapter_holes_szx/2,-ngff_szx/2,2.9])
				stand(height=2, inner_diam=3, top_diam=6, bottom_diam=8, center_xy=true, attach=0, quality=3);
			//ngff bracket
			translate([0,bracket_sz/2+ngff_szx/2-1,2.9])
				cube_vround(size=[adapter_szx,bracket_sz,2], round_corners=[true,true,true,true],
				rounding=2, center_xy=true, center_z=false, attach=0, wall_attach=0, quality=2);
		}
		//ngff bracket mount holes
		translate([adapter_holes_szx/2,bracket_sz/2+ngff_szx/2,0])
			cylinder(d=3,h=30,center=true,$fn=24);
		translate([-adapter_holes_szx/2,bracket_sz/2+ngff_szx/2,0])
			cylinder(d=3,h=30,center=true,$fn=24);
	}
}


adapter();
