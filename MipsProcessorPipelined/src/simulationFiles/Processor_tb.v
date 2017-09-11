`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2016 01:06:41 AM
// Design Name: 
// Module Name: Processor_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Processor_tb();

    reg Clk, Rst;
    wire [31:0] PCInstruction, WriteData;
    wire [31:0] X, Y; 

    //PipelinedProcessor(Clk, Rst, PCInstruction, WriteData);
    PipelinedProcessor processor(Clk, Rst, PCInstruction, WriteData, X, Y);

    initial begin
		Clk <= 1'b0;
		forever #300 Clk <= ~Clk;
	end
	
	initial begin
	   Rst <= 1;
	   @(posedge Clk);
	       Rst <= 0;
	   @(posedge Clk);
	   
	end

endmodule
