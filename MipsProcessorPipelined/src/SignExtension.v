`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Andrew Camps
// Module - SignExtension.v
// Description - Sign extension module.
////////////////////////////////////////////////////////////////////////////////
module SignExtension(in, out, sign);

    /* A 16-Bit input word */
    input [15:0] in;
    input sign;
    
    /* A 32-Bit output word */
    output reg [31:0] out;
    
    /* Fill in the implementation here ... */
    
    always @(*) begin
        if(sign)
            out <= $signed(in);
        else
            out <= in;
    end

endmodule
