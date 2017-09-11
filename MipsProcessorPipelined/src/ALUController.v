`timescale 1ns / 1ps
// ECE369 - Computer Architecture
// Name: Andrew Camps

module ALUController(ALUOp, FunctionCode, ALUControl, WDataSel,HWrite, LWrite, HLRead, HiSel, LoSel, AddSubSel, HLRegSel, Add, RegWriteSel, JumpRa, JR_Flush);
    input [3:0] ALUOp;
    input [5:0] FunctionCode;
    output reg [4:0] ALUControl;
    output reg HWrite, LWrite, HLRead, HiSel, LoSel, AddSubSel, HLRegSel, Add, WDataSel, RegWriteSel, JumpRa, JR_Flush;
    
   //arithmetic operations
    localparam  Arith = 0, IArithAdd = 1, IArithAnd = 2, IArithOr = 3, IArithXor = 4, IArithSlt = 5, OPMUL = 6, LwSw = 8, Lui = 9, BeqBne = 10, Bltz = 11, Bgtz = 12, Blez = 13,
                    add = 32, addu = 33, mul = 2, sub = 34,  mult = 24, multu = 25, madd = 0, msub = 4, jr = 8;
                
    //logical operations            
    localparam AND = 36, OR = 37, XOR = 38, ori = 0, NOR = 39, slt = 42, sll = 0, srl = 2, sllv = 4, srlv = 6, sra = 3, srav = 7,
                sltu = 43, movn = 11, movz = 10; 

                 
   //Data operations
   localparam mthi = 17, mtlo = 19, mfhi = 16, mflo = 18;
                
   //ALU control signals                     
   localparam ADD = 0, SUB = 1, MUL = 2, SLT = 3, ANDOUT = 4, OROUT = 5, NOROUT = 6, 
                XOROUT = 7, SLL = 8, SRL = 9, SLLV = 10, SRLV = 11, SRA = 12, SRAV = 13, 
                BLTZ = 14, SLTU = 15, MOVN = 16, MOVZ = 17, MULU = 18, BGTZ = 19, BLEZ = 20, LUI = 21;
                
   initial begin
       HWrite <= 0;
       LWrite <= 0;
       HLRead <= 0;
       HiSel <= 0;
       LoSel <= 0;
       AddSubSel <= 0;
       HLRegSel <= 0;
       Add <= 0;
       WDataSel <= 0;
       RegWriteSel <= 0;
       JumpRa <= 0;
       ALUControl <= 0;
       JR_Flush <= 0;
   end
    
   always @ (*) begin        
        HWrite <= 0;
        LWrite <= 0;
        HLRead <= 0;
        HiSel <= 0;
        LoSel <= 0;
        AddSubSel <= 0;
        HLRegSel <= 0;
        Add <= 0;
        WDataSel <= 0;
        RegWriteSel <= 0;
        JumpRa <= 0;
        ALUControl <= 0;
        JR_Flush <= 0;
        case (ALUOp)
        Arith: begin
            case (FunctionCode)
                //arithmetic
                add: ALUControl <= ADD;       
                addu: ALUControl <= ADD;
                sub: ALUControl <= SUB;
                mult: begin 
                    ALUControl <= MUL;
                    HWrite <= 1;
                    LWrite <= 1;
                    RegWriteSel <= 1;
                end
                multu: begin
                    ALUControl <= MULU;
                    HWrite <= 1;
                    LWrite <= 1;
                    RegWriteSel <= 1;
                end
                
//                //logical
                AND: ALUControl <= ANDOUT;
                OR: ALUControl <= OROUT;
                NOR: ALUControl <= NOROUT;
                XOR: ALUControl <= XOROUT;
                sll: ALUControl <= SLL;
                srl: ALUControl <= SRL;
                slt: ALUControl <= SLT;
                sllv:ALUControl <= SLLV;
                srlv: ALUControl <= SRLV;
                sra: ALUControl <= SRA;
                srav: ALUControl <= SRAV;
                movn: ALUControl <= MOVN;
                movz: ALUControl <= MOVZ;             
                sltu: ALUControl <= SLTU;
                jr: begin
                    JumpRa <= 1;
                    RegWriteSel <= 1;
                    JR_Flush <= 1;
                end
//                //Data Operations
                mthi: begin
                    HWrite <= 1;
                    HiSel <= 1;
                    RegWriteSel <= 1;                   
                end
                mtlo: begin
                    LWrite <= 1;
                    LoSel <= 1;
                    RegWriteSel <= 1;
                    end
                mfhi: begin
                
                    HLRead <= 1;
                    HLRegSel <= 1;
                    WDataSel <= 1;
                    end
                    
                mflo: begin
                    HLRead <= 1;
                    WDataSel <= 1;
                    end             
                default: ALUControl <= 0;
            endcase 
        end
        OPMUL: begin
            case (FunctionCode)
                madd: begin
                    ALUControl <= MUL;
                    HWrite <= 1;
                    LWrite <= 1;
                    HLRead <= 1;
                    AddSubSel <= 1;
                    Add <= 1;
                    RegWriteSel <= 1; 
                end
                msub: begin
                    ALUControl <= MUL;
                    HWrite <= 1;
                    LWrite <= 1;
                    HLRead <= 1;
                    AddSubSel <= 1;
                    RegWriteSel <= 1; 
                end
                mul: ALUControl <= MUL;
            endcase
        end
        IArithAdd: ALUControl <= ADD;
        IArithAnd: ALUControl <= ANDOUT;
        IArithOr: ALUControl <= OROUT;
        IArithXor: ALUControl <= XOROUT;
        IArithSlt: ALUControl <= SLT;
        LwSw: ALUControl <= ADD;
        Lui: ALUControl <= LUI;
        BeqBne: ALUControl <= SUB;
        Bltz: ALUControl <= BLTZ;
        Bgtz: ALUControl <= BGTZ;
        Blez: ALUControl <= BLEZ;
        default: ALUControl <= 0;
        
        endcase
    end
    

endmodule
