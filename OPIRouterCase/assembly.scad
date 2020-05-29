use <opi_zero_section.scad>
use <dub_e100_e1_section.scad>
use <psu-meanwell-rs15-5_section.scad>
use <top_section.scad>

//Section size: X;Y
Size=[110,64]; //[50:1:200]

//3D-pr. nozzle-size
Nozzle=0.4; //[0.1:0.1:0.8]

//3D-pr. Layer size
Layer=0.2; //[0.05:0.05:0.5]

//Target wall size
Wall=1.6; //[0.1:0.1:4]

//Target base size
Base=1.6; //[0.1:0.1:4]

//Screw diameter
Screw_Diam=3; //[1:0.1:5]

//Screw clearance (will be added to screw diameter)
Screw_Clearance=0.2; //[0.01:0.01:0.5]

//Rendering quality of round surfaces
Quality=2; //[1:1:10]

//Render target
Target=0; // [0:Assembly, 1:OrangePI Section, 2:DUB-E100 Section, 3:PSU Section, 4:Top cover]

FinalWallSz=ceil(Wall/Nozzle)>=2?ceil(Wall/Nozzle)*Nozzle:2*Nozzle;
echo("FinalWallSz:",FinalWallSz);

FinalBaseSz=ceil(Base/Layer)>=2?ceil(Base/Layer)*Layer:2*Layer;
echo("FinalBaseSz:",FinalBaseSz);

/* [Hidden] */

height1=0;
height2=opi_zero_section_height(base_sz=FinalBaseSz)+height1;
height3=dub_e100_section_height(base_sz=FinalBaseSz)+height2;
height4=psu_rs15_section_height(base_sz=FinalBaseSz)+height3;

if(Target==0 || Target==1)
{
	echo("opi_zero_section_height()=",opi_zero_section_height());
	translate([0,0,Target==0?height1:0])
		opi_zero_section(size=Size,
			wall_sz=FinalWallSz,
			base_sz=FinalBaseSz,
			screw_diam=Screw_Diam,
			screw_clearance=Screw_Clearance,
			center_xy=true);
}

if(Target==0 || Target==2)
{
	echo("dub_e100_section_height()=",dub_e100_section_height());
	translate([0,0,Target==0?height2:0])
		dub_e100_section(size=Size,
			wall_sz=FinalWallSz,
			base_sz=FinalBaseSz,
			screw_diam=Screw_Diam,
			screw_clearance=Screw_Clearance,
			center_xy=true);
}

if(Target==0 || Target==3)
{
	echo("psu_rs15_section_height()=",psu_rs15_section_height());
	translate([0,0,Target==0?height3:0])
		psu_rs15_section(size=Size,
			wall_sz=FinalWallSz,
			base_sz=FinalBaseSz,
			screw_diam=Screw_Diam,
			screw_clearance=Screw_Clearance,
			center_xy=true);
}

if(Target==0 || Target==4)
{
	echo("top_section_height()=",top_section_height());
	translate([0,0,Target==0?height4:0])
		top_section(size=Size,
			wall_sz=FinalWallSz,
			base_sz=FinalBaseSz,
			screw_diam=Screw_Diam,
			screw_clearance=Screw_Clearance,
			center_xy=true);
}