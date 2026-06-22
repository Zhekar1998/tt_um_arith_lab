/*
 * Copyright (c) 2026 Detronyx contributors
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module detronyx_umul8_comb (
    input  wire [7:0]  a_i,
    input  wire [7:0]  b_i,
    output wire [15:0] product_o
);

  wire [15:0] p0 = b_i[0] ? {8'h00, a_i} : 16'h0000;
  wire [15:0] p1 = b_i[1] ? ({8'h00, a_i} << 1) : 16'h0000;
  wire [15:0] p2 = b_i[2] ? ({8'h00, a_i} << 2) : 16'h0000;
  wire [15:0] p3 = b_i[3] ? ({8'h00, a_i} << 3) : 16'h0000;
  wire [15:0] p4 = b_i[4] ? ({8'h00, a_i} << 4) : 16'h0000;
  wire [15:0] p5 = b_i[5] ? ({8'h00, a_i} << 5) : 16'h0000;
  wire [15:0] p6 = b_i[6] ? ({8'h00, a_i} << 6) : 16'h0000;
  wire [15:0] p7 = b_i[7] ? ({8'h00, a_i} << 7) : 16'h0000;

  wire [15:0] s01 = p0 + p1;
  wire [15:0] s23 = p2 + p3;
  wire [15:0] s45 = p4 + p5;
  wire [15:0] s67 = p6 + p7;
  wire [15:0] s0123 = s01 + s23;
  wire [15:0] s4567 = s45 + s67;

  assign product_o = s0123 + s4567;

endmodule

`default_nettype wire
