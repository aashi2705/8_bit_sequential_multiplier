module tb_controller;

    bit clk, rst, start, last, do_add;
    bit load, add_en, shift, count_en, clear, done;
    bit expected_load, expected_add_en, expected_shift, expected_count_en, expected_clear, expected_done; 
    
    task checker_scoreboard; 
        input string test; begin
        if(load==expected_load && add_en==expected_add_en && shift==expected_shift && count_en==expected_count_en && clear==expected_clear && done==expected_done) $display("%s test PASSED", test);
        else begin
            $display("%s test FAILED", test);
            $display("Expected: load=%0b add_en=%0b shift=%0b count_en=%0b clear=%0b done=%0b",
                          expected_load, expected_add_en,expected_shift,expected_count_en,expected_clear,expected_done);

            $display("Got:      load=%0b add_en=%0b shift=%0b count_en=%0b clear=%0b done=%0b",
                          load,add_en,shift,count_en,clear,done); end
        end
    endtask

    task apply_values;
            input rst_, start_, last_, do_add_; begin
            rst = rst_;
            start = start_; 
            last = last_; 
            do_add= do_add_; end
    endtask

    initial begin
        clk=0;
        forever #5 clk=~clk;
    end

    controller dut(.clk(clk), .rst(rst), .do_add(do_add), .start(start), .last(last), .load(load), 
					.add_en(add_en), .shift(shift), .count_en(count_en), .clear(clear), .done(done));
    
    initial begin

        expected_load=0; expected_add_en=0; expected_shift=0; expected_count_en=0; expected_clear=0; expected_done=0;

        //initial reset
        apply_values(1,0,0,0);
        #2 checker_scoreboard("RESET");

        //initial start
        @(posedge clk); apply_values(0,1,0,0);
        @(posedge clk); apply_values(0,0,0,0);
        expected_load=1; expected_clear=1;
        #2 checker_scoreboard("START AND LOAD");

        expected_load=0;
        expected_clear=0;

        @(posedge clk);
        //do_add=1
        apply_values(0,0,0,1);
        @(posedge clk);
        expected_add_en=1;
        #2 checker_scoreboard("ADD");

        expected_add_en=0;
        //shift
        @(posedge clk);
        expected_shift=1; expected_count_en=1;
        #2 checker_scoreboard("SHIFT");

        

        //do_add=0
        @(posedge clk);
        apply_values(0,0,0,0);
        @(posedge clk); expected_add_en=0;
        #2 checker_scoreboard("NO ADD");

        expected_shift=0;
        expected_count_en=0;

        //done test
        apply_values(0,0,1,0);
        @(posedge clk);
        expected_done = 1;
        #2;
        checker_scoreboard("DONE");

    #20;
    $finish;
    end

initial begin
    $dumpfile("module_controller.vcd");
    $dumpvars(0, tb_controller);
end
endmodule




    