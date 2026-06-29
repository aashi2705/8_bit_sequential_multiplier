module seq_multiplier(

    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [7:0] a,
    input  logic [7:0] b,

    output logic [15:0] product,
    output logic done
);

logic [8:0] A;
logic [7:0] M;
logic [7:0] Q;

logic [8:0] sum;

logic do_add;

logic load;
logic add_en;
logic shift;
logic count_en;
logic clear;

logic [3:0] count;
logic last;

mult_regs U1(
    .clk(clk),
    .rst(rst),
    .load(load),
    .add_en(add_en),
    .sum(sum),
    .shift(shift),
    .a_in(a),
    .b_in(b),
    .A(A),
    .M(M),
    .Q(Q)
);

bit_counter U2(
    .clk(clk),
    .rst(rst),
    .clear(clear),
    .count_en(count_en),
    .count(count),
    .last(last)
);

add_decision U3(
    .A(A),
    .M(M),
    .Q_lsb(Q[0]),
    .sum(sum),
    .do_add(do_add)
);

controller U4(
    .clk(clk),
    .rst(rst),
    .start(start),
    .last(last),
    .do_add(do_add),
    .load(load),
    .add_en(add_en),
    .shift(shift),
    .count_en(count_en),
    .clear(clear),
    .done(done)
);

assign product = {A[7:0],Q};

endmodule