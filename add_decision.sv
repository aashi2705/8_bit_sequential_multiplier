module add_decision(

    input  logic [8:0] A,
    input  logic [7:0] M,
    input  logic       Q_lsb,

    output logic [8:0] sum,
    output logic       do_add
);

assign sum = A + {1'b0,M};

assign do_add = Q_lsb;

endmodule