module bit_counter(

    input  logic clk,
    input  logic rst,
    input  logic clear,
    input  logic count_en,

    output logic [3:0] count,
    output logic last
);

always_ff @(posedge clk or posedge rst) begin

    if(rst)
        count <= 4'd0;

    else if(clear)
        count <= 4'd0;

    else if(count_en)
        count <= count + 1'b1;

end

assign last = (count == 4'd7);

endmodule