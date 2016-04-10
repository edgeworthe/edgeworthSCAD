$fn=30;
left = 0;
right = 1;
hand_rotation = [[180,-30,0],[180,-30,0]];
lower_arm_rotation = [[0,-145,0],[0,-145,0]];
upper_arm_rotation = [[90,70,45],[-90,70,-45]];

torso_rotation = [0,10,0];
pelvis_rotation = [0,0,0];

upper_leg_rotation = [[0,-10,0],[0,-10,0]];
lower_leg_rotation = [[0,20,0],[0,20,0]];
foot_rotation = [[0,-10,0],[0,-10,0]];

head_rotation = [0,-10,0]; // tilt, nod, rotate

module hand(rotate,side) {
    // ball d=11mm
    // hand 27mm long, 15mm wide, 9mm high
    rotate(rotate[side]) {
        translate([6,0,-2]) difference() {
            translate([8,0,0]) scale([1.75,1,1]) sphere(8);
            rotate([0,-15,0]) translate([-5.5,-13.5,-29]) cube(27);
        }
        sphere(5.5);
    }
}

module lower_arm(rotate,side) {
    // 15mm at widest, 43mm long
    // TODO: consider doing intersection of bigger cube
    // rather than difference with two smaller
    rotate(rotate[side]) {
        translate([23,0,0]) difference() {
            scale([4,1,1]) sphere(7.5);
            translate([24,-7.5,-7.5]) cube(15);
            translate([-34,-7.5,-7.5]) cube(15);
        }
        // elbow joint 13mm wide
        sphere(6.5);
        translate([50,0,0]) hand(hand_rotation,side);
    }
}

module upper_arm(rotate,side) {
    // 16mm at widest, 45mm long
    // shoulder joint 18mm wide
    rotate(rotate[side]) {
        sphere(9);
        scale([1.2,1.2,1.2]) translate([23,0,0]) difference() {
            scale([4,1,1]) sphere(7.5);
            translate([24,-7.5,-7.5]) cube(15);
            translate([-34,-7.5,-7.5]) cube(15);
        }
        translate([59,0,0]) lower_arm(lower_arm_rotation,side);
    }
}

module head() {
    // neck 18mm sphere, head 35mm at widest, 47mm high, teardrop
    // down to 23mm wide flat
    // two flat chunks carved out for "nose"
    rotate(head_rotation) {
       sphere(8);
        intersection() {
            rotate([0,7,0]) translate([-55,0,0]) 
                scale([1,2,1]) rotate(-45) cube(47);
            hull() {
                translate([0,0,31]) sphere(16);
                translate([0,0,3]) cylinder(d=23);
            }
        }
    }
}

module torso(rotate) {
    // waist 28mm sphere, chest 38mm widest point, tapers
    // to 28mm at waist, has flat area at front, 50mm tall
    rotate(rotate) {
        sphere(15);
        intersection() {
            translate([-44,-30,7]) cube(60);
            hull() {
                translate([0,0,40]) scale([1,1,0.9]) sphere(20);
                translate([0,0,7]) cylinder(d=30);
            }
        }
        translate([0,0,60]) head();
        translate([0,-20,45]) upper_arm(upper_arm_rotation, right);
        translate([0,20,45]) upper_arm(upper_arm_rotation, left);
    }
}

module pelvis(rotate) {
    // 30mm top, 35mm bottom, 38mm widest, flats at back and front
    // 35mm tall
    rotate(rotate) {
        intersection() {
            translate([-20,-20,0]) cube([40,40,35]);
            translate([0,0,10]) scale([1,1,2]) sphere(19);
            translate([0,0,-45]) scale([1,1,3]) rotate([0,45,0]) 
                translate([-41,-20,0]) cube(40);
        }
        translate([0,0,40]) torso(torso_rotation);
        translate([0,-12,-3]) upper_leg(upper_leg_rotation, right);
        translate([0,12,-3]) upper_leg(upper_leg_rotation, left);
    }
}
module upper_leg(rotate, side) {
    // 17mm sphere, 57mm long, 17mm wide at top, 15mm wide bottom,
    // 22mm at widest point roughly 1/3rd from top
    // TODO: bottom cutout?
    rotate(rotate[side]) {
        sphere(9);
        hull() {
            translate([0,0,-57]) cylinder(d=15,h=50);
            intersection() {
                translate([0,0,-19]) scale([1,1,3]) sphere(11);
                translate([-11,-11,-62]) cube([22,22,57]);
            }
        }
        translate([0,0,-61]) lower_leg(lower_leg_rotation, side);
    }
}

module lower_leg(rotate, side) {
    // 13mm sphere, 65mm long, 15mm top, 14mm bottom,
    // 18mm widest 1/3rd from top
    // TODO: top cutout?
    rotate(rotate[side]) {
        sphere(7);
        hull() {
            translate([0,0,-70]) cylinder(d=12,h=60);
            intersection() {
                translate([0,0,-21.5]) scale([1,1,3]) sphere(9);
                translate([-11,-11,-69]) cube([22,22,65]);
            }
        }
        translate([0,0,-72]) foot(foot_rotation, side);
    }
}

// NOTE: ankle is too weak, needs more shoring up
module foot(rotate, side) {
    // 10mm sphere, 42mm long, 8mm high at highest, 5mm high
    // at heel, 18mm widest, 15mm wide at heel
    rotate(rotate[side]) {
        sphere(5);
        intersection() {
            translate([-6,-10,-7]) cube([45,20,10]);
            union() {
                translate([17,0,-7]) scale([2,1,0.9]) sphere(9);
                translate([-6,0,-10]) rotate([0,90,0]) 
                    cylinder(d=15,h=20);
            }
        }
    }
}

module full_body() {
    pelvis(pelvis_rotation);
}

module base() {
    cylinder(h=2.5,d1=25.4,d2=23);
}


translate([-2,0,23.5]) scale([0.15,0.15,0.15]) full_body();
base();