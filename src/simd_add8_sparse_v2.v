`default_nettype none

module simd_add8_sparse_v2 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin_ext,
    input  wire       carry_en,
    input  wire       cin_force_en,
    input  wire       cin_force_val,
    output wire [7:0] sum,
    output wire       cout,
    output wire       aux_carry,
    output wire       group_p,
    output wire       group_g,
    output wire       overflow
);

    wire cin_eff;

    assign cin_eff =
        cin_force_en ? cin_force_val :
        carry_en     ? cin_ext :
                       1'b0;

    wire [7:0] p;
    wire [7:0] g;

    assign p = a ^ b;
    assign g = a & b;

    wire gp01, gg01;
    wire gp23, gg23;
    wire gp45, gg45;
    wire gp67, gg67;

    assign gp01 = p[1] & p[0];
    assign gg01 = g[1] | (p[1] & g[0]);

    assign gp23 = p[3] & p[2];
    assign gg23 = g[3] | (p[3] & g[2]);

    assign gp45 = p[5] & p[4];
    assign gg45 = g[5] | (p[5] & g[4]);

    assign gp67 = p[7] & p[6];
    assign gg67 = g[7] | (p[7] & g[6]);

    wire gp03, gg03;
    wire gp47, gg47;
    wire gp07, gg07;

    assign gp03 = gp23 & gp01;
    assign gg03 = gg23 | (gp23 & gg01);

    assign gp47 = gp67 & gp45;
    assign gg47 = gg67 | (gp67 & gg45);

    assign gp07 = gp47 & gp03;
    assign gg07 = gg47 | (gp47 & gg03);

    wire c0, c1, c2, c3, c4, c5, c6, c7, c8;

    assign c0 = cin_eff;
    assign c1 = g[0]  | (p[0]  & c0);
    assign c2 = gg01  | (gp01  & c0);
    assign c3 = g[2]  | (p[2]  & c2);
    assign c4 = gg03  | (gp03  & c0);
    assign c5 = g[4]  | (p[4]  & c4);
    assign c6 = gg45  | (gp45  & c4);
    assign c7 = g[6]  | (p[6]  & c6);
    assign c8 = gg07  | (gp07  & c0);

    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = p[4] ^ c4;
    assign sum[5] = p[5] ^ c5;
    assign sum[6] = p[6] ^ c6;
    assign sum[7] = p[7] ^ c7;

    assign cout      = c8;
    assign aux_carry = c4;
    assign group_p   = gp07;
    assign group_g   = gg07;
    assign overflow  = c7 ^ c8;

endmodule

`default_nettype wire
