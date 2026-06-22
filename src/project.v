/*
 * Copyright (c) 2026 Detronyx contributors
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_detronyx_arith_lab (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  localparam [1:0] MODE_ADD    = 2'd0;
  localparam [1:0] MODE_MUL_LO = 2'd1;
  localparam [1:0] MODE_DIV    = 2'd2;
  localparam [1:0] MODE_MUL_HI = 2'd3;

  reg [7:0] bank_a_q [0:3];
  reg [7:0] bank_b_q [0:3];
  reg [1:0] bank_sel_q;
  reg [1:0] mode_q;
  reg       signed_overflow_mode_q;

  wire [2:0] cmd = uio_in[2:0];
  wire       _unused_uio_in = &{1'b0, uio_in[7:3]};
  wire       write_a = cmd == 3'd1;
  wire       write_b = cmd == 3'd2;
  wire       load_mode = cmd == 3'd3;
  wire       load_bank = cmd == 3'd4;
  wire       load_cfg = cmd == 3'd5;

  wire [7:0] a_w = bank_a_q[bank_sel_q];
  wire [7:0] b_w = bank_b_q[bank_sel_q];

  integer bank_i;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (bank_i = 0; bank_i < 4; bank_i = bank_i + 1) begin
        bank_a_q[bank_i] <= 8'h00;
        bank_b_q[bank_i] <= 8'h00;
      end
      bank_sel_q <= 2'd0;
      mode_q     <= MODE_ADD;
      signed_overflow_mode_q <= 1'b0;
    end else if (ena) begin
      if (write_a) begin
        bank_a_q[bank_sel_q] <= ui_in;
      end
      if (write_b) begin
        bank_b_q[bank_sel_q] <= ui_in;
      end
      if (load_mode) begin
        mode_q <= ui_in[1:0];
      end
      if (load_bank) begin
        bank_sel_q <= ui_in[1:0];
      end
      if (load_cfg) begin
        signed_overflow_mode_q <= ui_in[0];
      end
    end
  end

  wire [7:0] add_sum;
  wire       add_cout;
  wire       add_overflow;

  detronyx_add8_sparse_core u_add_core (
      .a_i             (a_w),
      .b_i             (b_w),
      .cin_i           (1'b0),
      .carry_en_i      (1'b1),
      .cin_force_en_i  (1'b0),
      .cin_force_val_i (1'b0),
      .sum_o           (add_sum),
      .cout_o          (add_cout),
      .aux_carry_o     (),
      .group_p_o       (),
      .group_g_o       (),
      .overflow_o      (add_overflow)
  );

  wire [15:0] mul_product;

  detronyx_umul8_comb u_mul_core (
      .a_i       (a_w),
      .b_i       (b_w),
      .product_o (mul_product)
  );

  wire [7:0] quotient;
  wire       div_zero;
  wire       div_valid;

  detronyx_recip8_div8_core u_div_core (
      .clk_i      (clk),
      .rst_ni     (rst_n),
      .ce_i       (ena),
      .dividend_i (a_w),
      .divisor_i  (b_w),
      .quotient_o (quotient),
      .recip_o    (),
      .div_zero_o (div_zero),
      .valid_o    (div_valid)
  );

  reg [7:0] result_r;
  reg       status_r;

  wire add_status_flag = signed_overflow_mode_q ? add_overflow : add_cout;
  wire mul_high_nonzero = |mul_product[15:8];

  always @* begin
    case (mode_q)
      MODE_ADD:    result_r = add_sum;
      MODE_MUL_LO: result_r = mul_product[7:0];
      MODE_DIV:    result_r = quotient;
      MODE_MUL_HI: result_r = mul_product[15:8];
      default:     result_r = 8'h00;
    endcase

    case (mode_q)
      MODE_ADD:    status_r = add_status_flag;
      MODE_DIV:    status_r = div_zero & div_valid;
      default:     status_r = mul_high_nonzero;
    endcase
  end

  assign uo_out = result_r;

  // uio[2:0] are command inputs; uio[7:3] expose compact status.
  assign uio_out = {bank_sel_q, mode_q, status_r, 3'b000};
  assign uio_oe  = 8'hf8;

endmodule
