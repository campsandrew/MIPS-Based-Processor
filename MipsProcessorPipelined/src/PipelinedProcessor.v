`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Name: Andrew Camps
// Create Date: 10/28/2016 01:36:57 AM
// Module Name: PipelinedProcessor


module PipelinedProcessor(Clk, Rst, PCResult, WriteData, X, Y);

    input Clk, Rst;
    output [31:0] WriteData, PCResult;
    output wire [31:0] X, Y;
    
    
    reg [5:0] controllerInMem;
    wire[5:0] controllerNopMemOut;
    reg EX_RegWriteSelOut, EX_MemWriteSelOut,EX_MemReadSelOut, EX_MemToRegSelOut, EX_MuxMemOut;
    reg [1:0] EX_AmtSelOut; 
    
    //Fetch Wires//
    wire [31:0] IF_Instruction, IF_PCAddResult;
    wire IF_Flush, JR_Flush, FlushOrOu, controlNopSelMem, JRFlushOrOut;
    
    //Decode Wires//
    wire [31:0] ID_Instruction, ID_ReadData1, ID_ReadData2, ID_signExtOut, ID_PCAddResult, ID_branchAddOut;
    wire [3:0] ID_ALUOpSel;
    wire [1:0] ID_AmtSel;
    wire ID_SignExtSel, ID_RegWriteSel, ID_RegDstSel, ID_ALUSrcSel, ID_MemToRegSel, ID_MemWriteSel, ID_MemReadSel, ID_JumpSel, ID_SaveRaSel, 
            ID_BranchMuxSel, ID_JumpJalSel, ID_RaDstSel;

    //Execute Wires//
    wire [63:0] EX_ALUResult;
    wire [31:0] EX_signExtOut, EX_branchAddOut, EX_Instruction, EX_PCAddResult, EX_forwardMuxRTOut_ID;
    wire [4:0] EX_regDstOut, EX_ALUControlSel, EX_jalRaDst;
    wire [3:0] EX_ALUOpSel;
    wire [1:0] EX_AmtSel;
    wire EX_RegDstSel, EX_ALUSrcSel, EX_MemReadSel, EX_MemWriteSel, EX_JumpSel, EX_MemToRegSel, EX_RegWriteSel, EX_RaDstSel, EX_regWriteMuxOut, EX_RegWriteMuxSel,
            EX_AddSel, EX_AddMuxSel, EX_HiSel, EX_LoSel, EX_HWriteSel, EX_LWriteSel, EX_HLReadSel, EX_HLToRegSel, EX_SaveRaSel, EX_HiOrLoSel, 
            EX_JumpRaSel, EX_Move, EX_movAndOut;

    //Memory Wires//
    wire [63:0] M_ALUResult, AddSubOut, addSubMuxOut, M_HiLoReadData;
    wire [31:0] M_MemOut, M_PCAddResult, M_forwardMuxRSOut_WB, M_forwardMuxRTOut_WB, hiMuxOut, loMuxOut, M_Instruction;
    wire [4:0] M_regDstOut;
    wire [1:0] M_AmtSel;
    wire M_MemReadSel, M_MemWriteSel, M_MemToRegSel, M_regWriteMuxOut, M_AddSel, M_AddMuxSel, M_HiSel, M_LoSel, M_HWriteSel, 
            M_LWriteSel, M_HLReadSel, M_HLToRegSel, M_SaveRaSel, M_HiOrLoSel;
    
    //Write Back Wires//
    wire [63:0] WB_HiLoReadData;
    wire [31:0] WB_MemOut, WB_ALUResult, WB_PCAddResult;
    wire [4:0] WB_regDstOut;
    wire WB_MemToRegSel, WB_regWriteMuxOut, WB_HLToRegSel, WB_SaveRaSel, WB_HiOrLoSel, WB_MemReadSel;
    
    //Other//
    wire [31:0] aluSrcOut, jumpRaMuxOut, jumpMuxOut, branchMuxOut, branchShiftOut, memMuxOut, hlToRegMuxOut, hiOrLoMuxOut, nopMuxOut, forwardMuxRSOut_ID, forwardMuxRTOut_ID, 
                    forwardMuxRTOut_ID_M, forwardMuxRSOut_ID_M, EX_forwardMuxRSOut_ID, M_forwardMuxRSOut_ID, forwardMuxRSOut_M, forwardMuxRTOut_M, forwardMuxRSOut_WB, forwardMuxRTOut_WB, forwardLwSwOut;
    wire [27:0] jumpShiftOut;
    reg [16:0] controllerIn;
    wire [16:0] controllerNopOut;
    reg ID_RegDstSelOut, ID_SignExtSelOut, ID_RegWriteSelOut, ID_ALUSrcSelOut, ID_JumpSelOut, ID_RaDstSelOut, ID_SaveRaSelOut, ID_MemWriteSelOut, ID_MemReadSelOut, ID_MemToRegSelOut, IF_FlushOut;
    reg [3:0] ID_ALUOpSelOut;
    reg [1:0] ID_AmtSelOut;
    wire RS_M_Sel, RT_ID_Sel, RT_M_Sel, RS_WB_Sel, RT_WB_Sel, RS_ID_Sel, RS_ID_M_Sel, RT_ID_M_Sel, IF_WriteSel_ID, PCWriteSel, forwardLwSwSel, orNopOut, JAL_RegWriteMuxOut;
    reg [31:0] NOP = -1;
    reg [4:0] RA = 5'd31;
    reg Write = 1, ZERO = 0;
    
    
    
    
    /////////////////////Instruction Fetch Stage/////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    //PCAdder(PCResult, PCAddResult);
    PCAdder addPC(PCResult, IF_PCAddResult);
    //ProgramCounter(Address, PCResult, Reset, Clk, Write);
    ProgramCounter pc(jumpRaMuxOut, PCResult, Rst, Clk, PCWriteSel);
    //InstructionMemory(Address, Instruction);
    InstructionMemory im(PCResult, IF_Instruction);
    //Mux2to1(out, in0, in1, sel);
    Mux2To1 jumpRaMux(jumpRaMuxOut, jumpMuxOut, EX_forwardMuxRSOut_ID, EX_JumpRaSel);
    Mux2To1 jumpMux(jumpMuxOut, branchMuxOut, {{ID_PCAddResult[31:28]}, {jumpShiftOut}}, ID_JumpSel);
    Mux2To1 branchMux(branchMuxOut, IF_PCAddResult, ID_branchAddOut, ID_BranchMuxSel);  
    Mux2To1 nopMux(nopMuxOut, IF_Instruction, NOP, orNopOut);
    //Or(A, B, Out);
    Or orNop(IF_FlushOut, ID_BranchMuxSel, FlushOrOut);                              
    Or JRa(FlushOrOut, JR_Flush, orNopOut);
    
    
    
    
    /////////////////////Instruction Fetch Stage/////////////////////////////////////////////////////////////////////////////////////////
    //InstructionFetch/Decode Register(PipeLineRegister(Clk, in, out, Write, Flush))//
    PipeLineRegister IF_Instruction_ID(Clk, nopMuxOut, ID_Instruction, IF_WriteSel_ID);
    PipeLineRegister IF_PCAddResult_ID(Clk, IF_PCAddResult, ID_PCAddResult, IF_WriteSel_ID);
    //////////////////////////Decode Stage///////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    //RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2);
    RegisterFile regFile(ID_Instruction[25:21], ID_Instruction[20:16], WB_regDstOut, WriteData, WB_regWriteMuxOut, Clk, ID_ReadData1, ID_ReadData2, X, Y);
    //SignExtension(in, out, sign);
    SignExtension signExt(ID_Instruction[15:0], ID_signExtOut, ID_SignExtSelOut);
    //Controller(Opcode, RegDst, Signed, RegWrite, ALUSrc, ALUOp, Jump, JumpJal, SaveRa, MemWrite, MemRead, MemToReg, Amt, IF_Flush);
    Controller controller(ID_Instruction[31:26], ID_RegDstSel, ID_SignExtSel, ID_RegWriteSel, ID_ALUSrcSel, ID_ALUOpSel, ID_JumpSel, ID_RaDstSel, ID_SaveRaSel, ID_MemWriteSel, ID_MemReadSel, ID_MemToRegSel, ID_AmtSel, IF_Flush);
    //Adder32Bit(A, B, Out);
    Adder32Bit branchAdd(ID_PCAddResult, branchShiftOut, ID_branchAddOut);
    //ShiftLeft2(in, out);
    ShiftLeft2 branchShift(ID_signExtOut, branchShiftOut);
    ShiftLeft2 #(28) jumpShift({{2'b0}, {ID_Instruction[25:0]}}, jumpShiftOut);
    //Comparator(Opcode, IBit16, A, B, Out);-m
    Comparator branchCompare(ID_Instruction[31:26], ID_Instruction[16], forwardMuxRSOut_ID, forwardMuxRTOut_ID, ID_BranchMuxSel);
    //Mux2to1(out, in0, in1, sel);
    Mux2To1 forwardMuxRS_ID(forwardMuxRSOut_ID_M, ID_ReadData1, WriteData, RS_ID_Sel);
    Mux2To1 forwardMuxRT_ID(forwardMuxRTOut_ID_M, ID_ReadData2, WriteData, RT_ID_Sel);
    Mux2To1 M_forwardMuxRS_ID(forwardMuxRSOut_ID, forwardMuxRSOut_ID_M , M_ALUResult[31:0], RS_ID_M_Sel);
    Mux2To1 M_forwardMuxRT_ID(forwardMuxRTOut_ID, forwardMuxRTOut_ID_M , M_ALUResult[31:0], RT_ID_M_Sel);
    Or JRaController(ControlNopSel, JR_Flush, JRFlushOrOut);
    Mux2To1 #(17) controllerNop(controllerNopOut, controllerIn, 'b00001111000000000, JRFlushOrOut);
    
    
    
   //module HazzardDetectionUnit(OpCode, EX_MemRead, EX_RegRD, ID_RegRS, ID_RegRT, PCWriteSel, IF_WriteSel_ID, ControlNopSel);
    HazzardDetectionUnit hazzardUnit(ID_Instruction[31:26], EX_RegWriteSel ,  EX_MemReadSel, EX_regDstOut , ID_Instruction[25:21], ID_Instruction[20:16], PCWriteSel, IF_WriteSel_ID, ControlNopSel, M_MemReadSel, M_regDstOut, EX_Instruction[25:21], EX_Instruction[20:16], EXMemEn, controlNopSelMem);
    
    always @(*) begin
    
        controllerIn[16] <= ID_RegDstSel;
        controllerIn[15] <= ID_SignExtSel;
        controllerIn[14] <= ID_RegWriteSel;
        controllerIn[13] <= ID_ALUSrcSel;
        controllerIn[12:9] <= ID_ALUOpSel;
        controllerIn[8] <= ID_JumpSel;
        controllerIn[7] <= ID_RaDstSel;
        controllerIn[6] <= ID_SaveRaSel;
        controllerIn[5] <= ID_MemWriteSel;
        controllerIn[4] <= ID_MemReadSel;
        controllerIn[3] <= ID_MemToRegSel;
        controllerIn[2:1] <= ID_AmtSel;
        controllerIn[0] <= IF_Flush;
        
    end
    
    always @(*) begin
    
        ID_RegDstSelOut <= controllerNopOut[16];
        ID_SignExtSelOut <= controllerNopOut[15];
        ID_RegWriteSelOut <= controllerNopOut[14];
        ID_ALUSrcSelOut <= controllerNopOut[13];
        ID_ALUOpSelOut <= controllerNopOut[12:9];
        ID_JumpSelOut <= controllerNopOut[8];
        ID_RaDstSelOut <= controllerNopOut[7]; 
        ID_SaveRaSelOut <= controllerNopOut[6];
        ID_MemWriteSelOut <= controllerNopOut[5]; 
        ID_MemReadSelOut <= controllerNopOut[4];
        ID_MemToRegSelOut <= controllerNopOut[3]; 
        ID_AmtSelOut <= controllerNopOut[2:1]; 
        IF_FlushOut <= controllerNopOut[0];
    
    end
    
    
    
    
    
    //////////////////////////Decode Stage///////////////////////////////////////////////////////////////////////////////////////////////
    //Decode/Execute Registers(PipeLineRegister(Clk, in, out, Write))//
    PipeLineRegister ID_SignExt_EX(Clk, ID_signExtOut, EX_signExtOut, EXMemEn);
    PipeLineRegister ID_forwardMuxRSOut_EX(Clk, forwardMuxRSOut_ID, EX_forwardMuxRSOut_ID, EXMemEn);
    PipeLineRegister ID_forwardMuxRTOut_EX(Clk, forwardMuxRTOut_ID, EX_forwardMuxRTOut_ID, EXMemEn);
    PipeLineRegister ID_Instruction_EX(Clk, ID_Instruction, EX_Instruction, EXMemEn);
    PipeLineRegister ID_PCAddResult_EX(Clk, ID_PCAddResult, EX_PCAddResult, EXMemEn);
    PipeLineRegister #(1) ID_RegDstSel_EX(Clk, ID_RegDstSelOut, EX_RegDstSel, EXMemEn);
    PipeLineRegister #(1) ID_ALUSrcSel_EX(Clk, ID_ALUSrcSelOut, EX_ALUSrcSel, EXMemEn);
    PipeLineRegister #(4) ID_ALUOpSel_EX(Clk, ID_ALUOpSelOut, EX_ALUOpSel, EXMemEn);
    PipeLineRegister #(1) ID_JumpSel_EX(Clk, ID_JumpSelOut, EX_JumpSel, EXMemEn);
    PipeLineRegister #(1) ID_MemWriteSel_EX(Clk, ID_MemWriteSelOut, EX_MemWriteSel, EXMemEn);
    PipeLineRegister #(1) ID_MemReadSel_EX(Clk, ID_MemReadSelOut, EX_MemReadSel, EXMemEn);
    PipeLineRegister #(1) ID_MemToRegSel_EX(Clk, ID_MemToRegSelOut, EX_MemToRegSel, EXMemEn);
    PipeLineRegister #(1) ID_RegWriteSel_EX(Clk, ID_RegWriteSelOut, EX_RegWriteSel, EXMemEn);
    PipeLineRegister #(2) ID_AmtSel_EX(Clk, ID_AmtSelOut, EX_AmtSel, EXMemEn);
    PipeLineRegister #(1) ID_SaveRaSel_EX(Clk, ID_SaveRaSelOut, EX_SaveRaSel, EXMemEn);
    PipeLineRegister #(1) ID_RaDstSel_EX(Clk, ID_RaDstSelOut, EX_RaDstSel, EXMemEn);
    //////////////////////////Execute Stage//////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    //ALU32Bit(ALUControl, A, B, ALUResult, Shift, move, rotate);
    ALU32Bit alu(EX_ALUControlSel, forwardMuxRSOut_M, aluSrcOut, EX_ALUResult, EX_Instruction[10:6], EX_Move, EX_Instruction[21]);
    //ForwardingUnit(RSReg_ID, RTReg_ID, RSReg_EX, RTReg_EX, RTReg_M, RDReg_M, RDReg_WB, M_RegWrite, WB_RegWrite, MemRead_WB, MemWrite_M, MemWrite_EX, RS_ID, RT_ID, RS_M, RT_M, RS_WB, RT_WB, RS_ID_M, RT_ID_M, LwSwSel);
    ForwardingUnit forwarding(ID_Instruction[25:21], ID_Instruction[20:16], EX_Instruction[25:21], EX_Instruction[20:16], M_Instruction[20:16], M_regDstOut, WB_regDstOut, M_regWriteMuxOut, WB_regWriteMuxOut, WB_MemReadSel, M_MemWriteSel, EX_MemWriteSel, RS_ID_Sel, RT_ID_Sel, RS_M_Sel, RT_M_Sel, RS_WB_Sel, RT_WB_Sel, RS_ID_M_Sel, RT_ID_M_Sel, forwardLwSwSel);
    //Mux2to1(out, in0, in1, sel);
   
    //forwarding from the memory stage
    Mux2To1 forwardMuxRS_M(forwardMuxRSOut_M, forwardMuxRSOut_WB , M_ALUResult[31:0], RS_M_Sel);
    Mux2To1 forwardMuxRT_M(forwardMuxRTOut_M, forwardMuxRTOut_WB , M_ALUResult[31:0], RT_M_Sel);
   
   //forwarding fromt eh Write back Stage
    Mux2To1 forwardMuxRS_WB(forwardMuxRSOut_WB, EX_forwardMuxRSOut_ID, WriteData, RS_WB_Sel);
    Mux2To1 forwardMuxRT_WB(forwardMuxRTOut_WB, EX_forwardMuxRTOut_ID , WriteData, RT_WB_Sel);
    
    
    //regular muzes
    Mux2To1 aluSrcMux(aluSrcOut, forwardMuxRTOut_M, EX_signExtOut, EX_ALUSrcSel);
    
    Mux2To1 #(5) regDstMux(EX_regDstOut, EX_Instruction[20:16], EX_Instruction[15:11], EX_RegDstSel);
    Mux2To1 #(5) jalRaDst(EX_jalRaDst, EX_regDstOut, RA, EX_RaDstSel);
    Mux2To1 #(1) regWriteMux(EX_regWriteMuxOut, EX_movAndOut, ZERO, EX_RegWriteMuxSel);
    //And(A, B, Out);
    And movAnd(EX_RegWriteSel, EX_Move, EX_movAndOut);
    //ALUController(ALUOp, FunctionCode, ALUControl, HLDataSel, HWrite, LWrite, HLRead, HiSel, LoSel, AddSubSel, HLRegSel, Add, RegWriteMuxSel, JumpRa);
    ALUController aluController(EX_ALUOpSel, EX_Instruction[5:0], EX_ALUControlSel, EX_HLToRegSel, EX_HWriteSel, EX_LWriteSel, EX_HLReadSel, EX_HiSel, EX_LoSel, EX_AddMuxSel, EX_HiOrLoSel, EX_AddSel, EX_RegWriteMuxSel, EX_JumpRaSel, JR_Flush);
    Mux2To1 #(6) controllerNopMem(controllerNopMemOut, controllerInMem, 'b000000, controlNopSelMem);
    
    always @(*) begin

        controllerInMem[5] <= EX_regWriteMuxOut;
        controllerInMem[4] <= EX_MemWriteSel;
        controllerInMem[3] <= EX_MemReadSel;
        controllerInMem[2] <= EX_MemToRegSel;
        controllerInMem[1:0] <= EX_AmtSel;
        
    end
    
    always @(*) begin
    
        EX_MuxMemOut <= controllerNopMemOut[5];
        EX_MemWriteSelOut <= controllerNopMemOut[4]; 
        EX_MemReadSelOut <= controllerNopMemOut[3];
        EX_MemToRegSelOut <= controllerNopMemOut[2]; 
        EX_AmtSelOut <= controllerNopMemOut[1:0]; 
        
    end
    
    //////////////////////////Execute Stage//////////////////////////////////////////////////////////////////////////////////////////////
    //Execute/Memory Register(PipeLineRegister(Clk, in, out, Write))//
    PipeLineRegister #(5) EX_DstReg_M(Clk, EX_jalRaDst, M_regDstOut, Write);
    PipeLineRegister #(64) EX_AluResult_M(Clk, EX_ALUResult, M_ALUResult, Write);
    PipeLineRegister EX_forwardMuxRSOut_M(Clk, forwardMuxRSOut_WB, M_forwardMuxRSOut_WB, Write);
    PipeLineRegister EX_forwardMuxRTOut_M(Clk, forwardMuxRTOut_WB, M_forwardMuxRTOut_WB, Write);
    PipeLineRegister EX_PCAddResult_M(Clk, EX_PCAddResult, M_PCAddResult, Write);
    PipeLineRegister EX_Instruction_M(Clk, EX_Instruction, M_Instruction, Write);
    PipeLineRegister #(1) EX_MemWriteSel_M(Clk, EX_MemWriteSelOut, M_MemWriteSel, Write);
    PipeLineRegister #(1) EX_MemReadSel_M(Clk, EX_MemReadSelOut, M_MemReadSel, Write);
    PipeLineRegister #(1) EX_MemToRegSel_M(Clk, EX_MemToRegSelOut, M_MemToRegSel, Write);
    PipeLineRegister #(1) EX_RegWriteSel_M(Clk, EX_MuxMemOut, M_regWriteMuxOut, Write);
    PipeLineRegister #(2) EX_AmtSel_M(Clk, EX_AmtSelOut, M_AmtSel, Write);
    PipeLineRegister #(1) EX_HWriteSel_M(Clk, EX_HWriteSel, M_HWriteSel, Write);
    PipeLineRegister #(1) EX_LWriteSel_M(Clk, EX_LWriteSel, M_LWriteSel, Write);
    PipeLineRegister #(1) EX_HLReadSel_M(Clk, EX_HLReadSel, M_HLReadSel, Write);
    PipeLineRegister #(1) EX_HiSel_M(Clk, EX_HiSel, M_HiSel, Write);
    PipeLineRegister #(1) EX_LoSel_M(Clk, EX_LoSel, M_LoSel,Write);
    PipeLineRegister #(1) EX_AddMuxSel_M(Clk, EX_AddMuxSel, M_AddMuxSel,Write);
    PipeLineRegister #(1) EX_AddSel_M(Clk, EX_AddSel, M_AddSel, Write);
    PipeLineRegister #(1) EX_HLToRegSel_M(Clk, EX_HLToRegSel, M_HLToRegSel, Write);
    PipeLineRegister #(1) EX_SaveRaSel_M(Clk, EX_SaveRaSel, M_SaveRaSel,Write);
    PipeLineRegister #(1) EX_HiOrLoSel_M(Clk, EX_HiOrLoSel, M_HiOrLoSel, Write);
    //////////////////////////Memory Stage///////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    //DataMemory(Address, WriteData, Clk, MemWrite, MemRead, ReadData, Amt);
    DataMemory memory(M_ALUResult[31:0], forwardLwSwOut, Clk, M_MemWriteSel, M_MemReadSel, M_MemOut, M_AmtSel);
    //HILOReg(Clk, HIin, LOin, HLout, HWrite, LWrite, HLRead);
    HILOReg hiloRegFile(Clk, hiMuxOut, loMuxOut, M_HiLoReadData, M_HWriteSel, M_LWriteSel, M_HLReadSel);
    //Mux2to1(out, in0, in1, sel);
    Mux2To1 hiMux(hiMuxOut, addSubMuxOut[63:32], M_forwardMuxRSOut_WB, M_HiSel);
    Mux2To1 loMux(loMuxOut, addSubMuxOut[31:0], M_forwardMuxRSOut_WB, M_LoSel);
    Mux2To1 #(64) addSubMux(addSubMuxOut, M_ALUResult, AddSubOut, M_AddMuxSel);
    Mux2To1 forwardLwSw(forwardLwSwOut, M_forwardMuxRTOut_WB, WriteData, forwardLwSwSel);
    //AddSub64Bit(A, B, Out, Add);
    AddSub64Bit addSub(M_HiLoReadData, M_ALUResult, AddSubOut, M_AddSel);
    
    
    
    
    //////////////////////////Memory Stage///////////////////////////////////////////////////////////////////////////////////////////////
    //Memory/WriteBack Register(PipeLineRegister(Clk, in, out, Write))//
    PipeLineRegister #(5) M_DstReg_WB(Clk, M_regDstOut, WB_regDstOut, Write);
    PipeLineRegister M_AluResult_WB(Clk, M_ALUResult[31:0], WB_ALUResult, Write);
    PipeLineRegister #(64) M_HiLoReadData_WB(Clk, M_HiLoReadData, WB_HiLoReadData, Write);
    PipeLineRegister M_MemOut_WB(Clk, M_MemOut, WB_MemOut, Write);
    PipeLineRegister M_PCAddResult_WB(Clk, M_PCAddResult, WB_PCAddResult, Write);
    PipeLineRegister #(1) M_MemToRegSel_WB(Clk, M_MemToRegSel, WB_MemToRegSel, Write);
    PipeLineRegister #(1) M_RegWriteSel_WB(Clk, M_regWriteMuxOut, WB_regWriteMuxOut, Write);
    PipeLineRegister #(1) M_HLToRegSel_WB(Clk, M_HLToRegSel, WB_HLToRegSel, Write);
    PipeLineRegister #(1) M_SaveRaSel_WB(Clk, M_SaveRaSel, WB_SaveRaSel, Write);
    PipeLineRegister #(1) M_HiOrLoSel_WB(Clk, M_HiOrLoSel, WB_HiOrLoSel, Write);
    PipeLineRegister #(1) M_MemReadSel_WB(Clk, M_MemReadSel, WB_MemReadSel, Write);
    ////////////////////////WriteBack Stage//////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    //Mux2to1(out, in0, in1, sel);
    Mux2To1 memMux(memMuxOut, WB_ALUResult[31:0], WB_MemOut, WB_MemToRegSel);
    Mux2To1 hiOrLoMux(hiOrLoMuxOut, WB_HiLoReadData[31:0], WB_HiLoReadData[63:32], WB_HiOrLoSel);
    Mux2To1 hlToRegMux(hlToRegMuxOut, memMuxOut, hiOrLoMuxOut, WB_HLToRegSel);
    Mux2To1 saveRaMux(WriteData, hlToRegMuxOut, WB_PCAddResult, WB_SaveRaSel);
    
    
    
    
    
    
    ////////////////////////Write Back Stage/////////////////////////////////////////////////////////////////////////////////////////////
    
    
endmodule
