module squaregen
  #(parameter clk_freq_hz = 100_000_000)
   (input clk,
    input [31:0] period,
    output reg pps_o = 1'b0);

   ////////////////////////////////////////

   reg [63:0] percnt = 0;
   always @(posedge clk) begin
      percnt <= percnt+1;
   end

   ////////////////////////////////////////

   reg [31:0] inner_count = 0;

   always @(posedge clk) begin
      inner_count <= (inner_count > period)
                   ? 0
                   : inner_count + 1;
   end

   ////////////////////////////////////////

   always @(posedge clk) begin
      if (inner_count == period) begin
	       pps_o <= !pps_o;
       end
   end

endmodule
