`timescale 1ns / 1ps

//Name: Andrew Camps


module TopModule(Clk, Reset, NumberA, NumberB, out7, en_out);
    
    input Clk, Reset;
    output [6:0] out7;
    output [7:0] en_out;
    output reg [7:0] NumberA, NumberB;
    
    wire [31:0] pcInst, WriteData, X, Y;
    
    wire ClkOut;
    
    //Two4DigitDisplay(Clk, NumberA, NumberB, out7, en_out);
    Two4DigitDisplay  display(Clk, NumberA, NumberB, out7, en_out);
    
    //ClkDiv(Clk, Rst, ClkOut);
    ClkDiv #(10) div(Clk, Reset, ClkOut);
      
    //Processor(Clk, Rst, pcInst, WriteData);
    PipelinedProcessor processor(ClkOut, Reset, pcInst, WriteData, X, Y);
    
    always @(*) begin
        NumberA <= X[7:0];
        NumberB <= Y[7:0];
    end
    
endmodule
