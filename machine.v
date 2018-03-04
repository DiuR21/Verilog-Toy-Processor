`timescale 1ns/1ns
module machine(
	input clk,
	input zero,
	input ena,
	input [2:0] opcode,
	output reg inc_pc,
	output reg load_acc,
	output reg load_pc,
	output reg rd,
	output reg wr,
	output reg load_ir,
	output reg datactl_ena,
	output reg halt,
	output reg alu_ena,
	output reg add_sel
);

  
  reg[2:0] state;
  reg[2:0] n_state;
  
  parameter HLT = 3'b000,
  			SKZ = 3'b001,
  			ADD = 3'b010,
  			ANDD = 3'b011,
  			XORR = 3'b100,
  			LDA = 3'b101,
  			STO = 3'b110,
  			JMP = 3'b111;


	always@(posedge clk)
	begin
		state <= n_state;
	end
	always@(posedge clk)
	begin
		if(ena != 1)
			begin
				state <= 3'b000;
				alu_ena <= 1'b0;
				add_sel <= 1'b0;
				{inc_pc,load_acc,load_pc,rd} <= 4'b0000;
				{wr,load_ir,datactl_ena,halt} <= 4'b0000;
			end
		else
			casex(state)
			3'b000:
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0001;
					{wr, load_ir, datactl_ena, halt} <= 4'b0100;
					alu_ena <= 1'b0;
					add_sel <= 1;
					n_state <= 3'b001;
				end
			
			3'b001:
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b1001;
					{wr, load_ir, datactl_ena, halt} <= 4'b0100;
					add_sel <= 1;
					alu_ena <= 1'b0;
					state <= 3'b010;
				end
		
			3'b010:
			begin
				{inc_pc, load_acc, load_pc, rd}  <= 4'b0000;
				{wr, load_ir, datactl_ena, halt} <= 4'b0000;
				alu_ena <= 1'b0;
				state <= 3'b011;
			end
		
			3'b011:
			begin
				if(opcode == HLT)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b1000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0001;
					alu_ena <= 1'b0;
				end
				else
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b1000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					alu_ena <= 1'b0;
				end
			state <= 3'b100;
			end
		
			3'b100:
			begin
				if(opcode == JMP)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0010;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					add_sel <= 1'b0;
					alu_ena <= 1'b0;
				end
				else if(opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0001;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					add_sel <= 1'b0;
					alu_ena <= 1'b0;
				end
				else if(opcode == STO)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0010;
					add_sel <= 1'b0;
					alu_ena <= 1'b0;
				end
				else
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					alu_ena <= 1'b0;
				end
				state <= 3'b101;
			end
			
			3'b101:	//operation
			begin
				if(opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0001;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					add_sel <= 1'b0;
					alu_ena <= 1'b1;
				end
				else if(opcode == SKZ && zero == 1)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b1000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					add_sel <= 1'b0;
					alu_ena <= 1'b1;
				end
				else if(opcode == JMP)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b1010;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					add_sel <= 1'b0;
					alu_ena <= 1'b1;
				end
				else if(opcode == STO)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0000;
					{wr, load_ir, datactl_ena, halt} <= 4'b1010;
					add_sel <= 1'b0;
					alu_ena <= 1'b1;
				end
				else
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					alu_ena <= 1'b1;
				end
				state <= 3'b110;
			end

			3'b110:
			begin
				if(opcode == STO)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0010;
					add_sel <= 1'b0;
					alu_ena <= 1'b0;
				end
				else if(opcode == ADD || opcode == ANDD || opcode == XORR || opcode == LDA)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0101;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					add_sel <= 1'b0;
					alu_ena <= 1'b0;
				end
				else
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					alu_ena <= 1'b0;
				end
				state <= 3'b111;
			end

			3'b111:
			begin
				if(opcode == SKZ && zero == 1)
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b1000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					alu_ena <= 1'b0;
				end
				else
				begin
					{inc_pc, load_acc, load_pc, rd}  <= 4'b0000;
					{wr, load_ir, datactl_ena, halt} <= 4'b0000;
					alu_ena <= 1'b0;
				end
				state <= 3'b000;
			end
			default:
			begin
				{inc_pc, load_acc, load_pc, rd}  <= 4'b0000;
				{wr, load_ir, datactl_ena, halt} <= 4'b0000;
				alu_ena <= 1'b0;
			end
		endcase
		end

endmodule