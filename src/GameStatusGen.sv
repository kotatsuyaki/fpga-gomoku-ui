`timescale 1ns/1ps
`default_nettype none

// TODO: Implement "tie" status
module GameStatusGen(
    // note that next_board should be supplied as input here, not board
    input var logic [1:0] board [36-1:0],
    // 00: not done, 01: black wins, 10: white wins, 11: tie
    output var logic [1:0] status
);
    // black, white, empty
    localparam B = 2'b01;
    localparam W = 2'b10;
    localparam E = 2'b00;

    /* Convert 1D board to rows, cols, and diagonals */
    logic [11:0] rows [5:0];
    logic [11:0] cols [5:0];

    // map the 1d board to 2d signals
    generate
        for (genvar i = 0; i < 6; i++) begin : gen_rows
            assign rows[i] = {
                board[6 * i + 0],
                board[6 * i + 1],
                board[6 * i + 2],
                board[6 * i + 3],
                board[6 * i + 4],
                board[6 * i + 5]
            };
        end
        for (genvar i = 0; i < 6; i++) begin : gen_cols
            assign cols[i] = {
                board[6 * 0 + i],
                board[6 * 1 + i],
                board[6 * 2 + i],
                board[6 * 3 + i],
                board[6 * 4 + i],
                board[6 * 5 + i]
            };
        end
    endgenerate


    /* Generate status */
    logic [59:0] black_win_cases, white_win_cases;
    logic black_win, white_win;
    assign black_win = |black_win_cases;
    assign white_win = |white_win_cases;
    always_comb begin
        if (black_win) begin
            status = 2'b01;
        end else begin
            if (white_win) begin
                status = 2'b10;
            end else begin
                status = 2'b00;
            end
        end
    end

    /* Generate black & white winning status */
    // generate black horizontal winning cases
    generate
        for (genvar i = 0; i < 6; i++) begin : gen0
            assign black_win_cases[i] = (rows[i] == {B, B, B, B, B, W});
            assign white_win_cases[i] = (rows[i] == {W, W, W, W, W, B});
        end
        for (genvar i = 0; i < 6; i++) begin : gen6
            assign black_win_cases[6 + i] = (rows[i] == {B, B, B, B, B, E});
            assign white_win_cases[6 + i] = (rows[i] == {W, W, W, W, W, E});
        end
        for (genvar i = 0; i < 6; i++) begin : gen12
            assign black_win_cases[12 + i] = (rows[i] == {W, B, B, B, B, B});
            assign white_win_cases[12 + i] = (rows[i] == {B, W, W, W, W, W});
        end
        for (genvar i = 0; i < 6; i++) begin : gen18
            assign black_win_cases[18 + i] = (rows[i] == {E, B, B, B, B, B});
            assign white_win_cases[18 + i] = (rows[i] == {E, W, W, W, W, W});
        end
    endgenerate

    // generate black vertical winning cases
    generate
        for (genvar i = 0; i < 6; i++) begin : gen24
            assign black_win_cases[24 + i] = (cols[i] == {B, B, B, B, B, W});
            assign white_win_cases[24 + i] = (cols[i] == {W, W, W, W, W, B});
        end
        for (genvar i = 0; i < 6; i++) begin : gen30
            assign black_win_cases[30 + i] = (cols[i] == {B, B, B, B, B, E});
            assign white_win_cases[30 + i] = (cols[i] == {W, W, W, W, W, E});
        end
        for (genvar i = 0; i < 6; i++) begin : gen36
            assign black_win_cases[36 + i] = (cols[i] == {W, B, B, B, B, B});
            assign white_win_cases[36 + i] = (cols[i] == {B, W, W, W, W, W});
        end
        for (genvar i = 0; i < 6; i++) begin : gen42
            assign black_win_cases[42 + i] = (cols[i] == {E, B, B, B, B, B});
            assign white_win_cases[42 + i] = (cols[i] == {E, W, W, W, W, W});
        end
    endgenerate

    /* Black diagonal cases */
    // generate black main diagonal winning cases
    // 6-case
    assign black_win_cases[48]
        = ({
            board[0 * 6 + 0],
            board[1 * 6 + 1],
            board[2 * 6 + 2],
            board[3 * 6 + 3],
            board[4 * 6 + 4],
            board[5 * 6 + 5]
        } == {B, B, B, B, B, W});
    assign black_win_cases[49]
        = ({
            board[0 * 6 + 0],
            board[1 * 6 + 1],
            board[2 * 6 + 2],
            board[3 * 6 + 3],
            board[4 * 6 + 4],
            board[5 * 6 + 5]
        } == {B, B, B, B, B, E});
    assign black_win_cases[50]
        = ({
            board[0 * 6 + 0],
            board[1 * 6 + 1],
            board[2 * 6 + 2],
            board[3 * 6 + 3],
            board[4 * 6 + 4],
            board[5 * 6 + 5]
        } == {W, B, B, B, B, B});
    assign black_win_cases[51]
        = ({
            board[0 * 6 + 0],
            board[1 * 6 + 1],
            board[2 * 6 + 2],
            board[3 * 6 + 3],
            board[4 * 6 + 4],
            board[5 * 6 + 5]
        } == {E, B, B, B, B, B});
    // 5-case
    assign black_win_cases[52]
        = ({
            board[0 * 6 + 1],
            board[1 * 6 + 2],
            board[2 * 6 + 3],
            board[3 * 6 + 4],
            board[4 * 6 + 5]
        } == {B, B, B, B, B});
    assign black_win_cases[53]
        = ({
            board[1 * 6 + 0],
            board[2 * 6 + 1],
            board[3 * 6 + 2],
            board[4 * 6 + 3],
            board[5 * 6 + 4]
        } == {B, B, B, B, B});

    // generate black second diagonal winning cases
    // 6-case
    assign black_win_cases[54]
        = ({
            board[0 * 6 + 5],
            board[1 * 6 + 4],
            board[2 * 6 + 3],
            board[3 * 6 + 2],
            board[4 * 6 + 1],
            board[5 * 6 + 0]
        } == {B, B, B, B, B, W});
    assign black_win_cases[55]
        = ({
            board[0 * 6 + 5],
            board[1 * 6 + 4],
            board[2 * 6 + 3],
            board[3 * 6 + 2],
            board[4 * 6 + 1],
            board[5 * 6 + 0]
        } == {B, B, B, B, B, E});
    assign black_win_cases[56]
        = ({
            board[0 * 6 + 5],
            board[1 * 6 + 4],
            board[2 * 6 + 3],
            board[3 * 6 + 2],
            board[4 * 6 + 1],
            board[5 * 6 + 0]
        } == {W, B, B, B, B, B});
    assign black_win_cases[57]
        = ({
            board[0 * 6 + 5],
            board[1 * 6 + 4],
            board[2 * 6 + 3],
            board[3 * 6 + 2],
            board[4 * 6 + 1],
            board[5 * 6 + 0]
        } == {E, B, B, B, B, B});
    // 5-case
    assign black_win_cases[58]
        = ({
            board[0 * 6 + 4],
            board[1 * 6 + 3],
            board[2 * 6 + 2],
            board[3 * 6 + 1],
            board[4 * 6 + 0]
        } == {B, B, B, B, B});
    assign black_win_cases[59]
        = ({
            board[1 * 6 + 5],
            board[2 * 6 + 4],
            board[3 * 6 + 3],
            board[4 * 6 + 2],
            board[5 * 6 + 1]
        } == {B, B, B, B, B});

    /* White diagonal cases */
    // generate white main diagonal winning cases
    // 6-case
    assign white_win_cases[48]
        = ({
            board[0 * 6 + 0],
            board[1 * 6 + 1],
            board[2 * 6 + 2],
            board[3 * 6 + 3],
            board[4 * 6 + 4],
            board[5 * 6 + 5]
        } == {W, W, W, W, W, B});
    assign white_win_cases[49]
        = ({
            board[0 * 6 + 0],
            board[1 * 6 + 1],
            board[2 * 6 + 2],
            board[3 * 6 + 3],
            board[4 * 6 + 4],
            board[5 * 6 + 5]
        } == {W, W, W, W, W, E});
    assign white_win_cases[50]
        = ({
            board[0 * 6 + 0],
            board[1 * 6 + 1],
            board[2 * 6 + 2],
            board[3 * 6 + 3],
            board[4 * 6 + 4],
            board[5 * 6 + 5]
        } == {B, W, W, W, W, W});
    assign white_win_cases[51]
        = ({
            board[0 * 6 + 0],
            board[1 * 6 + 1],
            board[2 * 6 + 2],
            board[3 * 6 + 3],
            board[4 * 6 + 4],
            board[5 * 6 + 5]
        } == {E, W, W, W, W, W});
    // 5-case
    assign white_win_cases[52]
        = ({
            board[0 * 6 + 1],
            board[1 * 6 + 2],
            board[2 * 6 + 3],
            board[3 * 6 + 4],
            board[4 * 6 + 5]
        } == {W, W, W, W, W});
    assign white_win_cases[53]
        = ({
            board[1 * 6 + 0],
            board[2 * 6 + 1],
            board[3 * 6 + 2],
            board[4 * 6 + 3],
            board[5 * 6 + 4]
        } == {W, W, W, W, W});

    // generate white second diagonal winning cases
    // 6-case
    assign white_win_cases[54]
        = ({
            board[0 * 6 + 5],
            board[1 * 6 + 4],
            board[2 * 6 + 3],
            board[3 * 6 + 2],
            board[4 * 6 + 1],
            board[5 * 6 + 0]
        } == {W, W, W, W, W, B});
    assign white_win_cases[55]
        = ({
            board[0 * 6 + 5],
            board[1 * 6 + 4],
            board[2 * 6 + 3],
            board[3 * 6 + 2],
            board[4 * 6 + 1],
            board[5 * 6 + 0]
        } == {W, W, W, W, W, E});
    assign white_win_cases[56]
        = ({
            board[0 * 6 + 5],
            board[1 * 6 + 4],
            board[2 * 6 + 3],
            board[3 * 6 + 2],
            board[4 * 6 + 1],
            board[5 * 6 + 0]
        } == {B, W, W, W, W, W});
    assign white_win_cases[57]
        = ({
            board[0 * 6 + 5],
            board[1 * 6 + 4],
            board[2 * 6 + 3],
            board[3 * 6 + 2],
            board[4 * 6 + 1],
            board[5 * 6 + 0]
        } == {E, W, W, W, W, W});
    // 5-case
    assign white_win_cases[58]
        = ({
            board[0 * 6 + 4],
            board[1 * 6 + 3],
            board[2 * 6 + 2],
            board[3 * 6 + 1],
            board[4 * 6 + 0]
        } == {W, W, W, W, W});
    assign white_win_cases[59]
        = ({
            board[1 * 6 + 5],
            board[2 * 6 + 4],
            board[3 * 6 + 3],
            board[4 * 6 + 2],
            board[5 * 6 + 1]
        } == {W, W, W, W, W});

endmodule
