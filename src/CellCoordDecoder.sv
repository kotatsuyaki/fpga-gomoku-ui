`timescale 1ns/1ps
`default_nettype none

// This module takes (x, y) coordinate of the cell between (0, 0) and (6, 6)
// (exclusive), and generates the address of the cell.
// For (x, y) values that are out of range, the output should be regarded as
// trash.
module CellCoordDecoder(
    input var logic [2:0] x,
    input var logic [2:0] y,
    // wide enough to represent 0 ~ (36-1)
    output var logic [5:0] cell_addr
);
    logic oob;
    assign oob = (x >= 3'd6) || (y >= 3'd6);

    // 0-extended x and y
    logic [5:0] xs, ys;
    assign xs = {3'b0, x};
    assign ys = {3'b0, y};

    always_comb begin
        if (oob) begin
            cell_addr = 6'd0;
        end else begin
            cell_addr = xs * 5'd6 + ys;
        end
    end
endmodule
