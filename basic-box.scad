
use <box-pieces.scad>


module box (length,
            width,
            height,
            wall_thickness,
            outset_width = 5,
            outset_margin = 0,
            piece_margin = 2,
            width_dividers = [],
            divider_margin = 0.5
  ) {
  box_bottom_piece(length,
                   width,
                   wall_thickness,
                   outset_width,
                   outset_margin,
                   width_dividers);

  translate([piece_offset(length, wall_thickness, piece_margin, 0),
             piece_offset(width, wall_thickness, piece_margin, 1)])
    box_side_piece(length,
                   height,
                   wall_thickness,
                   outset_width,
                   outset_margin
      );

  translate([piece_offset(length, wall_thickness, piece_margin, 0),
             piece_offset(width, wall_thickness, piece_margin, 2)])
    box_side_piece(length,
                   height,
                   wall_thickness,
                   outset_width,
                   outset_margin
      );

  translate([piece_offset(length, wall_thickness, piece_margin, 1),
             piece_offset(height, wall_thickness, piece_margin, 0)])
    box_side_piece(width,
                   height,
                   wall_thickness,
                   outset_width,
                   outset_margin,
                   width_dividers);

  translate([piece_offset(length, wall_thickness, piece_margin, 1),
             piece_offset(height, wall_thickness, piece_margin, 1)])
    box_side_piece(width,
                   height,
                   wall_thickness,
                   outset_width,
                   outset_margin,
                   width_dividers);

  for(i = [0 : 1 : len(width_dividers) - 1])
    translate([piece_offset(length, wall_thickness, piece_margin, 1),
               piece_offset(height, wall_thickness, piece_margin, 2 + i)])
      divider_x(length, height, wall_thickness, outset_width, outset_margin, divider_margin);
}
