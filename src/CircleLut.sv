`timescale 1ns/1ps
`default_nettype none

`include "colors.vh"

module CircleLut(
    input var logic [5:0] local_v,
    input var logic [5:0] local_h,
    input var logic [1:0] cell_value,
    output var logic [11:0] cell_rgb
);
    // colors for inside and outside of the circle
    logic [11:0] in_color, out_color;
    assign out_color = COLOR_BOARD;

    always_comb begin
        case (cell_value)
            2'b00 : in_color = COLOR_BOARD;
            2'b01 : in_color = COLOR_BLACK;
            2'b10 : in_color = COLOR_WHITE;
            default : in_color = COLOR_ERROR;
        endcase
    end

    // lower and upper bounds of the circle
    // if local_h is within this range, then it's within the circle
    logic [5:0] h_lower, h_upper;
    // whether local_h is within circle;
    logic local_h_in_circle;
    assign h_upper = 6'd00 - h_lower;
    assign local_h_in_circle
        = (local_h >= h_lower) & (local_h < h_upper);
    assign cell_rgb = (local_h_in_circle) ? (in_color) : (out_color);

    // empty range
    localparam EMPTY = 6'b111111;
    always_comb begin
        case (local_v)
            6'd00, 6'd01, 6'd02 : h_lower = EMPTY;
            6'd03, 6'd60 : h_lower =6'd24;
            6'd04, 6'd59 : h_lower =6'd21;
            6'd05, 6'd58 : h_lower =6'd19;
            6'd06, 6'd57 : h_lower =6'd17;
            6'd07, 6'd56 : h_lower =6'd16;
            6'd08, 6'd55 : h_lower =6'd14;
            6'd09, 6'd54 : h_lower =6'd13;
            6'd10, 6'd53 : h_lower =6'd12;
            6'd11, 6'd52 : h_lower =6'd11;
            6'd12, 6'd51 : h_lower =6'd10;
            6'd13, 6'd50 : h_lower =6'd09;
            6'd14, 6'd49 : h_lower =6'd09;
            6'd15, 6'd48 : h_lower =6'd08;
            6'd16, 6'd47 : h_lower =6'd07;
            6'd17, 6'd46 : h_lower =6'd07;
            6'd18, 6'd45 : h_lower =6'd06;
            6'd19, 6'd44 : h_lower =6'd06;
            6'd20, 6'd43 : h_lower =6'd05;
            6'd21, 6'd42 : h_lower =6'd05;
            6'd22, 6'd41 : h_lower =6'd04;
            6'd23, 6'd40 : h_lower =6'd04;
            6'd24, 6'd39 : h_lower =6'd04;
            6'd25, 6'd38 : h_lower =6'd04;
            6'd26, 6'd37 : h_lower =6'd03;
            6'd27, 6'd36 : h_lower =6'd03;
            6'd28, 6'd35 : h_lower =6'd03;
            6'd29, 6'd34 : h_lower =6'd03;
            6'd30, 6'd33 : h_lower =6'd03;
            6'd31, 6'd32 : h_lower =6'd03;
            6'd61, 6'd62, 6'd63 : h_lower = EMPTY;
        endcase
    end
endmodule
