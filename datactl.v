module datactl(
                input data_ena,
                input [7:0] in,
                output [7:0] data);
  
  assign data = (data_ena) ? in : 8'bzzzz_zzzz;
endmodule
