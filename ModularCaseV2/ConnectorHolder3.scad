use <../OpenSCAD_Modules/cube_vround.scad>

module NylonTieCut
(
	extra_width=2,
	width=3.2,
	//lock cut
	cutHeight=7,
	cutWidth=2,
)
{
	cutClr=0.1;
	translate([-extra_width-cutClr,-cutClr,0])
		cube(size=[width+2*cutClr+extra_width, cutWidth+2*cutClr, cutHeight]);
}

module PowerPlugHolder
(
	height=65,
	width=2,
	extra_width=5,
	depth=125,
	cornerCutR=6/2,
	quality=1,
//lock cut
	cutShift=5,
	cutHeight=7,
	cutWidth=2,
)
{
	cutClr=0.1;
	difference()
	{
		//case base
		translate([-extra_width,0,0])
			cube(size=[extra_width,height,depth]);

		translate([0,-cutClr,depth])
			rotate(a=90,v=[-1,0,0])
				cylinder(h=height+2*cutClr,r=cornerCutR,$fn=24*quality);
		translate([0,-cutClr,0])
			rotate(a=90,v=[-1,0,0])
				cylinder(h=depth+2*cutClr,r=cornerCutR,$fn=24*quality);

		translate([0,20,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,35,depth-cutShift])
			rotate(a=-90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);


		translate([0,20+7,cutShift])
			rotate(a=90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);
		translate([0,35+7,cutShift])
			rotate(a=90,v=[1,0,0])
				NylonTieCut(extra_width=extra_width);


		//corner cuts
		translate([-extra_width-cutClr,0-cutClr,-depth+8])
			cube(size=[extra_width+cutClr*2,8+cutClr,depth]);
		translate([-extra_width-cutClr,0-cutClr,depth-8])
			cube(size=[extra_width+cutClr*2,8+cutClr,depth]);
		translate([-extra_width-cutClr,height-16,depth-18])
			cube(size=[extra_width+cutClr*2,16+cutClr,depth]);
		translate([-extra_width-cutClr,height-16,-depth+18])
			cube(size=[extra_width+cutClr*2,16+cutClr,depth]);
		translate([0,height+cutClr,0])
			cylinder(h=depth+2*cutClr,r=cornerCutR,$fn=24*quality);
		
		//corner tie cuts
		translate([0,height-extra_width,30])
			rotate(a=-90,v=[1,0,0])
				rotate(a=-90,v=[1,0,0])
					NylonTieCut(extra_width=extra_width);
		translate([0,height-extra_width,50])
			rotate(a=-90,v=[1,0,0])
				rotate(a=-90,v=[1,0,0])
					NylonTieCut(extra_width=extra_width);
		translate([0,height-extra_width,80])
			rotate(a=-90,v=[1,0,0])
				rotate(a=-90,v=[1,0,0])
					NylonTieCut(extra_width=extra_width);
		translate([0,height-extra_width,100])
			rotate(a=-90,v=[1,0,0])
				rotate(a=-90,v=[1,0,0])
					NylonTieCut(extra_width=extra_width);
	}

}

PowerPlugHolder();


