$fn=100;
/*
 * Meeple-style Fantasy figures based on Meeples for
 * Lords of Waterdeep by CTRLurself at
 * http://www.thingiverse.com/thing:510702, adding
 * bases inspired by https://www.heroforge.com/
 */

// D&D 1-inch base
module base() {
    rotate_extrude(angle=360) {
        polygon(points=[[0,0], [12.7,0], 
                        [11.5,2.5], [0,2.5]]);
    }
}

meeple_xmid = 7;
meeple_ymid = 7.5;
meeple_width = 3;
module head() {
    translate([meeple_xmid,12,0])
        circle(3);
}
module legs() {
    difference() {
        polygon(points=[[0,0],
                        [14,0],
                        [meeple_xmid,15]]);
        polygon(points=[[6,0],
                        [8,0],
                        [meeple_xmid,2]]);
    }
}

module arms() {
    translate([meeple_xmid,meeple_ymid,0])
        scale([7,3]) circle(1);
}

module basic_meeple() {
        head();
        legs();
        arms();
}

module keyhole() {
    translate([meeple_xmid,8.5,0]) circle(1.5);
    translate([meeple_xmid-0.9,4,0]) square([1.8,5]);
}

module daggers() {
    polygon([[1,8],[0,13],[3,8]]);
    polygon([[13,8],[14,13],[11,8]]);
}

module red_cross() {
    width=2;
    length=6;
    translate([meeple_xmid-(width/2),meeple_ymid-(length/2),0])
        square([width,length]);
    translate([meeple_xmid-(length/2),meeple_ymid-(width/2),0])
        square([length,width]);
}

module hammer() {
    translate([0.25,7,0])
        square([1.5,meeple_ymid*2-7]);
    translate([-1.5,12,0])
    intersection() {
        square([5,2.5]);
        translate([2.5,1.25]) scale([1.35,1]) circle(2);
    }
}

module wizard_logo() {
    translate([meeple_xmid,meeple_ymid+1.5])
    scale([1.25,1])
    rotate(a=10)
        polygon(points=[[0,2],
                        [1,-3], [0,-2],
                        [0,-5], [-1,-4],
                        [-1,-7], [-2,-2],
                        [-1,-3], [-1, 0],
                        [0,-1]]);
}

module staff() {
    square([1.1,meeple_ymid*2-1]);
    translate([0.55,meeple_ymid*2-1.3])
        circle(1.3);
}

module robe() {
    polygon(points=[[6,0],
                    [8,0],
                    [meeple_xmid,2]]);
}

module wizard_hat() {
        translate([meeple_xmid,13.5,0]) {        
            scale([3.5,1]) circle(1);
            rotate(a=25)
                difference() {
                    scale([2,4.5]) circle(1);
                    translate([-2.75,3.5]) circle(2.25);
                }
        }
}

module shield() {
    translate([meeple_xmid,meeple_ymid+0.5])
    difference() {
        intersection() {
            translate([-1.6,0]) circle(4);
            translate([1.6,0]) circle(4);        
        }
        union() {
            translate([-5,1]) square(20);
            translate([-1,2]) circle(1.85);
            translate([1,2]) circle(1.85);
        }
    }
}

module axe() {
    square([1.1,meeple_ymid*2-1.5]);
        translate([0.55,meeple_ymid*2-3]) 
        difference() {
            circle(3);
            union() {
                translate([0,3.75]) circle(3);
                translate([0,-3.75]) circle(3);
            }
        }
}

module bow() {
    translate([meeple_xmid+2, meeple_ymid]) difference() {
        circle(10);
        translate([1.2,0]) circle(10);
        translate([-5,-25]) square(50);
    }
}

module arrow() {
    translate([meeple_xmid+3,meeple_ymid]) rotate(a=90) scale([1.5,1.5,1]) {
        square([0.5,4]);
        translate([-0.25,3.75])
            polygon([[0,0],[0.5,0.1],[1,0],
                     [0.5,1]]);
        for(i=[0:2]) {
            translate([0.25,i*0.6+0.35]) rotate(a=225)
                polygon([[0,0], [0,0.85], 
                         [0.25,0.85], [0.25,0.25],
                         [0.85,0.25], [0.85,0]]);
        }
    }
}

module archer() {
    scale([1.25,1,1.25])
    translate([-meeple_xmid,meeple_width/2,2]) 
        rotate (a=[90,0,0]) 
    linear_extrude(height=meeple_width) {
        difference() {
            basic_meeple();
            arrow();
        }
        bow();
    }
    base();
}

module cleric() {
    scale([1.25,1,1.25])
    translate([-meeple_xmid,meeple_width/2,2]) 
        rotate (a=[90,0,0]) 
    linear_extrude(height=meeple_width) {
        difference() {
            basic_meeple();
            red_cross();
        }
        hammer();
    }
    base();
}

module rogue() {
    scale([1.25,1,1.25])
    translate([-meeple_xmid,meeple_width/2,2]) 
        rotate (a=[90,0,0]) 
    linear_extrude(height=meeple_width) {
        difference() {
            basic_meeple();
            keyhole();
        }
        daggers();
    }
    base();
}

module warrior() {
    scale([1.25,1,1.25])
    translate([-meeple_xmid,meeple_width/2,2]) 
        rotate (a=[90,0,0]) 
            linear_extrude(height=meeple_width) {
        difference() {
            basic_meeple();
            shield();
        }
        axe();
    }
    base();
}

module wizard() {
    scale([1.25,1,1.25])
    translate([-meeple_xmid,meeple_width/2,2]) 
        rotate (a=[90,0,0]) 
    linear_extrude(height=meeple_width) {
        difference() {
            basic_meeple();
            wizard_logo();
        }
        wizard_hat();
        staff();
        robe();
    }
    base();
}

module alpha_plain(id) {
    scale([1.25,1,1.25])
    translate([-meeple_xmid,meeple_width/2,2]) 
        rotate (a=[90,0,0]) 
    linear_extrude(height=meeple_width) {
        difference() {
            basic_meeple();
            translate([meeple_xmid-2,meeple_ymid-3])
                text(id, size=5, font="Liberation Mono:style=Bold");
        }
    }
    base();
}

module alpha_reinforce(id) {
    scale([1.25,1,1.25])
    translate([-meeple_xmid,meeple_width/2,2]) 
        rotate (a=[90,0,0]) 
    linear_extrude(height=meeple_width) {
        difference() {
            basic_meeple();
            translate([meeple_xmid-2,meeple_ymid-3])
            difference() {
                text(id, size=5, font="Liberation Mono:style=Bold");
                translate([1.7,-1]) square([0.75,6]);
            }
        }
    }
    base();
}

for(i=[0:9]) {
    x=15+30*(i%3);
    y=15+30*floor(i/3);
    if(i!=0 && i!=4 && i!=6 && i!=8 && i!=9) {
        translate([x,y]) alpha_plain(str(i));
    } else {
        translate([x,y]) alpha_reinforce(str(i));
    }
}
translate([105,15]) cleric();
translate([105,45]) rogue();
translate([105,75]) warrior();
translate([105,105]) wizard();
translate([75, 105]) archer();