`timescale 1ns/1ps

module tb_mult_regs;

    bit clk;
    bit rst;
    bit load;
    bit add_en;
    bit shift;
    bit [7:0] a_in;
    bit [7:0] b_in;
    bit [8:0] sum;
    
    wire [8:0] A;
    wire [7:0] M;
    wire [7:0] Q;

    bit [8:0] expected_A;
    bit [7:0] expected_M;
    bit [7:0] expected_Q;

    mult_regs dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .add_en(add_en),
        .shift(shift),
        .a_in(a_in),
        .b_in(b_in),
        .sum(sum),
        .A(A),
        .M(M),
        .Q(Q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task checker_scoreboard(input string test_name);
        begin
            if ((A === expected_A) && (M === expected_M) && (Q === expected_Q)) begin
                $display("%s Passed: A=%h, M=%h, Q=%h", test_name, A, M, Q);
            end else begin
                $error("%s Failed: Got A=%h, M=%h, Q=%h | Exp: A=%h, M=%h, Q=%h", 
                       test_name, A, M, Q, expected_A, expected_M, expected_Q);
            end
        end
    endtask

    initial begin
        load = 0; add_en = 0; shift = 0; a_in = 0; b_in = 0; sum = 0;
        rst = 1;
        repeat (2) @(posedge clk);
        #1;
        rst = 0;
        expected_A = 0; expected_M = 0; expected_Q = 0;
        checker_scoreboard("Reset_Check");

        load = 1; a_in = 8'd45; b_in = 8'd12;
        @(posedge clk);
        #1;
        load = 0;
        expected_A = 0; expected_M = 8'd45; expected_Q = 8'd12;
        checker_scoreboard("Load_Check");

        sum = 9'd135; add_en = 1;
        @(posedge clk);
        #1;
        add_en = 0;
        expected_A = 9'd135; expected_M = 8'd45; expected_Q = 8'd12;
        checker_scoreboard("Add_Check");

        shift = 1;
        expected_A = expected_A; 
        expected_Q = expected_Q;
        {expected_A, expected_Q} = {expected_A, expected_Q} >> 1;
        @(posedge clk);
        #1;
        shift = 0;
        checker_scoreboard("Shift_Check_1");

        shift = 1;
        {expected_A, expected_Q} = {expected_A, expected_Q} >> 1;
        @(posedge clk);
        #1;
        shift = 0;
        checker_scoreboard("Shift_Check_2");

        load = 1; add_en = 1; shift = 1;
        a_in = 8'd10; b_in = 8'd20; sum = 9'd50;
        @(posedge clk);
        #1;
        load = 0; add_en = 0; shift = 0;
        expected_A = 0; expected_M = 8'd10; expected_Q = 8'd20;
        checker_scoreboard("Priority_Check");

        $finish;
    end

    initial begin
        $dumpfile("tb_mult_regs.vcd");
        $dumpvars(0, tb_mult_regs);
    end

endmodule