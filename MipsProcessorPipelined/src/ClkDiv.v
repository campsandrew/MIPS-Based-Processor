`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Create Date: 10/23/2016 07:22:32 PM
// Module Name: ClkDiv
//////////////////////////////////////////////////////////////////////////////////


module ClkDiv(Clk, Rst, ClkOut);

    input Clk, Rst;
    output reg ClkOut;

    parameter N = 10;
    
    reg [27:0] DivCnt;
    reg ClkInt;
    
     //DivVal_1HZ = 50000000, 
     //DivVal_0.5HZ = 100000000;
     
     initial begin
        DivCnt = 0;
        ClkOut = 0;
        ClkInt = 0;
     end
              
    always @(posedge Clk) begin
        if( DivCnt >= N ) begin
            ClkOut <= ~ClkInt;
            ClkInt <= ~ClkInt;
            DivCnt <= 0;
        end
        else begin
                ClkOut <= ClkInt;
                DivCnt <= DivCnt + 1;
            end
        end         
              
endmodule