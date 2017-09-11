`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Create Date: 10/13/2016 05:34:31 PM
// Module Name: AddSub64Bit
//////////////////////////////////////////////////////////////////////////////////


module AddSub64Bit(A, B, Out, Add);

    input [63:0] A, B;
    input Add;
    
    output reg [63:0] Out;
    
    always @* begin
        if(Add)
            Out <= A + B;
        else
            Out <= A - B;
    end
    
    
endmodule
