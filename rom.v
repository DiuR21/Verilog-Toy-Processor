module rom( input rd,
            input ena,
            inout[12:0] addr,
            output[7:0] data);

  reg[7:0] memory[13'h1fff:0];
  assign data = ( rd && ena )? memory[addr] : 8'hzz;
  
endmodule          
