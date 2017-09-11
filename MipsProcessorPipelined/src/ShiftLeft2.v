`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 10/10/2016 01:01:51 AM
// Design Name: Andrew Camps
// Module Name: ShiftLeft2
//////////////////////////////////////////////////////////////////////////////////


module ShiftLeft2(in, out);

    parameter N = 32;

    input [N-1:0] in;
    output reg [N-1:0] out;
    
    always @(*) begin
    
        out <= in << 2;
    
    end

endmodule
