$fn=100;
module base() {
    cylinder(h=2.5,d1=25,d2=23);
}

module head() {
    head_radius=3;
    translate([0,0,40-head_radius]) sphere(head_radius);
}

module old_pyramid_figure() {
    polyhedron(points=[[-10,0,0],[0,-10,0],
                       [10,0,0], [0,10,0],
                       [0,0,35]],
               faces=[[0,1,4],[1,2,4],[2,3,4],[3,0,4],
                      [0,1,2,3]]);
    shoulder_height=33;
    shoulder_width=5.75;
    polyhedron(points=[[-shoulder_width,0,shoulder_height],
                       [0,-shoulder_width,shoulder_height],
                       [shoulder_width,0,shoulder_height],
                       [0,shoulder_width,shoulder_height],
                       [0,0,10]],
               faces=[[0,1,4],[1,2,4],[2,3,4],[0,3,4],
                      [0,2,3],[0,1,2]]);
}

module identifier(id) {
    logo_font="PT Serif:style=Bold";
    translate([-10.5,-7,0]) rotate(a=[78.5,0,0]) 
        scale([1.5,1.5,1.5]) translate([5,5.5]) 
            linear_extrude(height=1.5)
                text(str(id), size=5, font=logo_font);
}

module dual_identifier(id) {
    identifier(id);
    rotate(a=180) identifier(id);
}

module old_figure() {
    translate([0,0,2.5]) {
        head();
        translate([-7,1.5,24]) scale([1,1,1.75]) 
            rotate(a=[90,45,0]) cube([10,10,3]);
        rotate(a=[0,0,45]) old_pyramid_figure();
    }
    base();
}

module pyramid_figure() {
    base_coord=7;
    waist_height=22;
    waist_coord=2.5;
    shoulder_height=33;
    shoulder_width=4.5;
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
                       [-shoulder_width,shoulder_width,shoulder_height]
                       ],
               faces=[[0,1,2,3],
                      [0,4,5,1],[5,4,8,9],[1,5,6,2],[6,5,9,10],
                      [3,2,6,7],[7,6,10,11],[0,3,7,4],[4,7,11,8],
                      [11,10,9,8]
                      ]);
}

module figure() {
    translate([0,0,2.5]) {
        head();
        translate([-7,1.5,24]) scale([1,1,1.75]) rotate(a=[90,45,0]) cube([10,10,3]);
        pyramid_figure();
    }
    base();
}

module figures() {
    for(i=[0:9]) {
        x=15+30*(i%3);
        y=15+30*floor(i/3);
        translate([x,y]) {
            figure();
            dual_identifier(i);
        }
    }
}

figures();