`timescale 1ns/1ns
module clk_gen(
                input clk,
                input rst,
                output reg fetch);
  
  always@ (posedge clk)
  begin
    if(rst)
      fetch <= 0;
  else
      fetch <= 1;
  end
endmodule

