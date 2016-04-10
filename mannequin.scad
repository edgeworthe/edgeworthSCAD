LEFT = 0;
RIGHT = 1;

module full_body(head_rotation, is_fist, hand_rotation,
                lower_arm_rotation, upper_arm_rotation,
                torso_rotation, pelvis_rotation,
                upper_leg_rotation, lower_leg_rotation,
                foot_rotation, base_foot_translation) {
    /* 
    Original was modeled on IRL mannequin, so scale
    down to ~40mm tall.
    */
    mannequin_scale = [0.15,0.15,0.15];
    scale(mannequin_scale) pelvis(pelvis_rotation);

    module hand(rotation,side) {
        rotate(rotation[side]) {
            if(is_fist[side]) {
                translate([9,0,0]) sphere(10);
            } else {
                translate([6,0,-2]) difference() {
                    translate([8,0,0]) scale([1.75,1,1]) sphere(8);
                    rotate([0,-15,0]) translate([-5.5,-13.5,-29])
                        cube(27);
                }
            }
            sphere(5.5);
        }
    }

    module lower_arm(rotation,side) {
        rotate(rotation[side]) {
            translate([21,0,0]) intersection() {
                scale([4,1,1]) sphere(7.5);
                translate([-19,-7.5,-7.5]) cube([43,15,15]);
            }
            sphere(6.5);
            translate([47,0,0]) hand(hand_rotation,side);
        }
    }

    module upper_arm(rotation,side) {
        rotate(rotation[side]) {
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
        rotate(rotate) {
            sphere(15);
            intersection() {
                translate([-44,-30,7]) cube(60);
                hull() {
                    translate([0,0,40]) scale([1,1,0.9]) 
                        sphere(20);
                    translate([0,0,7]) cylinder(d=30);
                }
            }
            translate([0,0,60]) head();
            translate([0,-20,45]) 
                upper_arm(upper_arm_rotation, RIGHT);
            translate([0,20,45]) 
                upper_arm(upper_arm_rotation, LEFT);
        }
    }

    module pelvis(rotate) {
        rotate(rotate) {
            intersection() {
                translate([-20,-20,0]) cube([40,40,35]);
                translate([0,0,10]) scale([1,1,2]) sphere(19);
                translate([0,0,-45]) 
                    scale([1,1,3]) rotate([0,30,0]) 
                        translate([-36,-20,7]) cube(40);
            }
            translate([0,0,40]) torso(torso_rotation);
            translate([0,-12,-3]) 
                upper_leg(upper_leg_rotation, RIGHT);
            translate([0,12,-3]) 
                upper_leg(upper_leg_rotation, LEFT);
        }
    }
    module upper_leg(rotation, side) {
        rotate(rotation[side]) {
            sphere(12);
            hull() {
                translate([0,0,-57]) cylinder(d=17,h=50);
                intersection() {
                    translate([0,0,-19]) scale([1,1,3]) sphere(13);
                    translate([-13,-13,-62]) cube([26,26,57]);
                }
            }
            translate([0,0,-61]) 
                lower_leg(lower_leg_rotation, side);
        }
    }

    module lower_leg(rotation, side) {
        rotate(rotation[side]) {
            sphere(9);
            hull() {
                translate([0,0,-70]) cylinder(d=12,h=60);
                intersection() {
                    translate([0,0,-21.5]) scale([1,1,3])
                        sphere(10);
                    translate([-11,-11,-69]) cube([22,22,65]);
                }
            }
            translate([0,0,-72]) foot(foot_rotation, side);
        }
    }

    module foot(rotation, side) {
        rotate(rotation[side]) {
            sphere(6);
            intersection() {
                translate([-6,-10,-7]) cube([45,20,10]);
                hull() {
                    translate([17,0,-7]) scale([2,1,0.9])
                        sphere(9);
                    translate([-6,0,-8]) rotate([0,90,0]) 
                        cylinder(d=15,h=20);
                }
            }
        }
        if(side == base_foot_translation[0]) {
            rotate(rotation[side]) 
                translate([0,0,-25]) // move to sole
                    translate(base_foot_translation[1]) base();
        }
    }

    module base() {
        difference() {
            cylinder(h=18,d1=168,d2=153);
            //translate([0,0,-0.1]) cylinder(h=9,d1=149,d2=142);
        }
    }
}

module sample_model() {
    // wide stance, hands on hips
    full_body(
        [0,0,0], // head_rotation: tilt, nod, rotate
        [0,0], // is_fist: left, right
        [[0,-61,0],[0,-61,0]], // hand_rotation: L, R
        [[0,95,0],[0,95,0]], // lower_arm_rotation: L, R
        [[0,48,99],[0,48,-99]], // upper_arm_rotation: L, R

        [0,-5,0], // torso_rotation
        [0,5,0], // pelvis_rotation

        [[10,-10,0],[-10,-10,0]], // upper_leg_rotation: L, R
        [[0,10,0],[0,10,0]], // lower_leg_rotation: L, R
        [[-10,-5,0],[10,-5,0]], // foot_rotation: L, R
        [0,[10,-35]] // base foot (L or R), translation
    );
}

module zeroed_stance() {
    full_body(
        [0,0,0], // head: tilt, nod, rotate
        [0,0],   // fists
        [[0,0,0],[0,0,0]], // hands
        [[0,0,0],[0,0,0]], // lower_arm
        [[0,0,0],[0,0,0]], // upper_arm
    
        [0,0,0], // torso
        [0,0,0], // pelvis
    
        [[0,0,0],[0,0,0]], // upper_leg
        [[0,0,0],[0,0,0]], // lower_leg
        [[0,0,0],[0,0,0]], // foot
        [0, [10,-10]] // base foot translation
    );
}

module monk_stance() {
    full_body(
        [-5,-5,50], // head: tilt, nod, rotate
        [0,0],   // fists
        [[0,0,0],[0,0,0]], // hands
        [[0,0,-30],[30,0,90]], // lower_arm
        [[-10,0,50],[30,30,-70]], // upper_arm
    
        [0,10,10], // torso
        [0,0,0], // pelvis
    
        [[32,-30,0],[-32,-30,0]], // upper_leg
        [[0,60,0],[0,60,0]], // lower_leg
        [[-27,-24,0],[27,-24,0]], // foot
        [0, [-5,-65]] // base foot translation
    );
}

module challenger_stance() {
    full_body(
        [0,10,0], // head: tilt, nod, rotate
        [1,1],   // fists
        [[0,0,0],[0,0,0]], // hands
        [[0,95,0],[0,95,0]], // lower_arm
        [[0,45,90],[0,45,-90]], // upper_arm
    
        [0,10,0], // torso
        [0,0,0], // pelvis
    
        [[10,-10,0],[-10,-10,0]], // upper_leg
        [[0,20,0],[0,20,0]], // lower_leg
        [[-10,-10,0],[10,-10,0]], // foot
        [0, [20,-35]] // base foot translation
    );
}

sample_model();
