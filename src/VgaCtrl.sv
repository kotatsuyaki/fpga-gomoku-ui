`timescale 1ns/1ps
`default_nettype none

module VgaCtrl(
    input var logic pclk, reset,
    output var logic hsync, vsync, valid,
    output var logic [9:0] h_cnt,
    output var logic [9:0] v_cnt
);
    logic [9:0] pixel_cnt;
    logic [9:0] line_cnt;
    logic hsync_i,vsync_i;
    logic hsync_default, vsync_default;
    logic [9:0] HD, HF, HS, HT, VD, VF, VS, VT;

    assign HD = 640;
    assign HF = 16;
    assign HS = 96;
    assign HT = 800; 
    assign VD = 480;
    assign VF = 10;
    assign VS = 2;
    assign VT = 525;
    assign hsync_default = 1'b1;
    assign vsync_default = 1'b1;
     
    always_ff @(posedge pclk) begin
        if (reset) begin
            pixel_cnt <= 0;
        end else begin
            if (pixel_cnt < (HT - 1)) begin
                pixel_cnt <= pixel_cnt + 1;
            end else begin
                pixel_cnt <= 0;
            end
        end
    end

    always_ff @(posedge pclk) begin
        if (reset) begin
            hsync_i <= hsync_default;
        end else begin
            if ((pixel_cnt >= (HD + HF - 1))
                &&(pixel_cnt < (HD + HF + HS - 1))) begin
                hsync_i <= ~hsync_default;
            end else begin
                hsync_i <= hsync_default; 
            end
        end
    end
    
    always_ff @(posedge pclk) begin
        if (reset) begin
            line_cnt <= 0;
        end else begin
            if (pixel_cnt == (HT -1)) begin
                if (line_cnt < (VT - 1)) begin
                    line_cnt <= line_cnt + 1;
                end else begin
                    line_cnt <= 0;
                end
            end
        end
    end
                    
    always_ff @(posedge pclk) begin
        if (reset) begin
            vsync_i <= vsync_default; 
        end else begin
            if ((line_cnt >= (VD + VF - 1))
                &&(line_cnt < (VD + VF + VS - 1))) begin
                vsync_i <= ~vsync_default; 
            end else begin
                vsync_i <= vsync_default; 
            end
        end
    end
                    
    assign hsync = hsync_i;
    assign vsync = vsync_i;
    assign valid = ((pixel_cnt < HD) && (line_cnt < VD));
    
    assign h_cnt = (pixel_cnt < HD) ? pixel_cnt : 10'd0;
    assign v_cnt = (line_cnt < VD) ? line_cnt : 10'd0;
endmodule
