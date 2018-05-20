
use <box-pieces.scad>

module box_top_piece (x,
                      y,
                      thickness,
                      outset_width,
                      outset_margin,
                      edge_width) {
  union() {
    translate ([thickness, thickness, 0]) {
      difference() {
        cube([x, y, thickness]);
        translate([edge_width, -0.01, 0])
          cube([x - edge_width * 2, y - edge_width + 0.01, thickness]);
      }
    }

    // Top outsets
    translate ([x + thickness * 2, y + thickness * 2, 0]) {
      rotate([0, 0, 180]) {
        inverted_outsets(x, thickness, outset_width, outset_margin);
        filler(x, thickness);
      }
    }
    translate([0, y + thickness, 0])
      filler(x, thickness);

    // Left outsets
    translate ([0, y + thickness * 2, 0]) {
      rotate([0, 0, -90]) {
        inverted_outsets(y, thickness, outset_width, outset_margin);
      }
    }

    // Right outsets
    translate ([x + thickness * 2, 0, 0]) {
      rotate([0, 0, 90]) {
        inverted_outsets(y, thickness, outset_width, outset_margin);
      }
    }
    cube([thickness + edge_width, thickness, thickness]);
    translate([x - edge_width + thickness, 0])
      cube([thickness + edge_width, thickness, thickness]);
  }
}


module box (length,
            width,
            height,
            wall_thickness,
            outset_width = 5,
            outset_margin = 0,
            piece_margin = 5,
            width_dividers = [],
            divider_margin = 0.5,
            lid_margin = 0.2,
            top_edge_width = 5
  ) {
  total_length = length + 2 * wall_thickness;
  total_height = height + wall_thickness;
  box_bottom_piece(total_length,
                   width,
                   wall_thickness,
                   outset_width,
                   outset_margin,
                   width_dividers);

  translate([piece_offset(total_length, wall_thickness, piece_margin, 0),
             piece_offset(width, wall_thickness, piece_margin, 1)])
    box_top_piece(length + 2 * wall_thickness, width, wall_thickness, outset_width, outset_margin, top_edge_width);

  translate([piece_offset(total_length, wall_thickness, piece_margin, 0),
             piece_offset(width, wall_thickness, piece_margin, 2)])
    box_side_piece(total_length,
                   total_height,
                   wall_thickness,
                   outset_width,
                   outset_margin,
                   top_outsets = true
      );

  translate([piece_offset(total_length, wall_thickness, piece_margin, 0),
             piece_offset(width, wall_thickness, piece_margin, 3)]) {
    difference() {
      box_side_piece(length + 2 * wall_thickness,
                     total_height,
                     wall_thickness,
                     outset_width,
                     outset_margin
        );

      translate([wall_thickness, total_height - lid_margin, 0])
        cube([total_length, wall_thickness + lid_margin, wall_thickness]);
    }
  }

  translate([piece_offset(total_length, wall_thickness, piece_margin, 1),
             piece_offset(total_height, wall_thickness, piece_margin, 0)])
    box_side_piece(width,
                   total_height,
                   wall_thickness,
                   outset_width,
                   outset_margin,
                   width_dividers,
                   top_outsets = true);

  translate([piece_offset(total_length, wall_thickness, piece_margin, 1),
             piece_offset(total_height, wall_thickness, piece_margin, 1)])
    box_side_piece(width,
                   total_height,
                   wall_thickness,
                   outset_width,
                   outset_margin,
                   width_dividers,
                   top_outsets = true);

  for(i = [0 : 1 : len(width_dividers) - 1]) {
    translate([piece_offset(total_length, wall_thickness, piece_margin, 1),
               piece_offset(total_height, wall_thickness, piece_margin, 2 + i)]) {
      difference() {
        divider_x(total_length, total_height, wall_thickness, outset_width, outset_margin, divider_margin);
        translate([0, total_height - 0.2, 0])
          cube([total_length + wall_thickness * 2, wall_thickness + lid_margin, wall_thickness]);
      }
    }
  }

    translate([piece_offset(total_length, wall_thickness, piece_margin, 1),
               piece_offset(total_height, wall_thickness, piece_margin, len(width_dividers) + 2)]) {
    extra_inner_wall(width, height, wall_thickness, width_dividers, divider_margin, piece_margin);
  }

  translate([piece_offset(total_length, wall_thickness, piece_margin, 1),
             piece_offset(total_height, wall_thickness, piece_margin, len(width_dividers) + 4)]) {
    extra_inner_wall(width, height, wall_thickness, width_dividers, divider_margin, piece_margin);
  }
}
