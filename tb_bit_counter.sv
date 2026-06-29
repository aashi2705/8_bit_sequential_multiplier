`timescale 1ns/1ps

module tb_bit_counter;
    // Testbench Signals
    bit clk, rst;
    bit clear, count_en;

    bit [3:0] count;
    bit last;

    bit [3:0] expected_count;
    bit expected_last;

    
    // Instantiate DUT
    bit_counter dut (
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .count_en(count_en),
        .count(count),
        .last(last)
    );

    
    // Clock generation - 10ns period

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //========================================================
    // Checker Scoreboard
    //========================================================

    task checker_scoreboard;

        input [3:0] expected_count;
        input expected_last;
        input string test_name;

        if(count == expected_count && last == expected_last)

            $display("%s Test Passed: count=%0d, last=%0b",
                     test_name, count, last);

        else

            $error("%s Test Failed: DUT - count=%0d, last=%0b | Expected - count=%0d, last=%0b",
                    test_name,
                    count,
                    last,
                    expected_count,
                    expected_last);

    endtask

    //========================================================
    // Apply Inputs Task
    //========================================================

    task apply_inputs;

        input bit rst_, clear_, count_en_;

        rst      = rst_;
        clear    = clear_;
        count_en = count_en_;

        @(posedge clk); // Wait for positive edge
        #1;             // Propagation delay

        $display("Inputs Applied -> rst=%b, clear=%b, count_en=%b",
                  rst, clear, count_en);

    endtask

    //========================================================
    // Main Test Sequence
    //========================================================

    initial begin

    //--------------------------------------------------------
    // TC1 : Reset Test
    //--------------------------------------------------------

        apply_inputs(1, 0, 0);

        expected_count = 0;
        expected_last  = 0;

        checker_scoreboard(expected_count,
                           expected_last,
                           "TC1-Reset");


    //--------------------------------------------------------
    // TC2 : Hold Test
    //--------------------------------------------------------

        apply_inputs(0, 0, 0);

        expected_count = 0;
        expected_last  = 0;

        checker_scoreboard(expected_count,
                           expected_last,
                           "TC2-Hold");


    //--------------------------------------------------------
    // TC3 : Count Enable Test
    //--------------------------------------------------------

        apply_inputs(0, 0, 1);

        expected_count = 1;
        expected_last  = 0;

        checker_scoreboard(expected_count,
                           expected_last,
                           "TC3-Count-1");


    //--------------------------------------------------------
    // TC4 : Consecutive Counting Test
    //--------------------------------------------------------

        repeat(3)
        begin

            apply_inputs(0, 0, 1);

            expected_count = expected_count + 1;
            expected_last  = 0;

            checker_scoreboard(expected_count,
                               expected_last,
                               "TC4-Consecutive-Count");

        end


    //--------------------------------------------------------
    // TC5 : Clear Test
    //--------------------------------------------------------

        apply_inputs(0, 1, 1);

        expected_count = 0;
        expected_last  = 0;

        checker_scoreboard(expected_count,
                           expected_last,
                           "TC5-Clear");


    //--------------------------------------------------------
    // TC6 : Last Signal Assert Test
    //--------------------------------------------------------

        repeat(7)
        begin

            apply_inputs(0, 0, 1);

            expected_count = expected_count + 1;

            if(expected_count == 7)
                expected_last = 1;
            else
                expected_last = 0;

        end

        checker_scoreboard(expected_count,
                           expected_last,
                           "TC6-Last-Assert");


    //--------------------------------------------------------
    // TC7 : Last Signal Deassert Test
    //--------------------------------------------------------

        apply_inputs(0, 0, 1);

        expected_count = expected_count + 1;
        expected_last  = 0;

        checker_scoreboard(expected_count,
                           expected_last,
                           "TC7-Last-Deassert");


    //--------------------------------------------------------
    // TC8 : Reset Priority Test
    // rst + count_en together
    //--------------------------------------------------------

        apply_inputs(1, 0, 1);

        expected_count = 0;
        expected_last  = 0;

        checker_scoreboard(expected_count,
                           expected_last,
                           "TC8-Reset-Priority");


    //--------------------------------------------------------
    // TC9 : Clear Priority Test
    // clear + count_en together
    //--------------------------------------------------------

        apply_inputs(0, 1, 1);

        expected_count = 0;
        expected_last  = 0;

        checker_scoreboard(expected_count,
                           expected_last,
                           "TC9-Clear-Priority");


    //--------------------------------------------------------
    // TC10 : Overflow Test
    //--------------------------------------------------------

        repeat(20)
        begin

            apply_inputs(0, 0, 1);

            expected_count = expected_count + 1;
            expected_last  = (expected_count == 7);

        end

        checker_scoreboard(expected_count,
                           expected_last,
                           "TC10-Overflow");


    //--------------------------------------------------------
    // Randomized Testing
    //--------------------------------------------------------

        repeat(10)
        begin

            clear    = $random;
            count_en = $random;

            apply_inputs(0, clear, count_en);

            if(clear)
                expected_count = 0;

            else if(count_en)
                expected_count = expected_count + 1;

            expected_last = (expected_count == 7);

            checker_scoreboard(expected_count,
                               expected_last,
                               "Random-Test");

        end

        $display("=================================");
        $display("All Testcases Completed");
        $display("=================================");

        $finish;

    end

    initial begin
        $dumpfile("tb_bit_counter.vcd");
        $dumpvars(0, tb_bit_counter);
    end

    initial begin
        #100000;

        $error("ERROR : Simulation timeout!");

        $finish;
    end

endmodule