module StandBase
(
	height1=25.4,
	diam1=25.5,
	height2=11.4,
	diam2=26.25,
	quality=2,
)
{
	clr=0.1;
	translate([0,0,-clr])
	{
		union()
		{
			cylinder(h=height1+clr,d=diam1,$fn=6);
			cylinder(h=height2+clr,d=diam2,$fn=12*quality);
		}
	}
}

module StandBottom
(
	height1=10,
	diam1=35,
	height2=1,
	diam2=32,
	quality=2,
)
{
	clr=0.1;
	union()
	{
		translate([0,0,-height1])
			cylinder(h=height1,d=diam1,$fn=12*quality);
		difference()
		{
			translate([0,0,-clr])
				cylinder(h=height2+clr,d=diam1,$fn=12*quality);
			cylinder(h=height2+clr,d=diam2,$fn=12*quality);
		}
	}
}

module Cuts
(
	height1=11.4-1+10,
	height2=25.4+10-5,
	heightBt=10,
	diam1=26.25-8*0.4,
	diam2=12,
	quality=2,
)
{
	clr=0.1;
	union()
	{
		translate([0,0,-heightBt-clr])
			cylinder(h=height1+clr,d=diam1,$fn=12*quality);
		translate([0,0,-heightBt-clr])
			cylinder(h=height2+clr,d=diam2,$fn=12*quality);
	}
}

module Fins
(
	height1=11.4-1+10,
	height2=25.4+10-5,
	heightBt=10,
	diam1=26.25-8*0.4,
	diam2=12,
	finWidth=8*0.4
)
{
	clr=0.1;
	union()
	{
		translate([0,0,-heightBt+height1/2])
		{
			cube([diam1,finWidth,height1],center=true);
			rotate(a=90,v=[0,0,1])
				cube([diam1,finWidth,height1],center=true);
		}
		translate([0,0,-heightBt+height2/2])
		{
			cube([diam2,finWidth,height2],center=true);
			rotate(a=90,v=[0,0,1])
				cube([diam2,finWidth,height2],center=true);
		}
	}
}

union()
{
	difference()
	{
		union()
		{
			StandBase();
			StandBottom();
		}
		Cuts();
	}
	Fins();
}
