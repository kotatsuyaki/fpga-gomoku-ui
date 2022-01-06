`timescale 1ns/1ps
`default_nettype none

module VgaPixelGen(
    input var logic [9:0] h_cnt,
    input var logic [9:0] v_cnt,
    input var logic valid,
    output var logic [3:0] vga_red,
    output var logic [3:0] vga_grn,
    output var logic [3:0] vga_blu,
    input var logic [1:0] board [5:0][5:0]
);
    // detect if the output should be disabled
    logic disabled;
    logic [2:0] disabled_cases;
    assign disabled = |disabled_cases;
    assign disabled_cases[0] = ~valid;
    assign disabled_cases[1] = h_cnt > 10'd640;
    assign disabled_cases[2] = v_cnt > 10'd480;

    // detect if scan line is out of the board's borders
    logic oob;
    logic [3:0] oob_cases;
    assign oob = |oob_cases;
    assign oob_cases[0] = h_cnt < 10'd128;  // 640/2 - 3*64
    assign oob_cases[1] = h_cnt >= 10'd512; // 640/2 + 3*64
    assign oob_cases[2] = v_cnt < 10'd48;   // 480/2 - 3*64
    assign oob_cases[3] = v_cnt >= 10'd432; // 480/2 + 3*64

    // coordinates w.r.t. top-left corner of the board
    logic [9:0] v, h;
    assign v = v_cnt - 10'd48;
    assign h = h_cnt - 10'd128;

    always_comb begin
        if (disabled) begin
            {vga_red, vga_grn, vga_blu} = 12'h0;
        end else begin
            if (oob) begin
                {vga_red, vga_grn, vga_blu} = 12'h333;
            end else begin
                {vga_red, vga_grn, vga_blu} = 12'h985;
            end
        end
    end
endmodule
