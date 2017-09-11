`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Module - Mux32Bit2To1.v
// Description - Performs signal multiplexing between 2 32-Bit words.
////////////////////////////////////////////////////////////////////////////////

module Mux2To1(out, in0, in1, sel);
    parameter N = 32;
    output reg [N-1:0] out;

    input [N-1:0] in0;
    input [N-1:0] in1;
    input sel;
    
    always @(*) begin
      
        if(sel == 1'b0)
            out <= in0;
        else
            out <= in1;

    end

endmodule
