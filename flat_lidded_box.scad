
module outsets(x, wall_thickness, width) {
  count = floor(x / 2 / width);
  total_width = (count * 2 - 1) * width;
  extra = (x - total_width) / 2;
  translate([wall_thickness + extra, 0, 0]) {
    for(i = [0 : 1 : count - 1]) {
      translate([i * width * 2, 0, 0]) {
        outset(width, wall_thickness);
      }
    }
  }
}

module inverted_outsets(x, wall_thickness, width) {
  count = floor(x / 2 / width);
  total_width = (count * 2 - 1) * width;
  extra = (x - total_width) / 2;
  translate([wall_thickness, 0, 0])
    outset(extra, wall_thickness);
  translate([x + wall_thickness - extra, 0, 0])
    outset(extra, wall_thickness);
  translate([width, 0, 0]) {
    outsets(x - width * 2, wall_thickness, width);
  }
}

module outset(width, wall_thickness) {
  overlap = 1;
  cube([width, wall_thickness + overlap, wall_thickness]);
}

module filler(x, wall_thickness) {
  translate([x + wall_thickness - 1, 0, 0])
    outset(wall_thickness + 1, wall_thickness);
}


module piece_inverted_bottom_outsets(x, y, wall_thickness, outset_width) {
  inverted_outsets(x, wall_thickness, outset_width);
}

module piece_top_outsets(x, y, wall_thickness, outset_width) {
  translate ([x + wall_thickness * 2, y + wall_thickness * 2, 0]) {
    rotate([0, 0, 180]) {
      outsets(x, wall_thickness, outset_width);
    }
  }
}

module box_bottom_piece (x, y, thickness, outset_width) {
  union () {
    translate ([thickness, thickness, 0]) {
      cube([x, y, thickness]);
    }

    outsets(x, thickness, outset_width);
    piece_top_outsets(x, y, thickness, outset_width);
    translate ([0, y + thickness * 2, 0]) {
      rotate([0, 0, -90]) {
        outsets(y, thickness, outset_width);
      }
    }

    translate ([x + thickness * 2, 0, 0]) {
      rotate([0, 0, 90]) {
        outsets(y, thickness, outset_width);
      }
    }
  }
}

module box_top_piece (x, y, thickness, outset_width) {
  cube([x + thickness * 2, y + thickness * 2, thickness]);
}

module box_side_piece (x, y, thickness, outset_width) {
  union () {
    translate([thickness, thickness, 0]) {
      cube([x, y, thickness]);
    }
    piece_inverted_bottom_outsets(x, y, thickness, outset_width);
    translate ([0, y + thickness * 2, 0]) {
      rotate([0, 0, -90]) {
        outsets(y, thickness, outset_width);
      }
    }
    translate ([x + thickness * 2, 0, 0]) {
      rotate([0, 0, 90]) {
        inverted_outsets(y, thickness, outset_width);
      }
    }
    filler(x, thickness);
  }
}

function piece_offset(x, wall_thickness, margin, count) =
  (x + wall_thickness * 2 + margin) * count;

module box (width,
            breadth,
            height,
            wall_thickness,
            outset_width = 5,
            piece_margin = 5) {
  box_bottom_piece(width, breadth, wall_thickness, 5);

  translate([0, piece_offset(breadth, wall_thickness, piece_margin, 1)])
    box_top_piece(width, breadth, wall_thickness, outset_width);

  translate([piece_offset(width, wall_thickness, piece_margin, 1), 0])
    box_side_piece(width, height, wall_thickness, outset_width);

  translate([piece_offset(width, wall_thickness, piece_margin, 1),
             piece_offset(height, wall_thickness, piece_margin, 1)])
    box_side_piece(width, height, wall_thickness, outset_width);

  translate([piece_offset(width, wall_thickness, piece_margin, 1),
             piece_offset(height, wall_thickness, piece_margin, 2)])
    box_side_piece(breadth, height, wall_thickness, outset_width);

  translate([piece_offset(width, wall_thickness, piece_margin, 1),
             piece_offset(height, wall_thickness, piece_margin, 3)])
    box_side_piece(breadth, height, wall_thickness, outset_width);
}
