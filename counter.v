module counter(
                input clk,
                input load,
                input rst,
                input[12:0] ir_addr,
                output reg[12:0] pc_addr);
  
  always @(posedge clk or posedge rst)
    begin
      if(rst)
        pc_addr <= 13'b0_0000_0000_0000;
      else
        if(load)
          pc_addr <= ir_addr;
	    else
          pc_addr <= pc_addr + 1;
    end
endmodule