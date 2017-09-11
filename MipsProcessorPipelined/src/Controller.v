`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 10/10/2016 03:29:00 PM
// Design Name: Andrew Camps
// Module Name: Controller
//////////////////////////////////////////////////////////////////////////////////


module Controller(Opcode, RegDst, Signed, RegWrite, ALUSrc, ALUOp, Jump, JumpJal, SaveRa, MemWrite, MemRead, MemToReg, Amt, IF_Flush);
    input [5:0] Opcode;
    output reg RegDst, Signed, RegWrite, ALUSrc, Jump, JumpJal, SaveRa, MemWrite, MemRead, MemToReg, IF_Flush;
    output reg [3:0] ALUOp;
    output reg [1:0] Amt;
    
    reg [16:0] returnBits;
    
    localparam ArithR = 0, Bltz = 1, J = 2, Jal = 3, Beq = 4, Bne = 5, Blez = 6, Bgtz = 7, Addi = 8, Addiu = 9, Xori = 14, Andi = 12, Ori = 13, Slti = 10, Sltiu = 11, Mul = 28, 
    MSubAdd = 28, SehSeb = 31, Lw = 35, Sw = 43, Sb = 40, Sh = 41, Lh = 33, Lb = 32, Lui = 15;
    
    initial begin
        RegDst <= 0;
        Signed <= 0;
        RegWrite <= 0;
        ALUSrc <= 0;
        ALUOp <= 0;
        Jump <= 0;
        JumpJal <= 0;
        SaveRa <= 0;
        MemWrite <= 0;
        MemRead <= 0;
        MemToReg <= 0;
        Amt <= 0;
        IF_Flush <= 0;
    end
    
    always @(*) begin
    
        RegDst <= 0;
        Signed <= 0;
        RegWrite <= 0;
        ALUSrc <= 0;
        ALUOp <= 0;
        Jump <= 0;
        JumpJal <= 0;
        SaveRa <= 0;
        MemWrite <= 0;
        MemRead <= 0;
        MemToReg <= 0;
        Amt <= 0;
        IF_Flush <= 0;
        
        case (Opcode)
            ArithR:     returnBits <= 'b11100000000000000;
            Addi:       returnBits <= 'b01110001000000000;              
            Addiu:      returnBits <= 'b01110001000000000; 
            Andi:       returnBits <= 'b00110010000000000;
            Slti:       returnBits <= 'b01110101000000000;
            Sltiu:      returnBits <= 'b00110101000000000;
            Ori:        returnBits <= 'b00110011000000000;
            Xori:       returnBits <= 'b00110100000000000;
            Mul:        returnBits <= 'b11100110000000000;
            SehSeb:     returnBits <= 'b11100000000000000;
            J:          returnBits <= 'b00000000100000001;
            Jal:        returnBits <= 'b10101111111000001;       
            Lw:         returnBits <= 'b01111000000011000;
            Lb:         returnBits <= 'b01111000000011010;
            Lh:         returnBits <= 'b01111000000011100;
            Sw:         returnBits <= 'b01011000000100000;
            Sb:         returnBits <= 'b01011000000100010;
            Sh:         returnBits <= 'b01011000000100100;
            Lui:        returnBits <= 'b01111001000000000;
            Bne:        returnBits <= 'b01001111000000000;
            Beq:        returnBits <= 'b01001111000000000;
            Bltz:       returnBits <= 'b01001111000000000;
            Bgtz:       returnBits <= 'b01001111000000000;
            Blez:       returnBits <= 'b01001111000000000;
            default:    returnBits <= 'b00000000000000000;
                
        endcase
        
        RegDst <= returnBits[16];
        Signed <= returnBits[15];
        RegWrite <= returnBits[14];
        ALUSrc <= returnBits[13];
        ALUOp <= returnBits[12:9];
        Jump <= returnBits[8];
        JumpJal <= returnBits[7];
        SaveRa <= returnBits[6];
        MemWrite <= returnBits[5];
        MemRead <= returnBits[4];
        MemToReg <= returnBits[3];
        Amt <= returnBits[2:1];
        IF_Flush <= returnBits[0];

    end
        
    

endmodule
