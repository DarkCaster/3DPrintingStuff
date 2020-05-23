module stand(
height=3,
inner_diam=3,
top_diam=5,
bottom_diam=7,
center_xy=false,
attach=0,
quality=0, //0 and up, 0 - use $fn
)
{
	assert(height>0)
	assert(inner_diam>0)
	assert(top_diam>0)
	assert(bottom_diam>0)
	assert(attach>=0)
	assert(inner_diam<top_diam)
	assert(bottom_diam>top_diam)
	assert(quality>=0);
	fn=quality>0?8*quality:$fn;
	translate([center_xy?0:bottom_diam/2,center_xy?0:bottom_diam/2,-attach])
	difference()
	{
			cylinder(h=height+attach,d1=bottom_diam,d2=top_diam,$fn=fn);
			cylinder(h=(height+attach)*3,d=inner_diam,center=true,$fn=fn);
	}
}

//stand();
//stand(height=2,attach=0.05,$fn=4);
//stand(height=2,attach=0.05,$fn=8);
//stand(height=2,attach=0.05,quality=1);
stand(height=2,attach=0.1,quality=2,center_xy=true);