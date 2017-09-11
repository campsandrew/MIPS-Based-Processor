`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/07/2016 02:28:13 AM
// Design Name: Andrew Camps
// Module Name: ForwardingUnit
//////////////////////////////////////////////////////////////////////////////////


module ForwardingUnit(RSReg_ID, RTReg_ID, RSReg_EX, RTReg_EX, RTReg_M, RDReg_M, RDReg_WB, M_RegWrite, WB_RegWrite, MemRead_WB, MemWrite_M, MemWrite_EX, RS_ID, RT_ID, RS_M, RT_M, RS_WB, RT_WB, RS_ID_M, RT_ID_M, LwSwSel);

    input [4:0] RSReg_ID, RTReg_ID, RSReg_EX, RTReg_EX, RTReg_M, RDReg_M, RDReg_WB;
    input M_RegWrite, WB_RegWrite, MemRead_WB, MemWrite_M, MemWrite_EX;
    output reg RS_ID, RT_ID, RS_M, RT_M, RS_WB, RT_WB, RS_ID_M, RT_ID_M, LwSwSel;
    
    initial begin
        RS_ID <= 0;
        RT_ID <= 0;
        RS_M <= 0;
        RT_M <= 0;
        RS_WB <= 0;
        RT_WB <= 0;
        RS_ID_M <= 0;
        RT_ID_M <= 0;
        LwSwSel <= 0;
    end
    
    always @(*) begin
    
        RS_ID <= 0;
        RT_ID <= 0;
        RS_M <= 0;
        RT_M <= 0;
        RS_WB <= 0;
        RT_WB <= 0;
        RS_ID_M <= 0;
        RT_ID_M <= 0;
        LwSwSel <= 0;
        
        if(RTReg_M == RDReg_WB && MemRead_WB == 1 && MemWrite_M == 1)
            LwSwSel <= 1;
            
        if(RTReg_M == RDReg_WB && MemWrite_M == 1 && WB_RegWrite == 1)
            LwSwSel <= 1;
            
        if(RTReg_EX == RDReg_WB && MemRead_WB == 1 && MemWrite_EX == 1)
            RT_WB <= 1;
        
        if(WB_RegWrite == 1 && RDReg_WB != 0 && RDReg_WB == RSReg_ID)
            RS_ID <= 1;
            
        if(WB_RegWrite == 1 && RDReg_WB != 0 && RDReg_WB == RTReg_ID)
            RT_ID <= 1;
    
        if(M_RegWrite == 1 && RDReg_M != 0 && RDReg_M == RSReg_EX)
            RS_M <= 1;
        else if(WB_RegWrite == 1 && RDReg_WB != 0 && RDReg_WB == RSReg_EX)//~(M_RegWrite == 1 && RDReg_M != 0 && RDReg_M != RSReg_EX) && 
            RS_WB <= 1;
            
        if(M_RegWrite == 1 && RDReg_M != 0 && RDReg_M == RTReg_EX)
            RT_M <= 1;
        else if(WB_RegWrite == 1 && RDReg_WB != 0 && RDReg_WB == RTReg_EX)//~(M_RegWrite == 1 && RDReg_M != 0 && RDReg_M != RTReg_EX) && 
            RT_WB <= 1;
        
        if(M_RegWrite ==1 && RDReg_M == RSReg_ID)
            RS_ID_M <= 1;
        if(M_RegWrite ==1 && RDReg_M == RTReg_ID)
            RT_ID_M <= 1;
          
          if(WB_RegWrite == 1 && RDReg_WB == RSReg_EX) 
                RS_WB <= 1;
          if(WB_RegWrite == 1 && RDReg_WB == RTReg_EX) 
                RT_WB <= 1;
                          
                
            
        
    end

endmodule
