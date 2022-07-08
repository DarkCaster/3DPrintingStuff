use <WallVentClip.scad>
use <WallTube.scad>
use <AirGate.scad>
use <CaseCover1.scad>
use <FilterCartridgeS.scad>

//projection(cut=true)
//rotate(v=[0,1,0],a=90)
//union()
{
	color([0.75,0.75,0])
	render()
	WallVentClip();

	rotate(a=180,v=[1,0,0])
	color([0.5,0.5,0])
	render()
	WallTube();

	color([0,1,0])
	translate([0,0,14])
	render()
	GateBase();

	color([0,0.6,0])
	translate([0,0,14])
	rotate(a=9,v=[0,0,1])
	render()
	GateClip1();

	translate([0,0,26])
	rotate(a=9,v=[0,0,1])
	render()
	ValvePart();

	color([0,0.2,0])
	translate([0,0,30])
	rotate(a=180,v=[1,0,0])
	render()
	GateClip2();

	color([0.4,0.6,0.4])
	CaseCover1();

	color([0.1,0.2,0.3])
	translate([0,0,37])
	CartridgeCaseHalf();
}

