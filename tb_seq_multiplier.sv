
module tb_seq_multiplier;

    bit clk = 0, rst = 1, start = 0;
    bit [7:0] a, b;
    bit [15:0] product;
    bit done;

    // DUT Instantiation
    seq_multiplier dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .product(product),
        .done(done)
    );

    // Clock generation
    initial begin
        forever #5 clk = ~clk;
    end

    // -------------------------------------------------
    // Scoreboard / Checker
    // -------------------------------------------------
    task checker_scoreboard;
        input [15:0] expected_product;
        input string test_name;

        begin
            if (product == expected_product)
                $display("%s TEST PASSED | a=%0d b=%0d product=%0d",
                         test_name, a, b, product);

            else
                $display("%s TEST FAILED | a=%0d b=%0d DUT=%0d EXPECTED=%0d",
                         test_name, a, b, product, expected_product);
        end
    endtask

    // -------------------------------------------------
    // Apply Inputs Task
    // -------------------------------------------------
    task apply_inputs;
        input [7:0] a_in;
        input [7:0] b_in;
        input string test_name;

        begin
            @(posedge clk);

            a = a_in;
            b = b_in;
            start = 1;

            @(posedge clk);
            start = 0;

            // wait until multiplication completes
            wait(done == 1);

            // check result
            checker_scoreboard(a_in * b_in, test_name);

            @(posedge clk);
        end
    endtask

    // -------------------------------------------------
    // Reset Task
    // -------------------------------------------------
    task apply_reset;
        begin
            rst = 1;

            @(posedge clk);
            @(posedge clk);

            rst = 0;

            $display("RESET APPLIED");
        end
    endtask

    // -------------------------------------------------
    // Main Test Sequence
    // -------------------------------------------------
    initial begin

        // Initial reset
        apply_reset();

        // Test cases
        apply_inputs(8'd13, 8'd11, "NORMAL TEST");
        apply_inputs(8'd0 , 8'd0 , "ZERO TEST");
        apply_inputs(8'd255, 8'd255, "MAX VALUE TEST");
        apply_inputs(8'd1 , 8'd255, "UNITY TEST");
        apply_inputs(8'd128, 8'd2 , "POWER OF 2 TEST");

        // Reset during operation
        @(posedge clk);
        a = 8'd5;
        b = 8'd3;
        start = 1;

        @(posedge clk);
        start = 0;

        // reset before completion
        @(posedge clk);
        rst = 1;

        @(posedge clk);

        if(product == 0 && done == 0)
            $display("RESET DURING OPERATION TEST PASSED");
        else
            $display("RESET DURING OPERATION TEST FAILED");

        rst = 0;

        #20;
        $finish;
    end

    initial begin
        $dumpfile("tb_seq_multiplier.vcd");
        $dumpvars(0, tb_seq_multiplier);
    end

    initial begin
        #100000;

        $error("ERROR : Simulation timeout!");

        $finish;
    end
endmodule

