`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2016 07:29:09 PM
// Design Name: 
// Module Name: TopModule_tb
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


module TopModule_tb();

    reg Clk, Rst;
    wire [7:0] X, Y, en_out; 
    wire [6:0] out7;

    //TopModule(Clk, Reset, NumberA, NumberB, out7, en_out);
    TopModule top(Clk, Rst, X, Y, out7, en_out);

    initial begin
		Clk <= 1'b0;
		forever #100 Clk <= ~Clk;
	end
	
	initial begin
	       #100 Rst <= 1;
	    @(posedge Clk);
	    @(posedge Clk);
	    @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);
        @(posedge Clk);                  
	       #100 Rst <= 0;
	end

endmodule
