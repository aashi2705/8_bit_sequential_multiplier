module mult_regs(
    input  logic        clk,
    input  logic        rst,
    input  logic        load,
    input  logic        add_en,
    input  logic        shift,
    input  logic [8:0]  sum,
    input  logic [7:0]  a_in,
    input  logic [7:0]  b_in,

    output logic [8:0]  A,
    output logic [7:0]  M,
    output logic [7:0]  Q
);

always_ff @(posedge clk or posedge rst) begin

    if (rst) begin
        A <= 9'd0;
        M <= 8'd0;
        Q <= 8'd0;
    end

    else if (load) begin
        A <= 9'd0;
        M <= a_in;
        Q <= b_in;
    end

    else if (add_en) begin
        A <= sum;
    end

    else if (shift) begin
        {A,Q} <= {A,Q} >> 1;
    end

end

endmodule