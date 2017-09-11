`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/06/2016 09:48:53 PM
// Design Name: Andrew Camps
// Module Name: Comparator
//////////////////////////////////////////////////////////////////////////////////


module Comparator(Opcode, IBit16, A, B, Out);

    input [31:0] A, B;
    input [5:0] Opcode;
    input IBit16;
    output reg Out;
    
    localparam Beq = 4, Bne = 5, BgezBltz = 1, Blez = 6, Bgtz = 7;
    
    initial begin
        Out <= 0;
    end
    
    always @(*) begin
    
        Out <= 0;
    
        case (Opcode)
            Beq: begin
                if($signed(A) == $signed(B))
                    Out <= 1;
            end
            Bne: begin
                if($signed(A) != $signed(B))
                    Out <= 1;
            end
            BgezBltz: begin
                if(IBit16) begin    //BGEZ
                    if($signed(A) >= $signed(B))
                        Out <= 1;
                end
                else begin               //BLTZ
                    if($signed(A) < $signed(B))
                        Out <= 1;
                end
                    
            end
            Blez: begin
                if($signed(A) <= $signed(B))
                    Out <= 1;
            end
            Bgtz: begin
                if($signed(A) > $signed(B))
                    Out <= 1;
            end
        
            default: Out <= 0;
        endcase

    end
endmodule
