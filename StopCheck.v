module StopCheck(
    input  wire   CLK,
    input  wire   RST,
    input  wire   Enable,
    input  wire   SampledStop,
    output reg    StopError
);

always @(posedge CLK or negedge RST) begin
  if(!RST) begin
    StopError <= 'b0;
  end
  else if (Enable) begin
    if (SampledStop == 'b1) begin
      StopError <= 'b0;
    end
    else begin
      StopError <= 'b1;
    end
  end
end

endmodule