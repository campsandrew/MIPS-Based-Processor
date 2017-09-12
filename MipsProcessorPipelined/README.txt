# Mips Based Processor

Name: Andrew Camps
Class: ECE 369A Project
Summary: This is a basic pipelined mips based processor that
implements some basic optimization features such as 
pipelining and forwarding of instructions.

There are 54 MIPS instructions implemented into this processor

INSTRUCTIONS:
add				addiu
addi			  sub
mul				mult
multu			  madd
madd			  msub
lw				sw
sb				lh
lb				sh
mthi			mtlo
mfhi			mflo
lui				bgez
beq				blez
bne				bgtz
bltz			  j
jr				jal
and				andi
or				nor
xor				andi
ori				xori
seh				sll
srl				sllv
srlv			slt
slri			movn
movz			rotrv
rotr			sra
srav			seb
sltiu			sltu

All of these instruction definitions can be found in a mips
instruction manualy 

