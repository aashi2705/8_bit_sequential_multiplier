`timescale 1ns/1ps

module tb_add_decision;
	bit [8:0] A;
	bit [7:0] M;
	bit Q_lsb;

	bit [8:0] sum;
	bit do_add;

	// Expected outputs
	bit [8:0] expected_sum;
	bit expected_do_add;
	
	// DUT Instantiation
	add_decision dut (
		.A(A),
		.M(M),
		.Q_lsb(Q_lsb),
		.sum(sum),
		.do_add(do_add)
	);

	
	// Checker + Scoreboard
	

	task checker_scoreboard;

		input [8:0] expected_sum;
		input expected_do_add;
		input string test_name;

		begin

			if ((sum == expected_sum) &&
				(do_add == expected_do_add))

				$display("%s TEST PASSED | sum=%0d do_add=%0b",test_name, sum, do_add);
						  

			else

				$error("%s TEST FAILED | DUT: sum=%0d do_add=%0b | Expected: sum=%0d do_add=%0b", test_name, sum, do_add, expected_sum, expected_do_add);
						
						
		end

	endtask

	task apply_inputs;

		input [8:0] A_in;
		input [7:0] M_in;
		input Q_lsb_in;

		begin

			A = A_in;
			M = M_in;
			Q_lsb = Q_lsb_in;

			#10;

			$display("Inputs Applied -> A=%0d M=%0d Q_lsb=%0b", A, M, Q_lsb);
					  

		end

	endtask

	

	initial begin

		
		// Test Case 1
		apply_inputs(5, 3, 1);

		expected_sum = 8;
		expected_do_add = 1;

		checker_scoreboard(expected_sum,expected_do_add,"TC1");

		// Test Case 2
		

		apply_inputs(10, 7, 0);

		expected_sum = 17;
		expected_do_add = 0;

		checker_scoreboard(expected_sum,expected_do_add,"TC2");
						   
						  

		// Test Case 3
		

		apply_inputs(0, 0, 0);

		expected_sum = 0;
		expected_do_add = 0;

		checker_scoreboard(expected_sum, expected_do_add,"TC3");
						   
						   
		// Test Case 4
		

		apply_inputs(255, 255, 1);

		expected_sum = 510;
		expected_do_add = 1;

		checker_scoreboard(expected_sum, expected_do_add,"TC4");
						   
						   

		$display(" TESTBENCH COMPLETED ");
		
		$finish;

	end
    initial begin
    $dumpfile("add_decision.vcd");
    $dumpvars(0, tb_add_decision);
end

endmodule

