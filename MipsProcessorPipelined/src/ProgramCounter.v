`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Andrew Camps
// Module - pc_register.v
// Description - 32-Bit program counter (PC) register.
//
// INPUTS:-
// Address: 32-Bit address input port.
// Reset: 1-Bit input control signal.
// Clk: 1-Bit input clock signal.
//
// OUTPUTS:-
// PCResult: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design a program counter register that holds the current address of the 
// instruction memory.  This module should be updated at the positive edge of 
// the clock. The contents of a register default to unknown values or 'X' upon 
// instantiation in your module. Hence, please add a synchronous 'Reset' 
// signal to your PC register to enable global reset of your datapath to point 
// to the first instruction in your instruction memory (i.e., the first address 
// location, 0x00000000H).
////////////////////////////////////////////////////////////////////////////////

module ProgramCounter(Address, PCResult, Reset, Clk, Write);

	input [31:0] Address;
	input Reset, Clk, Write;

	output reg [31:0] PCResult;

    /* Please fill in the implementation here... */
    
    //Reset
    always @(posedge Clk) begin
        if (Reset)            //if reset is 1 sets the instruction address to output as 0 else it sets the address calculated y the adder to the next instruction
            PCResult <= 32'd0;
        else 
            if(Write)
                PCResult <= Address;
 
        
    end

endmodule

