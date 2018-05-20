
function divider_outset_count(x, outset_width) = ceil(x / 15 / outset_width);

module sparse_outset_holes(x, wall_thickness, count, width, margin) {
  reduced_space = 0.9;
  space = x / (count + 1);
  for(i = [1 : 1 : count]) {
    translate([margin / 2 + space * i - width / 2, 0, 0]) {
      outset(width - margin, wall_thickness);
    }
  }
}

module sparse_outsets(x, wall_thickness, count, width, margin) {
  space = x / (count + 1);
  for(i = [1 : 1 : count]) {
    t = margin / 2 + space * i - width / 2;
    translate([t, 0, 0]) {
      outset(width - margin, wall_thickness);
    }
  }
}

module outsets(x, wall_thickness, width, margin) {
  count = floor(x / 2 / width);
  total_width = (count * 2 - 1) * width;
  extra = (x - total_width) / 2;
  translate([wall_thickness + extra, 0, 0]) {
    for(i = [0 : 1 : count - 1]) {
      translate([margin / 2 + i * width * 2, 0, 0]) {
        outset(width - margin, wall_thickness);
      }
    }
  }
}

module inverted_outsets(x, wall_thickness, width, margin) {
  difference() {
    translate([wall_thickness, 0, 0])
      cube([x, wall_thickness, wall_thickness]);
    outsets(x, wall_thickness, width, margin);
  }
}

module outset(width, wall_thickness) {
  overlap = 0.01;
  cube([width, wall_thickness + overlap, wall_thickness]);
}

module filler(x, wall_thickness) {
  translate([x + wall_thickness - 1, 0, 0])
    outset(wall_thickness + 1, wall_thickness);
}

module box_bottom_piece (x,
                         y,
                         thickness,
                         outset_width,
                         outset_margin,
                         dividers_x) {
  union () {
    // Body
    bottom_divider_outset_count = divider_outset_count(x, outset_width);
    difference () {
      translate ([thickness, thickness, 0]) {
        cube([x, y, thickness]);
      }
      for(divider_x = dividers_x) {
        translate([thickness, divider_x + thickness / 2, -0.01]) {
          scale([1, 1, 1.1]) {
            sparse_outsets(x,
                           thickness,
                           bottom_divider_outset_count,
                           outset_width,
                           outset_margin);
          }
        }
      }
    }

    // Bottom outsets
    outsets(x, thickness, outset_width, outset_margin);

    // Top outsets
    translate ([x + thickness * 2, y + thickness * 2, 0]) {
      rotate([0, 0, 180]) {
        outsets(x, thickness, outset_width, outset_margin);
      }
    }

    // Left outsets
    translate ([0, y + thickness * 2, 0]) {
      rotate([0, 0, -90]) {
        outsets(y, thickness, outset_width, outset_margin);
      }
    }

    // Right outsets
    translate ([x + thickness * 2, 0, 0]) {
      rotate([0, 0, 90]) {
        outsets(y, thickness, outset_width, outset_margin);
      }
    }
  }
}

module box_side_piece (x,
                       y,
                       thickness,
                       outset_width,
                       outset_margin,
                       dividers = [],
                       top_outsets = false) {
  union () {
    side_divider_outset_count = divider_outset_count(y, outset_width);
    difference () {
      translate([thickness, thickness, 0]) {
        cube([x, y, thickness]);
      }
      for(divider = dividers) {
          translate([divider + thickness + thickness / 2, thickness, -0.01]) {
            rotate([0, 0, 90]) {
              scale([1, 1, 1.01]) {
                sparse_outset_holes(y,
                                    thickness,
                                    side_divider_outset_count,
                                    outset_width,
                                    outset_margin);
              }
            }
          }
      }
    }
    inverted_outsets(x, thickness, outset_width, outset_margin);

    if(top_outsets) {
      translate([0, y + thickness, 0]) {
        outsets(x, thickness, outset_width, outset_margin);
      }
    }

    translate ([0, y + thickness * 2, 0]) {
      rotate([0, 0, -90]) {
        outsets(y, thickness, outset_width, outset_margin);
      }
    }
    translate ([x + thickness * 2, 0, 0]) {
      rotate([0, 0, 90]) {
        inverted_outsets(y, thickness, outset_width, outset_margin);
      }
    }
    filler(x, thickness);
  }
}

module divider_x(x, height, thickness, outset_width, outset_margin, divider_margin) {

  union() {
    translate([thickness + divider_margin / 2, thickness, 0]) {
      cube([x - divider_margin, height, thickness]);
    }

    bottom_count = divider_outset_count(x, outset_width);
    translate([thickness, 0, 0])
      sparse_outsets(x, thickness, bottom_count, outset_width, outset_margin);

    side_count = divider_outset_count(height, outset_width);
    translate([divider_margin / 2, height + thickness, 0]) {
      rotate([0, 0, -90])
        sparse_outsets(height, thickness, side_count, outset_width, outset_margin);
    }

    translate([x + thickness * 2 - divider_margin / 2, thickness, 0]) {
      rotate([0, 0, 90])
        sparse_outsets(height, thickness, side_count, outset_width, outset_margin);
    }
  }
}

module extra_inner_wall(x, height, thickness, dividers, margin, piece_margin) {
  divider_count = len(dividers);
  wall_piece_count = divider_count + 1;
  wall_piece_x = (x - divider_count * thickness) / wall_piece_count - margin;
  for(i = [0 : 1 : wall_piece_count - 1]) {
    translate([0, i * (height + piece_margin), 0])
      cube([wall_piece_x, height, thickness]);
  }
}

function piece_offset(x, wall_thickness, margin, count) =
  (x + wall_thickness * 2 + margin) * count;


