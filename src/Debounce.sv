`timescale 1ns/1ps
`default_nettype none

module Debounce(
    input var logic clk,
    input var logic rst,
    input var logic in,
    output var logic out
);
    parameter THRES = 32'b11111111111111111111111;
    logic [31:0] consec_high, consec_low;

    always_ff @(posedge clk) begin
        if (rst) begin
            out <= 1'b0;
        end else begin
            case ({out, (consec_high == THRES), (consec_low == THRES)})
                // from 0 to consecutive high
                3'b010 : out <= 1'b1;
                3'b011 : out <= 1'b1;
                // from 1 to consecutive low
                3'b101 : out <= 1'b0;
                3'b111 : out <= 1'b0;
                // otherwise don't change
                default : out <= out;
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            consec_high <= 32'b0;
        end else begin
            if (in) begin
                if (consec_high < THRES) begin
                    consec_high <= consec_high + 32'b1;
                end else begin
                    consec_high <= consec_high;
                end
            end else begin
                consec_high <= 32'b0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            consec_low <= 32'b0;
        end else begin
            if (~in) begin
                if (consec_low < THRES) begin
                    consec_low <= consec_low + 32'b1;
                end else begin
                    consec_low <= consec_low;
                end
            end else begin
                consec_low <= 32'b0;
            end
        end
    end
endmodule
