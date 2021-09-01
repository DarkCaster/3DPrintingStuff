use <../OpenSCAD_Modules/cube_vround.scad>

module ClipHole
(
	holeLen=10,
	height=2,
	diam=4,
	rot=-45,
	quality=2,
	cutClr=0.1,
)
{
	rotate(a=rot,v=[0,0,1])
	translate([0,0,-cutClr])
	hull() {
		cylinder(d=diam,h=height+cutClr*2,$fn=12*quality);
		translate([10,0,0])
			cylinder(d=diam,h=height+cutClr*2,$fn=12*quality);
	}
}

module NutPocket
(
	nutDiam=6,
	nutHeight=2.5,
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

module ExtClip
(
	size=[20,10,10],
	holeDiam=3.5,
	nutDiam=6,
	nutHeight=2.5,
	quality=2,
	cutClr=0.1,
)
{
	translate([0,0,-cutClr])
	difference()
	{
		cube_vround(size=size,center_xy=true,rounding=min(size[0],size[1])/2,quality=quality);
		translate([0,0,size[2]/2])
			rotate(a=90,v=[1,0,0])
				cylinder(d=holeDiam,h=size[1]+cutClr,center=true,$fn=12*quality);
		translate([0,0,size[2]/2])
			NutPocket(nutDiam=nutDiam,nutHeight=nutHeight,pocketLen=size[2]/2+cutClr);
	}
}

module WallVentClip
(
	size=[160,160,2],
	holesDiff=[150,150],
	wallHolesLen=10,
	wallHolesDiam=3.5,
	intHolesDiam=3.5,
	height=10,
	centralHoleDiam=125,
	centralWallDiams=[135,145],
	extClipSize=[20,10],
	extClipDiff=[100,100],
	nutDiam=6,
	nutHeight=2.5,
	quality=2,
)
{
	cutClr=0.1;
	union()
	{
		translate([0,0,-size[2]])
			difference()
			{
				cube_vround(size=size,center_xy=true,rounding=5,quality=quality);
				for (x=[-1:2:1],y=[-1:2:1])
					translate([x*holesDiff[0]/2,y*holesDiff[1]/2,0])
						mirror([x>0&&y>0?1: x>0&&y<0?1: 0, x>0&&y<0?-1: x<0&&y<0?-1:0, 0])
							ClipHole(holeLen=wallHolesLen,height=size[2],diam=wallHolesDiam);
				translate([0,0,-cutClr])
					cylinder(d=centralHoleDiam,h=size[2]+cutClr*2,$fn=12*quality);
			}
		difference()
		{
			translate([0,0,-cutClr])
				cylinder(d=centralWallDiams[1],h=height+cutClr,$fn=12*quality);
			translate([0,0,-2*cutClr])
				cylinder(d=centralWallDiams[0],h=height+4*cutClr,$fn=12*quality);
			for (i=[0:1])
				translate([0,0,height/2])
					rotate(a=90,v=[i>0?1:0,i>0?0:1,0])
						cylinder(d=intHolesDiam,h=max(size[0],size[1])+cutClr*2,center=true,$fn=12*quality);
		}

		for(d=[0:1])
			rotate(a=90,v=[0,0,d])
				for (j=[-1:2:1])
					translate([0,j*size[1-d]/2-j*extClipSize[1]/2,0])
						for (i=[-1:2:1])
							translate([i*extClipDiff[d]/2,0,0])
								ExtClip(size=[extClipSize[0],extClipSize[1],height],holeDiam=intHolesDiam,nutDiam=nutDiam,nutHeight=nutHeight,quality=quality);
	}
}

WallVentClip();
