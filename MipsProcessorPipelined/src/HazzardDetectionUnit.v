`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Create Date: 11/06/2016 02:44:26 PM
// Module Name: HazzardDetectionUnit
//////////////////////////////////////////////////////////////////////////////////


module HazzardDetectionUnit(OpCode,EX_RegW, EX_MemRead, EX_RegRD, ID_RegRS, ID_RegRT, PCWriteSel, IF_WriteSel_ID, ControlNopSel, M_MemRead, M_RegRD, EX_RegRS, EX_RegRT, EXMemEn, controlNopSelMem);

    input [4:0] EX_RegRD, ID_RegRS, ID_RegRT, M_RegRD, EX_RegRS, EX_RegRT;
    input [5:0] OpCode;
    
    input EX_MemRead, EX_RegW, M_MemRead;
    output reg IF_WriteSel_ID, ControlNopSel, PCWriteSel, EXMemEn, controlNopSelMem;
    
    parameter BEQ = 4, BGEZBLTZ = 1, BGTZ = 7, BLEZ = 6, BNE = 5;
    initial begin
        IF_WriteSel_ID <= 1;
        PCWriteSel <= 1;
        ControlNopSel <= 0;
        EXMemEn <= 1;
        controlNopSelMem <= 0;
    end
    
    always @(*) begin
    
        IF_WriteSel_ID <= 1;
        PCWriteSel <= 1;
        ControlNopSel <= 0;
        EXMemEn <= 1;
        controlNopSelMem <= 0;
        if(OpCode == BEQ || OpCode == BGEZBLTZ || OpCode == BGTZ || OpCode == BLEZ || OpCode == BNE) begin
            if((ID_RegRS == EX_RegRD || ID_RegRT == EX_RegRD) && EX_RegW == 1)begin
                IF_WriteSel_ID <= 0;
                PCWriteSel <= 0;
                ControlNopSel <= 1;
                end
                
            if(EX_MemRead == 1 && (ID_RegRS == EX_RegRD || ID_RegRT == EX_RegRD)) begin
                IF_WriteSel_ID <= 0;
                PCWriteSel <= 0;
                ControlNopSel <= 1;
            end
            
            if(M_MemRead == 1 && (ID_RegRS == M_RegRD || ID_RegRT == M_RegRD)) begin
                IF_WriteSel_ID <= 0;
                PCWriteSel <= 0;
                ControlNopSel <= 1;
            end
            
         end
         else begin
         
            if(M_MemRead == 1 && (EX_RegRS == M_RegRD || EX_RegRT == M_RegRD )) begin
                IF_WriteSel_ID <= 0;
                PCWriteSel <= 0;
                ControlNopSel <= 1;
                EXMemEn <= 0;
                controlNopSelMem <= 1;
                 
            end
            
         end
         
             
         
    
    end


endmodule
