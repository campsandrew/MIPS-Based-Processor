`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Module - ALU32Bit.v
// Description - 32-Bit wide arithmetic logic unit (ALU).
//
// INPUTS:-
// ALUControl: 4-Bit input control bits to select an ALU operation.
// A: 32-Bit input port A.
// B: 32-Bit input port B.
//
// OUTPUTS:-
// ALUResult: 32-Bit ALU result output.
// ZERO: 1-Bit output flag. 
//
// FUNCTIONALITY:-
// Design a 32-Bit ALU behaviorally, so that it supports addition,  subtraction,
// AND, OR, and set on less than (SLT). The 'ALUResult' will output the 
// corresponding result of the operation based on the 32-Bit inputs, 'A', and 
// 'B'. The 'Zero' flag is high when 'ALUResult' is '0'. The 'ALUControl' signal 
// should determine the function of the ALU based on the table below:-
// Op   | 'ALUControl' value
// ==========================
// ADD  | 0000 | 0
// SUB  | 0001 | 1
// AND  | 0010 | 2
// OR   | 0011 | 3
// SLT  | 0100 | 4
// SLL  | 0101 | 5
// SRL  | 0110 | 6
//SLLV  | 0111 | 7
// SRLV | 1000 | 8
// SRA  | 1001 | 9
// MUL  | 1010 | 10
// NOR  | 1011 | 11
// XOR  | 1100 | 12
// SRAV | 1101 | 13
// NOTE:-
// SLT (i.e., set on less than): ALUResult is '32'h000000001' if A < B.
// 
////////////////////////////////////////////////////////////////////////////////

module ALU32Bit(ALUControl, A, B, ALUResult, Shift, move, rotate);

	input [4:0] ALUControl; // control bits for ALU operation
	input [31:0] A, B;	    // inputs
    input [4:0] Shift;
    input rotate;
    output reg move;
	output reg [63:0] ALUResult;	// answer
	
	localparam SEH = 24, SEB = 16, ADD = 0;

    /* Please fill in the implementation here... */
    
    always @(*) begin
         move <= 1;
         ALUResult <= 0;
    
         case (ALUControl)
            5'b00000:
                case(Shift)
                    SEH: ALUResult <= $signed(B[15:0]);
                    SEB: ALUResult <= $signed(B[7:0]);
                    ADD: ALUResult <= $signed(A + B);       //ADD 
                    default: ALUResult <= $signed(A + B);   //ADD 
                endcase 
            5'b00001: ALUResult <= $signed(A - B);          //SUB
            5'b00010: ALUResult <= $signed(A * B);          //MUL
            5'b00011:                                       //SLT 
                begin
                    if ($signed(A) < $signed(B))
                        ALUResult <= 'd1;
                    else
                        ALUResult <= 'd0;
                        
                end
            5'b00100: ALUResult <= A & B;                   //AND
            5'b00101: ALUResult <= A | B;                   //OR
            5'b00110: ALUResult <= ~(A | B);                //NOR
            5'b00111: ALUResult <= A ^ B;                   //XOR
            5'b01000: ALUResult <= B << Shift;              //SLL
            5'b01001: begin                                 //ROTATE
                if(rotate == 0)
                    ALUResult <= B >> Shift;           
                else
                    ALUResult <= (B >> Shift) + (B << (32 - Shift));
            end                                             //SRL
            5'b01010: ALUResult <= B << A[4:0];             //SLLV
            5'b01011: begin
                if(Shift == 0)
                    ALUResult <= B >> A[4:0];
                else
                    ALUResult <= (B >> A[4:0]) + (B << (32 - A[4:0]));
            end                                             //SRLV
            5'b01100: ALUResult <=  $signed(B) >>> Shift;    //SRA
            5'b01101: ALUResult <= $signed(B) >>> A[4:0];    //SRV    
            5'b01111: begin                                 //SLTU
                if(A < B)
                    ALUResult <= 1;
                else
                    ALUResult <= 0;
            end
            5'b10000: begin                                 //MOVN
                if(B != 0) begin
                    ALUResult <= A;
                    move <= 1;
                    end
                else
                    move <= 0;
            end
            5'b10001: begin                                 //MOVZ
                if(B == 0) begin
                    ALUResult <= A;
                    move <= 1;
                    end
                else
                    move <= 0;
                end
            5'b10010: ALUResult <= A * B;                   //MULU
            5'b10101: ALUResult <= {B[15:0], 16'b0};        //LUI       
            default: ALUResult <= 'd0;
        endcase
    end
    

endmodule

