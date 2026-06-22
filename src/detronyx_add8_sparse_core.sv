/*
 * Copyright (c) 2026 Detronyx contributors
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module detronyx_add8_sparse_core (
    input  wire [7:0] a_i,
    input  wire [7:0] b_i,
    input  wire       cin_i,
    input  wire       carry_en_i,
    input  wire       cin_force_en_i,
    input  wire       cin_force_val_i,
    output wire [7:0] sum_o,
    output wire       cout_o,
    output wire       aux_carry_o,
    output wire       group_p_o,
    output wire       group_g_o,
    output wire       overflow_o
);

  simd_add8_sparse_v2 u_add8 (
      .a             (a_i),
      .b             (b_i),
      .cin_ext       (cin_i),
      .carry_en      (carry_en_i),
      .cin_force_en  (cin_force_en_i),
      .cin_force_val (cin_force_val_i),
      .sum           (sum_o),
      .cout          (cout_o),
      .aux_carry     (aux_carry_o),
      .group_p       (group_p_o),
      .group_g       (group_g_o),
      .overflow      (overflow_o)
  );

endmodule

`default_nettype wire
