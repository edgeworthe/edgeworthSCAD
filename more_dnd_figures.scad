$fn=100;
base_height=2.5;
module base() {
    cylinder(h=base_height,d1=25,d2=23);
}

module figure_head() {
    head_radius=3;
    translate([0,0,31-head_radius]) sphere(head_radius);
}

module identifier(id) {
    logo_font="PT Serif:style=Bold";
    translate([-10.5,-7,0]) rotate(a=[75,0,0]) 
        scale([1.5,1.5,1.5]) translate([5,5.5]) 
            linear_extrude(height=1.5)
                text(str(id), size=5, font=logo_font);
}

module dual_identifier(id) {
    identifier(id);
    rotate(a=180) identifier(id);
}

module pyramid_figure() {
    base_coord=7;
    waist_height=23;
    waist_coord=2.5;
    shoulder_height=33;
    shoulder_width=4;
    polyhedron(points=[[-base_coord,-base_coord,0],
                 [base_coord,-base_coord,0],
                 [base_coord,base_coord,0],
                 [-base_coord,base_coord,0],
                 [-waist_coord,-waist_coord,waist_height],
                 [waist_coord,-waist_coord,waist_height],
                 [waist_coord,waist_coord,waist_height],
                 [-waist_coord,waist_coord,waist_height],
                 [-shoulder_width,-shoulder_width,shoulder_height],
                 [shoulder_width,-shoulder_width,shoulder_height],
                 [shoulder_width,shoulder_width,shoulder_height],
                 [-shoulder_width,shoulder_width,shoulder_height]],
               faces=[[0,1,2,3],
                 [0,4,5,1],[5,4,8,9],[1,5,6,2],[6,5,9,10],
                 [3,2,6,7],[7,6,10,11],[0,3,7,4],[4,7,11,8],
                 [11,10,9,8]]);
}

module figure() {
    translate([0,0,base_height]) {
        figure_head();
        scale([1,1,0.75]) {
            translate([-7,1.5,24]) scale([1,1,1.75]) 
                rotate(a=[90,45,0]) cube([10,10,3]);
            pyramid_figure();
        }
    }
    base();
}

module identified_figure(i) {
    figure();
    dual_identifier(i);
}

module figures() {
    for(i=[0:9]) {
        x=15+30*(i%3);
        y=15+30*floor(i/3);
        translate([x,y]) {
            identified_figure(i);
        }
    }
}

identified_figure("e");
//figures();
