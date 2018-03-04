`timescale 1ns/1ns
module machinectl(
                    input clk,
                    input fetch,
                    input rst,
                    output reg ena); 
                     
always@(posedge clk)
  begin
    if(rst)
      begin
         ena <= 0;
     end
    else
      if(fetch)
        begin
          ena <= 1;
        end
    end
endmodule