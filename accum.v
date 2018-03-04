module accum(
              input clk,
              input ena,
              input rst,
              input[7:0] data,
              output reg[7:0] accum);
  
  always@(posedge clk)
    begin
      if(rst)
        accum <= 8'b0000_0000;
      else
        if(ena)
          accum <= data;
    end
endmodule