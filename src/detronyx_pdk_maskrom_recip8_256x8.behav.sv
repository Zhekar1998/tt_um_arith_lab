`default_nettype none

module detronyx_pdk_maskrom_recip8_256x8 (
    input  wire        clk_i,
    input  wire        ce_i,
    input  wire [7:0]  addr_i,
    output reg  [7:0]  data_o
);
    wire [3:0] bank_sel_w;
    wire [63:0] row_sel_w;
    wire [7:0] bank_data_w [0:3];
    wire [7:0] data_comb_w;

    detronyx_pdk_maskrom_recip8_256x8__decode4x64 u_decode (
        .addr_i     (addr_i),
        .bank_sel_o (bank_sel_w),
        .row_sel_o  (row_sel_w)
    );

    detronyx_pdk_maskrom_recip8_256x8__program_bank0 u_program_bank0 (
        .row_sel_i (row_sel_w),
        .data_o    (bank_data_w[0])
    );

    detronyx_pdk_maskrom_recip8_256x8__program_bank1 u_program_bank1 (
        .row_sel_i (row_sel_w),
        .data_o    (bank_data_w[1])
    );

    detronyx_pdk_maskrom_recip8_256x8__program_bank2 u_program_bank2 (
        .row_sel_i (row_sel_w),
        .data_o    (bank_data_w[2])
    );

    detronyx_pdk_maskrom_recip8_256x8__program_bank3 u_program_bank3 (
        .row_sel_i (row_sel_w),
        .data_o    (bank_data_w[3])
    );

    assign data_comb_w =
        ({8{bank_sel_w[0]}} & bank_data_w[0]) |
        ({8{bank_sel_w[1]}} & bank_data_w[1]) |
        ({8{bank_sel_w[2]}} & bank_data_w[2]) |
        ({8{bank_sel_w[3]}} & bank_data_w[3]);

    always @(posedge clk_i) begin
        if (ce_i) begin
            data_o <= data_comb_w;
        end
    end
endmodule

module detronyx_pdk_maskrom_recip8_256x8__decode4x64 (
    input  wire [7:0]  addr_i,
    output reg  [3:0]  bank_sel_o,
    output reg  [63:0] row_sel_o
);
    always @* begin
        bank_sel_o = 4'b0;
        row_sel_o = 64'b0;
        bank_sel_o[addr_i[7:6]] = 1'b1;
        row_sel_o[addr_i[5:0]] = 1'b1;
    end
endmodule

module detronyx_pdk_maskrom_recip8_256x8__program_bank0 (
    input  wire [63:0] row_sel_i,
    output wire [7:0] data_o
);
    wire _unused_row_sel = &{1'b0, row_sel_i[0]};

    assign data_o[0] =
        row_sel_i[1] | row_sel_i[3] | row_sel_i[5] | row_sel_i[10] | row_sel_i[11] | row_sel_i[12] | row_sel_i[13] | row_sel_i[15] |
        row_sel_i[17] | row_sel_i[19] | row_sel_i[22] | row_sel_i[23] | row_sel_i[26] | row_sel_i[27] | row_sel_i[28] | row_sel_i[33] |
        row_sel_i[34] | row_sel_i[35] | row_sel_i[36] | row_sel_i[43] | row_sel_i[44] | row_sel_i[45] | row_sel_i[46] | row_sel_i[47] |
        row_sel_i[48] | row_sel_i[49] | row_sel_i[50] | row_sel_i[51];
    assign data_o[1] =
        row_sel_i[1] | row_sel_i[5] | row_sel_i[6] | row_sel_i[11] | row_sel_i[13] | row_sel_i[14] | row_sel_i[17] | row_sel_i[18] |
        row_sel_i[22] | row_sel_i[23] | row_sel_i[24] | row_sel_i[25] | row_sel_i[33] | row_sel_i[34] | row_sel_i[35] | row_sel_i[36] |
        row_sel_i[37] | row_sel_i[38] | row_sel_i[39] | row_sel_i[40] | row_sel_i[41] | row_sel_i[42];
    assign data_o[2] =
        row_sel_i[1] | row_sel_i[3] | row_sel_i[7] | row_sel_i[9] | row_sel_i[11] | row_sel_i[12] | row_sel_i[17] | row_sel_i[18] |
        row_sel_i[19] | row_sel_i[20] | row_sel_i[21] | row_sel_i[33] | row_sel_i[34] | row_sel_i[35] | row_sel_i[36] | row_sel_i[37] |
        row_sel_i[38] | row_sel_i[39] | row_sel_i[40] | row_sel_i[41] | row_sel_i[42] | row_sel_i[43] | row_sel_i[44] | row_sel_i[45] |
        row_sel_i[46] | row_sel_i[47] | row_sel_i[48] | row_sel_i[49] | row_sel_i[50] | row_sel_i[51] | row_sel_i[52] | row_sel_i[53] |
        row_sel_i[54] | row_sel_i[55] | row_sel_i[56] | row_sel_i[57] | row_sel_i[58] | row_sel_i[59] | row_sel_i[60] | row_sel_i[61] |
        row_sel_i[62] | row_sel_i[63];
    assign data_o[3] =
        row_sel_i[1] | row_sel_i[6] | row_sel_i[9] | row_sel_i[10] | row_sel_i[17] | row_sel_i[18] | row_sel_i[19] | row_sel_i[20] |
        row_sel_i[21] | row_sel_i[22] | row_sel_i[23] | row_sel_i[24] | row_sel_i[25] | row_sel_i[26] | row_sel_i[27] | row_sel_i[28] |
        row_sel_i[29] | row_sel_i[30] | row_sel_i[31] | row_sel_i[32];
    assign data_o[4] =
        row_sel_i[1] | row_sel_i[3] | row_sel_i[5] | row_sel_i[9] | row_sel_i[10] | row_sel_i[11] | row_sel_i[12] | row_sel_i[13] |
        row_sel_i[14] | row_sel_i[15] | row_sel_i[16];
    assign data_o[5] =
        row_sel_i[1] | row_sel_i[5] | row_sel_i[6] | row_sel_i[7] | row_sel_i[8];
    assign data_o[6] =
        row_sel_i[1] | row_sel_i[3] | row_sel_i[4];
    assign data_o[7] =
        row_sel_i[1] | row_sel_i[2];
endmodule

module detronyx_pdk_maskrom_recip8_256x8__program_bank1 (
    input  wire [63:0] row_sel_i,
    output wire [7:0] data_o
);
    assign data_o[0] =
        row_sel_i[1] | row_sel_i[2] | row_sel_i[3] | row_sel_i[4] | row_sel_i[5] | row_sel_i[6] | row_sel_i[7] | row_sel_i[8] |
        row_sel_i[9] | row_sel_i[10] | row_sel_i[11] | row_sel_i[12] | row_sel_i[13] | row_sel_i[14] | row_sel_i[15] | row_sel_i[16] |
        row_sel_i[17] | row_sel_i[18] | row_sel_i[19] | row_sel_i[20] | row_sel_i[21];
    assign data_o[1] =
        row_sel_i[1] | row_sel_i[2] | row_sel_i[3] | row_sel_i[4] | row_sel_i[5] | row_sel_i[6] | row_sel_i[7] | row_sel_i[8] |
        row_sel_i[9] | row_sel_i[10] | row_sel_i[11] | row_sel_i[12] | row_sel_i[13] | row_sel_i[14] | row_sel_i[15] | row_sel_i[16] |
        row_sel_i[17] | row_sel_i[18] | row_sel_i[19] | row_sel_i[20] | row_sel_i[21] | row_sel_i[22] | row_sel_i[23] | row_sel_i[24] |
        row_sel_i[25] | row_sel_i[26] | row_sel_i[27] | row_sel_i[28] | row_sel_i[29] | row_sel_i[30] | row_sel_i[31] | row_sel_i[32] |
        row_sel_i[33] | row_sel_i[34] | row_sel_i[35] | row_sel_i[36] | row_sel_i[37] | row_sel_i[38] | row_sel_i[39] | row_sel_i[40] |
        row_sel_i[41] | row_sel_i[42] | row_sel_i[43] | row_sel_i[44] | row_sel_i[45] | row_sel_i[46] | row_sel_i[47] | row_sel_i[48] |
        row_sel_i[49] | row_sel_i[50] | row_sel_i[51] | row_sel_i[52] | row_sel_i[53] | row_sel_i[54] | row_sel_i[55] | row_sel_i[56] |
        row_sel_i[57] | row_sel_i[58] | row_sel_i[59] | row_sel_i[60] | row_sel_i[61] | row_sel_i[62] | row_sel_i[63];
    assign data_o[2] =
        row_sel_i[0];
    assign data_o[3] = 1'b0;
    assign data_o[4] = 1'b0;
    assign data_o[5] = 1'b0;
    assign data_o[6] = 1'b0;
    assign data_o[7] = 1'b0;
endmodule

module detronyx_pdk_maskrom_recip8_256x8__program_bank2 (
    input  wire [63:0] row_sel_i,
    output wire [7:0] data_o
);
    assign data_o[0] =
        row_sel_i[1] | row_sel_i[2] | row_sel_i[3] | row_sel_i[4] | row_sel_i[5] | row_sel_i[6] | row_sel_i[7] | row_sel_i[8] |
        row_sel_i[9] | row_sel_i[10] | row_sel_i[11] | row_sel_i[12] | row_sel_i[13] | row_sel_i[14] | row_sel_i[15] | row_sel_i[16] |
        row_sel_i[17] | row_sel_i[18] | row_sel_i[19] | row_sel_i[20] | row_sel_i[21] | row_sel_i[22] | row_sel_i[23] | row_sel_i[24] |
        row_sel_i[25] | row_sel_i[26] | row_sel_i[27] | row_sel_i[28] | row_sel_i[29] | row_sel_i[30] | row_sel_i[31] | row_sel_i[32] |
        row_sel_i[33] | row_sel_i[34] | row_sel_i[35] | row_sel_i[36] | row_sel_i[37] | row_sel_i[38] | row_sel_i[39] | row_sel_i[40] |
        row_sel_i[41] | row_sel_i[42] | row_sel_i[43] | row_sel_i[44] | row_sel_i[45] | row_sel_i[46] | row_sel_i[47] | row_sel_i[48] |
        row_sel_i[49] | row_sel_i[50] | row_sel_i[51] | row_sel_i[52] | row_sel_i[53] | row_sel_i[54] | row_sel_i[55] | row_sel_i[56] |
        row_sel_i[57] | row_sel_i[58] | row_sel_i[59] | row_sel_i[60] | row_sel_i[61] | row_sel_i[62] | row_sel_i[63];
    assign data_o[1] =
        row_sel_i[0];
    assign data_o[2] = 1'b0;
    assign data_o[3] = 1'b0;
    assign data_o[4] = 1'b0;
    assign data_o[5] = 1'b0;
    assign data_o[6] = 1'b0;
    assign data_o[7] = 1'b0;
endmodule

module detronyx_pdk_maskrom_recip8_256x8__program_bank3 (
    input  wire [63:0] row_sel_i,
    output wire [7:0] data_o
);
    assign data_o[0] =
        row_sel_i[0] | row_sel_i[1] | row_sel_i[2] | row_sel_i[3] | row_sel_i[4] | row_sel_i[5] | row_sel_i[6] | row_sel_i[7] |
        row_sel_i[8] | row_sel_i[9] | row_sel_i[10] | row_sel_i[11] | row_sel_i[12] | row_sel_i[13] | row_sel_i[14] | row_sel_i[15] |
        row_sel_i[16] | row_sel_i[17] | row_sel_i[18] | row_sel_i[19] | row_sel_i[20] | row_sel_i[21] | row_sel_i[22] | row_sel_i[23] |
        row_sel_i[24] | row_sel_i[25] | row_sel_i[26] | row_sel_i[27] | row_sel_i[28] | row_sel_i[29] | row_sel_i[30] | row_sel_i[31] |
        row_sel_i[32] | row_sel_i[33] | row_sel_i[34] | row_sel_i[35] | row_sel_i[36] | row_sel_i[37] | row_sel_i[38] | row_sel_i[39] |
        row_sel_i[40] | row_sel_i[41] | row_sel_i[42] | row_sel_i[43] | row_sel_i[44] | row_sel_i[45] | row_sel_i[46] | row_sel_i[47] |
        row_sel_i[48] | row_sel_i[49] | row_sel_i[50] | row_sel_i[51] | row_sel_i[52] | row_sel_i[53] | row_sel_i[54] | row_sel_i[55] |
        row_sel_i[56] | row_sel_i[57] | row_sel_i[58] | row_sel_i[59] | row_sel_i[60] | row_sel_i[61] | row_sel_i[62] | row_sel_i[63];
    assign data_o[1] = 1'b0;
    assign data_o[2] = 1'b0;
    assign data_o[3] = 1'b0;
    assign data_o[4] = 1'b0;
    assign data_o[5] = 1'b0;
    assign data_o[6] = 1'b0;
    assign data_o[7] = 1'b0;
endmodule

`default_nettype wire
