This project implements an **8-bit Sequential Shift-and-Add Multiplier** in SystemVerilog using a modular RTL design.
The multiplier computes the product of two 8-bit unsigned numbers over multiple clock cycles by repeatedly performing conditional addition and right-shift operations under the control of a finite state machine (FSM).
The design is divided into independent modules for the datapath, control logic, and counter, enabling modular development and verification.
Individual testbenches and a top-level integration testbench are used to validate the functionality of the complete multiplier.
Final module should compute 16-bit product over multiple cycles using a shift-and-add datapath plus a control FSM. 

**Module1 - multi_reg**
The **multi_reg module** is the datapath register block of the sequential shift-and-add multiplier.
It stores and manipulates the three main registers used during multiplication:

A – Accumulator register (stores partial sum)
M – Multiplicand register (holds the first operand)
Q – Multiplier register (holds the second operand and gradually becomes the lower half of the product)

It performs four operations in priority order:

1) Reset
2) Load
3) Add
4) Shift

**Module2 - bit_counter**

The bit_counter module is responsible for tracking the number of multiplication iterations performed by the sequential multiplier.
Since an 8-bit multiplication requires eight shift operations, this module counts from 0 to 7 and informs the controller when the multiplication process is complete.

It performs three operations in priority order:

1) Reset – Clears the counter to zero.
2) Clear – Synchronously resets the counter when a new multiplication begins.
3) Count – Increments the counter on every shift operation.

It also generates the last signal, which becomes high when the counter reaches 7, indicating that all eight iterations have been completed.

**Module3 - add_decision**

The add_decision module is the combinational arithmetic block of the sequential multiplier.
It computes the addition required during multiplication and determines whether the addition should actually be performed based on the least significant bit of the multiplier.

It performs two operations:

Addition – Continuously computes A + M and produces the result as sum.
Decision – Generates the control signal do_add, which is equal to Q[0]. If Q[0] is high, the accumulator will be updated; otherwise, the addition is skipped.

Since this module is purely combinational, it contains no registers or clocked logic.

**Module4 - controller**

The controller module is the finite state machine (FSM) that controls the entire multiplication process.
It coordinates all datapath operations by generating the control signals required for loading operands, performing addition, shifting registers, counting iterations, and signalling completion.

The controller operates through the following states:

1) IDLE – Waits for the start signal.
2) LOAD – Loads the operands into the datapath and clears the counter.
3) CHECK – Checks whether the current multiplier bit (Q[0]) requires an addition.
4) ADD – Enables the accumulator to store the computed sum.
5) SHIFT – Right shifts the combined register {A,Q} and increments the counter.
6) DONE – Asserts the done signal to indicate that the multiplication has finished.

The controller ensures that only one datapath operation is enabled during each clock cycle.

**Module5 - seq_multiplier**

The seq_multiplier module is the top-level module of the project.
It integrates all the individual modules—mult_regs, bit_counter, add_decision, and controller—to implement a complete 8-bit sequential shift-and-add multiplier.

Its responsibilities are:

Instantiate all submodules.
Connect the datapath and control signals between the modules.
Provide the external interface for clock, reset, start, multiplicand, and multiplier inputs.
Generate the final 16-bit product by concatenating the accumulator and multiplier registers ({A[7:0], Q}).
Assert the done signal once the multiplication process has completed.

This module serves as the integration layer that combines the datapath, controller, and counter into a fully functional sequential multiplier.
