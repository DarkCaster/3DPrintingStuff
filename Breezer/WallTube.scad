module HNutPocket
(
	nutDiam=6.75,
	nutHeight=2.6,
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
	nutDiam=6.5,
	nutHeight=2.6,
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

module WallTube
(
	intHolesDiam=3.75,
	extDiam=135,
	extHeight=10,
	intDiam=97,
	intHeight=75,
	wallSize=2,
	nutDiam=6.75,
	horNutHeight=3,
	vertNutHeight=2.8,
	vertClipsDiam=120,
	horClipsExtDepth=6,
	quality=2,
	stub_layer_width=0.3,
)
{
	cutClr=0.1;
	union()
	{

	difference()
	{
		union()
		{
			translate([0,0,-cutClr])
				cylinder(d=intDiam, h=intHeight+cutClr,$fn=12*quality);
			translate([0,0,-extHeight])
				cylinder(d=extDiam, h=extHeight,$fn=12*quality);
		}
		translate([0,0,-extHeight-cutClr])	
			cylinder(d=intDiam-wallSize*2, h=intHeight+extHeight+2*cutClr,$fn=12*quality);

		for (i=[0:3])
			rotate(a=90*i+45,v=[0,0,1])
				translate([vertClipsDiam/2,0,-extHeight/2])
				{
					HNutPocket(nutDiam=nutDiam,nutHeight=horNutHeight,pocketLen=(extDiam-vertClipsDiam));
					cylinder(d=intHolesDiam,h=extHeight+cutClr*2,center=true,$fn=12*quality);
				}
		for (i=[0:3])
			rotate(a=90*i,v=[0,0,1])
				translate([0,vertClipsDiam/2,-extHeight/2])
				{
					VNutPocket(nutDiam=nutDiam,nutHeight=vertNutHeight,pocketLen=extHeight/2+cutClr);
					translate([0,-horClipsExtDepth,0])
						rotate(a=-90,v=[1,0,0])
							cylinder(d=intHolesDiam,h=(extDiam-vertClipsDiam)+horClipsExtDepth,$fn=12*quality);
				}
	}

	//extra stub layer
	difference()
	{
		translate([0,0,-extHeight])
			cylinder(d=extDiam, h=stub_layer_width, $fn=12*quality);
		translate([0,0,-extHeight-cutClr])
			cylinder(d=intDiam-wallSize*2, h=stub_layer_width+2*cutClr, $fn=12*quality);
	}

	}
}

WallTube();
