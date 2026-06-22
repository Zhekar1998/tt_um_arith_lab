/*
 * Copyright (c) 2026 Detronyx contributors
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module detronyx_recip8_div8_core (
    input  wire       clk_i,
    input  wire       rst_ni,
    input  wire       ce_i,
    input  wire [7:0] dividend_i,
    input  wire [7:0] divisor_i,
    output wire [7:0] quotient_o,
    output wire [7:0] recip_o,
    output wire       div_zero_o,
    output wire       valid_o
);

  wire [7:0] recip_w;

  detronyx_pdk_maskrom_recip8_256x8 u_recip_rom (
      .clk_i  (clk_i),
      .ce_i   (ce_i),
      .addr_i (divisor_i),
      .data_o (recip_w)
  );

  reg [7:0] a_s0;
  reg [7:0] b_s0;
  reg       valid_s0;
  reg       div_zero_s0;
  reg       short_s0;
  reg [7:0] short_q_s0;

  reg [7:0] a_s1;
  reg [7:0] b_s1;
  reg       valid_s1;
  reg       div_zero_s1;
  reg       short_s1;
  reg [7:0] short_q_s1;
  reg [7:0] recip_s1;
  reg [7:0] q_est_s1;

  reg [7:0] quotient_q;
  reg [7:0] recip_q;
  reg       div_zero_q;
  reg       valid_q;

  wire [15:0] recip_product_w;
  wire [15:0] qb_product_w;
  wire        _unused_product_bits = &{1'b0, recip_product_w[7:0], qb_product_w[15:8]};

  detronyx_umul8_comb u_mul_recip (
      .a_i       (a_s0),
      .b_i       (recip_w),
      .product_o (recip_product_w)
  );

  detronyx_umul8_comb u_mul_qb (
      .a_i       (q_est_s1),
      .b_i       (b_s1),
      .product_o (qb_product_w)
  );

  wire [8:0] rem_s1 = {1'b0, a_s1} - {1'b0, qb_product_w[7:0]};
  wire [7:0] q_fix_s1 = (rem_s1 >= {1'b0, b_s1}) ? (q_est_s1 + 8'd1) : q_est_s1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      a_s0 <= 8'h00;
      b_s0 <= 8'h00;
      valid_s0 <= 1'b0;
      div_zero_s0 <= 1'b0;
      short_s0 <= 1'b0;
      short_q_s0 <= 8'h00;
      a_s1 <= 8'h00;
      b_s1 <= 8'h00;
      valid_s1 <= 1'b0;
      div_zero_s1 <= 1'b0;
      short_s1 <= 1'b0;
      short_q_s1 <= 8'h00;
      recip_s1 <= 8'h00;
      q_est_s1 <= 8'h00;
      quotient_q <= 8'h00;
      recip_q <= 8'h00;
      div_zero_q <= 1'b0;
      valid_q <= 1'b0;
    end else begin
      valid_s0 <= ce_i;
      if (ce_i) begin
        a_s0 <= dividend_i;
        b_s0 <= divisor_i;
        div_zero_s0 <= divisor_i == 8'h00;
        short_s0 <= (divisor_i == 8'h00) || (dividend_i == 8'h00) || (divisor_i == 8'h01);
        short_q_s0 <= (divisor_i == 8'h01) ? dividend_i : 8'h00;
      end

      valid_s1 <= valid_s0;
      a_s1 <= a_s0;
      b_s1 <= b_s0;
      div_zero_s1 <= div_zero_s0;
      short_s1 <= short_s0;
      short_q_s1 <= short_q_s0;
      recip_s1 <= recip_w;
      q_est_s1 <= recip_product_w[15:8];

      valid_q <= valid_s1;
      quotient_q <= short_s1 ? short_q_s1 : q_fix_s1;
      recip_q <= recip_s1;
      div_zero_q <= div_zero_s1;
    end
  end

  assign quotient_o = quotient_q;
  assign recip_o = recip_q;
  assign div_zero_o = div_zero_q;
  assign valid_o = valid_q;

endmodule

`default_nettype wire
