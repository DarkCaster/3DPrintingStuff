use <opi_section.scad>
use <psu-meanwell-rs15-5_section.scad>

translate([66/2,-98/2,0])
rotate(a=-90,v=[0,0,1])
psu_rs15_section(center_xy=true);

translate([112/2,160/2,opi_payload_height()])
rotate(a=180,v=[0,1,0])
opi_section(center_xy=true);
