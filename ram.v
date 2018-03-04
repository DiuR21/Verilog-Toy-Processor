module ram( input[9:0] addr,
            input rd,
            input wr,
            input ena,
            inout[7:0] data);
            
  reg[7:0] ram[10'h3ff:0];
  assign data = ( rd && ena ) ? ram[addr] : 8'hzz;
  
  always@ (posedge wr)
  begin
    ram[addr] <=  data;
  end          
              
endmodule
