`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Andrew Camps
// Module - InstructionMemory.v
// Description - 32-Bit wide instruction memory.
//
// INPUT:-
// Address: 32-Bit address input port.
//
// OUTPUT:-
// Instruction: 32-Bit output port.
//
// FUNCTIONALITY:-
// Similar to the DataMemory, this module should also be byte-addressed
// (i.e., ignore bits 0 and 1 of 'Address'). All of the instructions will be 
// hard-coded into the instruction memory, so there is no need to write to the 
// InstructionMemory.  The contents of the InstructionMemory is the machine 
// language program to be run on your MIPS processor.
//
//
//we will store the machine code for a code written in C later. for now initialize 
//each entry to be its index * 4 (memory[i] = i * 4;)
//all you need to do is give an address as input and read the contents of the 
//address on your output port. 
// 
//Using a 32bit address you will index into the memory, output the contents of that specific 
//address. for data memory we are using 1K word of storage space. for the instruction memory 
//you may assume smaller size for practical purpose. you can use 128 words as the size and 
//hardcode the values.  in this case you need 7 bits to index into the memory. 
//
//be careful with the least two significant bits of the 32bit address. those help us index 
//into one of the 4 bytes in a word. therefore you will need to use bit [8-2] of the input address. 


////////////////////////////////////////////////////////////////////////////////

module InstructionMemory(Address, Instruction); 

    input [31:0] Address;        // Input Address 

    output reg [31:0] Instruction;    // Instruction at memory location Address
    

    reg [31:0] memory [0:256];      //2d array storing 32 bit instructions to be output by the IFU
    
    
    
    integer i;                      //loop integer
        
    initial begin                               //for evaluation purposes this initializes the "instructions" for use with testing
    
    	//$readmemh ("Instruction_memory.txt", memory);
    	
    	memory[0] = 32'b00100011101111011111111111111100;	//	main:		addi	$sp, $sp, -4
        memory[1] = 32'b10101111101111110000000000000000;    //            sw    $ra, 0($sp)
        memory[2] = 32'b00110100000001000000000000000000;    //            ori    $a0, $zero, 0
        memory[3] = 32'b00110100000001010000000000010000;    //            ori    $a1, $zero, 16
        memory[4] = 32'b00110100000001100000000001010000;    //            ori    $a2, $zero, 16400
        //memory[4] = 32'b00110100000001100000000001010000;    //            ori    $a2, $zero, 80
        memory[5] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[6] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[7] = 32'b00110100000001000000010010110000;    //            ori    $a0, $zero, 1200
        memory[8] = 32'b00110100000001010000010011000000;    //            ori    $a1, $zero, 1216
        memory[9] = 32'b00110100000001100000100011000000;    //            ori    $a2, $zero, 2240
        memory[10] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[11] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[12] = 32'b00110100000001000000100101000000;    //            ori    $a0, $zero, 2368
        memory[13] = 32'b00110100000001010000100101010000;    //            ori    $a1, $zero, 2384
        memory[14] = 32'b00110100000001100000110101010000;    //            ori    $a2, $zero, 3408
        memory[15] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[16] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[17] = 32'b00110100000001000000110111010000;    //            ori    $a0, $zero, 3536
        memory[18] = 32'b00110100000001010000110111100000;    //            ori    $a1, $zero, 3552
        memory[19] = 32'b00110100000001100001000111100000;    //            ori    $a2, $zero, 4576
        memory[20] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[21] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[22] = 32'b00110100000001000001001000100000;    //            ori    $a0, $zero, 4640
        memory[23] = 32'b00110100000001010001001000110000;    //            ori    $a1, $zero, 4656
        memory[24] = 32'b00110100000001100010001000110000;    //            ori    $a2, $zero, 8752
        memory[25] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[26] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[27] = 32'b00110100000001000010010000110000;    //            ori    $a0, $zero, 9264
        memory[28] = 32'b00110100000001010010010001000000;    //            ori    $a1, $zero, 9280
        memory[29] = 32'b00110100000001100011010001000000;    //            ori    $a2, $zero, 13376
        memory[30] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[31] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[32] = 32'b00110100000001000011010010000000;    //            ori    $a0, $zero, 13440
        memory[33] = 32'b00110100000001010011010010010000;    //            ori    $a1, $zero, 13456
        memory[34] = 32'b00110100000001100100010010010000;    //            ori    $a2, $zero, 17552
        memory[35] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[36] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[37] = 32'b00110100000001000100010100010000;    //            ori    $a0, $zero, 17680
        memory[38] = 32'b00110100000001010100010100100000;    //            ori    $a1, $zero, 17696
        memory[39] = 32'b00110100000001100100100100100000;    //            ori    $a2, $zero, 18720
        memory[40] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[41] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[42] = 32'b00110100000001000100100110100000;    //            ori    $a0, $zero, 18848
        memory[43] = 32'b00110100000001010100100110110000;    //            ori    $a1, $zero, 18864
        memory[44] = 32'b00110100000001100100110110110000;    //            ori    $a2, $zero, 19888
        memory[45] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[46] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[47] = 32'b00110100000001000100110111110000;    //            ori    $a0, $zero, 19952
        memory[48] = 32'b00110100000001010100111000000000;    //            ori    $a1, $zero, 19968
        memory[49] = 32'b00110100000001100101001000000000;    //            ori    $a2, $zero, 20992
        memory[50] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[51] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[52] = 32'b00110100000001000101001100000000;    //            ori    $a0, $zero, 21248
        memory[53] = 32'b00110100000001010101001100010000;    //            ori    $a1, $zero, 21264
        memory[54] = 32'b00110100000001100110001100010000;    //            ori    $a2, $zero, 25360
        memory[55] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[56] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[57] = 32'b00110100000001000110011100010000;    //            ori    $a0, $zero, 26384
        memory[58] = 32'b00110100000001010110011100100000;    //            ori    $a1, $zero, 26400
        memory[59] = 32'b00110100000001100110101100100000;    //            ori    $a2, $zero, 27424
        memory[60] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[61] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[62] = 32'b00110100000001000110101101100000;    //            ori    $a0, $zero, 27488
        memory[63] = 32'b00110100000001010110101101110000;    //            ori    $a1, $zero, 27504
        memory[64] = 32'b00110100000001100111101101110000;    //            ori    $a2, $zero, 31600
        memory[65] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[66] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[67] = 32'b00110100000001000111101110110000;    //            ori    $a0, $zero, 31664
        memory[68] = 32'b00110100000001010111101111000000;    //            ori    $a1, $zero, 31680
        memory[69] = 32'b00110100000001100111110000000000;    //            ori    $a2, $zero, 31744
        memory[70] = 32'b00001100000000000000000001011011;    //            jal    vbsme
        memory[71] = 32'b00001100000000000000000001001011;    //            jal    print_result
        memory[72] = 32'b10001111101111110000000000000000;    //            lw    $ra, 0($sp)
        memory[73] = 32'b00100011101111010000000000000100;    //            addi    $sp, $sp, 4
        memory[74] = 32'b00000011111000000000000000001000;    //            jr    $ra
        memory[75] = 32'b00000000010000000010000000100000;    //    print_result:    add    $a0, $v0, $zero
        memory[76] = 32'b00110100000000100000000000000001;    //            ori    $v0, $zero, 1
        memory[77] = 32'b00000000000000000000000000000000;    //            nop
        memory[78] = 32'b00110100000001000111110001000000;    //            ori    $a0, $zero, 31808
        memory[79] = 32'b00110100000000100000000000000100;    //            ori    $v0, $zero, 4
        memory[80] = 32'b00000000000000000000000000000000;    //            nop
        memory[81] = 32'b00000000011000000010000000100000;    //            add    $a0, $v1, $zero
        memory[82] = 32'b00110100000000100000000000000001;    //            ori    $v0, $zero, 1
        memory[83] = 32'b00000000000000000000000000000000;    //            nop
        memory[84] = 32'b00110100000001000111110001000000;    //            ori    $a0, $zero, 31808
        memory[85] = 32'b00110100000000100000000000000100;    //            ori    $v0, $zero, 4
        memory[86] = 32'b00000000000000000000000000000000;    //            nop
        memory[87] = 32'b00110100000001000111110001000000;    //            ori    $a0, $zero, 31808
        memory[88] = 32'b00110100000000100000000000000100;    //            ori    $v0, $zero, 4
        memory[89] = 32'b00000000000000000000000000000000;    //            nop
        memory[90] = 32'b00000011111000000000000000001000;    //            jr    $ra
        memory[91] = 32'b00110100000000100000000000000000;    //    vbsme:        ori    $v0, $zero, 0
        memory[92] = 32'b00110100000000110000000000000000;    //            ori    $v1, $zero, 0
        memory[93] = 32'b10001100100100000000000000000000;    //            lw    $s0, 0($a0)
        memory[94] = 32'b10001100100100010000000000000100;    //            lw    $s1, 4($a0)
        memory[95] = 32'b10001100100100100000000000001000;    //            lw    $s2, 8($a0)
        memory[96] = 32'b10001100100100110000000000001100;    //            lw    $s3, 12($a0)
        memory[97] = 32'b00000000000000001010000000100000;    //            add    $s4, $zero, $zero
        memory[98] = 32'b00000000000000001010100000100000;    //            add    $s5, $zero, $zero
        memory[99] = 32'b00000010000100101011000000100010;    //            sub    $s6, $s0, $s2
        memory[100] = 32'b00000010001100111011100000100010;    //            sub    $s7, $s1, $s3
        memory[101] = 32'b00100000000110010000000000000001;    //            addi    $t9, $zero, 1
        memory[102] = 32'b00100000000110000111110100000000;    //            addi    $t8, $0, 32000
        memory[103] = 32'b00000000110000000101000000100000;    //            add    $t2, $a2, $0
        memory[104] = 32'b01110010010100111111000000000010;    //            mul    $fp, $s2, $s3
        memory[105] = 32'b00000000000111101111000010000000;    //            sll    $fp, $fp, 2
        memory[106] = 32'b00000011110010101111000000100000;    //            add    $fp, $fp, $t2
        memory[107] = 32'b00000000000100010111000010000000;    //    SAD:        sll    $t6, $s1, 2
        memory[108] = 32'b01110001110101000111100000000010;    //            mul    $t7, $t6, $s4
        memory[109] = 32'b00000000000101010111000010000000;    //            sll    $t6, $s5, 2
        memory[110] = 32'b00000001111011100111000000100000;    //            add    $t6, $t7, $t6
        memory[111] = 32'b00000000101011100100100000100000;    //            add    $t1, $a1, $t6
        memory[112] = 32'b00000000000000000100000000100000;    //            add    $t0, $0, $0
        memory[113] = 32'b00110100000011000000000000000000;    //            ori    $t4, $zero, 0
        memory[114] = 32'b00000000110000000101000000100000;    //            add    $t2, $a2, $0
        memory[115] = 32'b10001101001011100000000000000000;    //    loop:        lw    $t6, 0($t1)
        memory[116] = 32'b10001101010011110000000000000000;    //            lw    $t7, 0($t2)
        memory[117] = 32'b00100001001010010000000000000100;    //            addi    $t1, $t1, 4
        memory[118] = 32'b00100001000010000000000000000001;    //            addi    $t0, $t0, 1
        memory[119] = 32'b00000001110011110111000000100010;    //            sub    $t6, $t6, $t7
        memory[120] = 32'b00000000000011100111111111000011;    //            sra    $t7, $t6, 31
        memory[121] = 32'b00000001110011110111000000100110;    //            xor    $t6, $t6, $t7
        memory[122] = 32'b00000001110011110111000000100010;    //            sub    $t6, $t6, $t7
        memory[123] = 32'b00000001100011100110000000100000;    //            add    $t4, $t4, $t6
        memory[124] = 32'b00010101000100110000000000000101;    //            bne    $t0, $s3, change
        memory[125] = 32'b00000000000100110100000010000000;    //            sll    $t0, $s3, 2
        memory[126] = 32'b00000001001010000100100000100010;    //            sub    $t1, $t1, $t0
        memory[127] = 32'b00000000000100010100000010000000;    //            sll    $t0, $s1, 2
        memory[128] = 32'b00000001001010000100100000100000;    //            add    $t1, $t1, $t0
        memory[129] = 32'b00000000000000000100000000100000;    //            add    $t0, $0, $0
        memory[130] = 32'b00100001010010100000000000000100;    //    change:        addi    $t2, $t2, 4
        memory[131] = 32'b00010101010111101111111111101111;    //            bne    $t2, $fp, loop
        memory[132] = 32'b00000011000011000100000000101010;    //            slt    $t0, $t8, $t4
        memory[133] = 32'b00010101000000000000000000000011;    //            bne    $t0, $0, moveSAD
        memory[134] = 32'b00100001100110000000000000000000;    //            addi    $t8, $t4, 0
        memory[135] = 32'b00000000000101010101100000100000;    //            add    $t3, $0, $s5
        memory[136] = 32'b00000000000101000110100000100000;    //            add    $t5, $0, $s4
        memory[137] = 32'b00010010100101100000000000011100;    //    moveSAD:    beq    $s4, $s6, maxrow
        memory[138] = 32'b00010010101101110000000000100000;    //            beq    $s5, $s7, maxcol
        memory[139] = 32'b00010010100000000000000000001000;    //            beq    $s4, $zero, row0
        memory[140] = 32'b00010010101000000000000000010000;    //            beq    $s5, $zero, col0
        memory[141] = 32'b00010011001000000000000000000011;    //            beq    $t9, $zero, down
        memory[142] = 32'b00100010101101010000000000000001;    //    up:        addi    $s5, $s5, 1
        memory[143] = 32'b00100010100101001111111111111111;    //            addi    $s4, $s4, -1
        memory[144] = 32'b00001000000000000000000001101011;    //            j    SAD
        memory[145] = 32'b00100010101101011111111111111111;    //    down:        addi    $s5, $s5, -1
        memory[146] = 32'b00100010100101000000000000000001;    //            addi    $s4, $s4, 1
        memory[147] = 32'b00001000000000000000000001101011;    //            j    SAD
        memory[148] = 32'b00010010101101110000000000000100;    //    row0:        beq    $s5, $s7, minrowmaxcol
        memory[149] = 32'b00010011001000001111111111111011;    //            beq    $t9, $zero, down
        memory[150] = 32'b00100010101101010000000000000001;    //            addi    $s5, $s5, 1
        memory[151] = 32'b00000000000000001100100000100000;    //            add    $t9, $zero, $zero
        memory[152] = 32'b00001000000000000000000001101011;    //            j    SAD
        memory[153] = 32'b00010011001000001111111111110111;    //    minrowmaxcol:    beq    $t9, $zero, down
        memory[154] = 32'b00000000000000001100100000100000;    //            add    $t9, $zero, $zero
        memory[155] = 32'b00100010100101000000000000000001;    //            addi    $s4, $s4, 1
        memory[156] = 32'b00001000000000000000000001101011;    //            j    SAD
        memory[157] = 32'b00010010100101100000000000000100;    //    col0:        beq    $s4, $s6, mincolmaxrow
        memory[158] = 32'b00010111001000001111111111101111;    //            bne    $t9, $zero, up
        memory[159] = 32'b00100010100101000000000000000001;    //            addi    $s4, $s4, 1
        memory[160] = 32'b00100011001110010000000000000001;    //            addi    $t9, $t9, 1
        memory[161] = 32'b00001000000000000000000001101011;    //            j    SAD
        memory[162] = 32'b00010111001000001111111111101011;    //    mincolmaxrow:    bne    $t9, $zero, up
        memory[163] = 32'b00100010101101010000000000000001;    //            addi    $s5, $s5, 1
        memory[164] = 32'b00100011001110010000000000000001;    //            addi    $t9, $t9, 1
        memory[165] = 32'b00001000000000000000000001101011;    //            j    SAD
        memory[166] = 32'b00010010101101110000000000001000;    //    maxrow:        beq    $s5, $s7, exit
        memory[167] = 32'b00010111001000001111111111100110;    //            bne    $t9, $zero, up
        memory[168] = 32'b00100010101101010000000000000001;    //            addi    $s5, $s5, 1
        memory[169] = 32'b00100011001110010000000000000001;    //            addi    $t9, $t9, 1
        memory[170] = 32'b00001000000000000000000001101011;    //            j    SAD
        memory[171] = 32'b00010011001000001111111111100101;    //    maxcol:        beq    $t9, $zero, down
        memory[172] = 32'b00100010100101000000000000000001;    //            addi    $s4, $s4, 1
        memory[173] = 32'b00000000000000001100100000100000;    //            add    $t9, $zero, $zero
        memory[174] = 32'b00001000000000000000000001101011;    //            j    SAD
        memory[175] = 32'b00000000000011010001000000100000;    //    exit:        add    $v0, $0, $t5
        memory[176] = 32'b00000000000010110001100000100000;    //            add    $v1, $0, $t3
        //memory[177] = 32'b00000011111000000000000000001000;    //            jr    $ra
        memory[177] = 32'b00000000000000000000000000000000;    //            nop
        
        
    end
    
    always @(*) begin                         //outputs the instruction found at Address whenever Address changes
    
            Instruction <= memory[Address[9:2]];
    
    end
    
    
    
endmodule
