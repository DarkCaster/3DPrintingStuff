/*
<gt2.scad>
Copyright (C) 2022  Alessandro Garosi (tdo_brandano@hotmail.com)

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

//Returns an inverted vector
function v_invert(v) = [for (i=[1:1:len(v)]) v[len(v)-i]];

//Tests if two points are the same with an error of delta.
function p_match(p1, p2, delta=0.0001) = p1[0]<=(p2[0]+delta) 
    && p1[0]>=(p2[0]-delta) && p1[1]<=(p2[1]+delta) && p1[1]>=(p2[1]-delta);

//Removes consecutive duplicate points from a vector
//Tried to use it to remove doubles, but can't quite get it to work
function rm_dup(v) = [for (i=[0:1:len(v)-1]) if (i==0 || !p_match(v[i], v[i-1])) v[i]];

//Work out how many segments for an angle
//This does not exactly respect the $fa and $fn definition, but approximates it 
//so that it will always have an end point matching the end of the arch
function a2d_seg(a) = $fn ? ($fn/360)*a : a/$fa;

//Coordinates for a point at a set distance and angle from the origin
function a2d_pt(r, a) = [sin(a)*r,cos(a)*r];

//Coordinates for the points of an arch
function a2d(r, a) = [for (i=[0:(a/ceil(a2d_seg(a))):a]) a2d_pt(r, i)];

//Translation of a list of 2d coordinates
function v2d_tx(xy, v) = [for (p=v) [p[0]+xy[0],p[1]+xy[1]]];
    
//Rotation of a list of 2d coordinates
function v2d_rot(a, v) = [for (p=v) [p[0]*cos(a)-p[1]*sin(a), p[1]*cos(a)+p[0]*sin(a)]];

//Translates by a radius and "bends" a list of points. This allows the creation of an arc of a circumference
//from a list of points. good to make pulleys.
function v2d_bend(r, v) = [for (p=v, a=p[0]/((2*PI*r)/360))[(p[1]+r)*sin(a), (p[1]+r)*cos(a)]];

//Return the coordinates for a single GT2 tooth, shaped out of 5 arcs
function gt2_t() = concat(
    v2d_tx([-0.74,-0.404], v2d_rot(0, a2d(0.15, 82.5))),
    v2d_tx([0.4, -0.254], v2d_rot(116, v_invert(a2d(1,18.5)))),
    v2d_tx([0,-0.449], v2d_rot(244, v_invert(a2d(0.555,128)))),
    v2d_tx([-0.4, -0.254], v2d_rot(-97.5, v_invert(a2d(1,18.5)))),
    v2d_tx([0.74,-0.404], v2d_rot(90, a2d(0.15, 82.5)))
);


//Profile of N gt2 teeth
function gt2_ts(tn) = rm_dup([for (i=[0:tn], vtx=v2d_tx([2*i,0], gt2_t())) vtx]);

module gt2_2d(teeth=10){
    tn=teeth;
    //Add the back of the belt to close the polygon
    pts = concat(gt2_ts(tn),[[tn*2+1,-0.254], [tn*2+1,0.376], [-1,0.376], [-1,-0.254]]);
    polygon(pts);
}

module gt2_belt(length=10, h=6, center=false){
    dx=center?-length/2:0;
    dz=center?-h/2:0;
    translate([dx,0,dz]) difference(){
        translate([1,0,0])linear_extrude(height=h, convexity=10){
            gt2_2d(floor(abs(length)/2));
        };
        translate([abs(length),-2,-1]) cube([3, 4, h+2]);
    }
}

module gt2_pulley_2d(teeth=16, grow=0.0){
    //We must keep the distance between teeth at the "nominal" depth at 2mm, 
    //I leave the nominal depth at 0 in gt2_t, which makes this easy.
    //So we first work out the radius.
    r=(teeth*2)/(2*PI);
    pts=v2d_bend(r, gt2_ts(teeth-1));
    //This is ugly, but I still get thin faces that break rendering, hence
    //the two small "offset" operations to remove doubles
    offset(grow) offset(delta=-0.0001) offset(delta=0.0001) polygon(pts);
}


module gt2_pulley(teeth=16, h=7, center=false, grow=0.0){
    translate([0,0,center?-h/2:0])linear_extrude(h)gt2_pulley_2d(teeth, grow);
}

//demo
//translate([0,10,0]) gt2_pulley(32, h=10, center=true);
//translate([0,-10,0]) gt2_belt(20, center=true);
