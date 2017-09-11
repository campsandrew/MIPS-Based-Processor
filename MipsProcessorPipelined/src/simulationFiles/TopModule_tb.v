`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Andrew Camps
// Create Date: 10/23/2016 07:29:09 PM
// Module Name: TopModule_tb
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
