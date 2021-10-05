use <bottom_section.scad>
use <top_section.scad>

bottom_section();

translate([0,0,82.5])
rotate([0,180,180])
color(alpha=0.5)
top_section();
