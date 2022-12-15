use <../OpenSCAD_Modules/cube_vround.scad>

//back
height=40;
width1=15;
width2=5;
length=35;

//front
fheight=30;
fwidth1=17;
flength=24;
fh_down=(height-fheight)/2;

//front cut
fcheight=20;
fcwidth=12;
fcdepth=2;
fch_down=(height-fcheight)/2;
fch_up=height-fch_down;

//rear_cut
rcheight=27;
rclength=20;
rc_down=(height-rcheight)/2;
rc_up=height-rc_down;
rc_shift=fh_down;


cut_clr=1;

difference()
{

translate([0,length/2, 0])
rotate(a=90,v=[1,0,0])
linear_extrude(height=length)
polygon(points=[
	[0,0],
	[-width1,0],
	[-width2,height],
	[fwidth1,height],
	[fwidth1,0],
]);

translate([0,flength/2, 0])
rotate(a=90,v=[1,0,0])
linear_extrude(height=flength)
polygon(points=[
	[0,fh_down],
	[0,height+cut_clr],
	[fwidth1+cut_clr,height+cut_clr],
	[fwidth1+cut_clr,fh_down],
]);

for(i=[-1:2:1])
translate([0,i*(length+cut_clr)/2, 0])
translate([0,(fcdepth+cut_clr)/2, 0])
rotate(a=90,v=[1,0,0])
linear_extrude(height=fcdepth+cut_clr)
polygon(points=[
	[0,fch_down],
	[0,fch_up],
	[fcwidth,fch_up],
	[fcwidth,fch_down],
]);

translate([0,(rclength)/2, rc_shift/2])
rotate(a=90,v=[1,0,0])
linear_extrude(height=rclength)
polygon(points=[
	[cut_clr,rc_down],
	[cut_clr,rc_up],
	[-width1-cut_clr,rc_up],
	[-width1-cut_clr,rc_down],
]);


}
