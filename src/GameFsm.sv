`timescale 1ns/1ps
`default_nettype none

module GameFsm(
    input var logic clk,
    input var logic rst,
    output var logic [1:0] board [36-1:0],
    output var logic [1:0] player,
    output var logic [5:0] cursor,
    input var up, down, left, right, center
);
    logic [1:0] next_board [36-1:0];
    // the current turn player
    // 2'b01 for black, 2'b10 for white
    logic [1:0] next_player;
    logic [5:0] next_cursor;

    // wire up state and next state
    generate
        for (genvar i = 0; i < 36; i++) begin : gen_board_ff
            always_ff @(posedge clk) begin
                if (rst) begin
                    board[i] <= 2'b00;
                    player <= 2'b01;
                    cursor <= 6'd0;
                end else begin
                    board[i] <= next_board[i];
                    player <= next_player;
                    cursor <= next_cursor;
                end
            end
        end
    endgenerate


    /* Next board and player calculation */
    logic cursor_at_empty_cell;
    // the "less than 36" comparison is to ensure that we're not indexing
    // out-of-bounds; not sure if it's needed
    assign cursor_at_empty_cell
        = (cursor < 6'd36) ? (board[cursor] == 2'b00) : 1'b0;

    // calculate each cell in next_board
    generate
        for (genvar i = 0; i < 36; i++) begin : gen_nextboard_comb
            always_comb begin
                if (center & (cursor == i) & cursor_at_empty_cell) begin
                    next_board[i] = player;
                end else begin
                    next_board[i] = board[i];
                end
            end
        end
    endgenerate

    // calculate next_player
    always_comb begin
        if (center & cursor_at_empty_cell) begin
            next_player = ~player;
        end else begin
            next_player = player;
        end
    end


    /* Next cursor calculation */
    always_comb begin
        casez ({left, right, up, down})
            4'b1??? : next_cursor
                = (cursor - 6'd1 >= 6'd36) ? cursor : (cursor - 6'd1);
            4'b01?? : next_cursor
                = (cursor + 6'd1 >= 6'd36) ? cursor : (cursor + 6'd1);
            4'b001? : next_cursor
                = (cursor - 6'd6 >= 6'd36) ? cursor : (cursor - 6'd6);
            4'b0001 : next_cursor
                = (cursor + 6'd6 >= 6'd36) ? cursor : (cursor + 6'd6);
            default : next_cursor = cursor;
        endcase
    end
endmodule
