module StartCheck(
    input  wire   CLK,
    input  wire   RST,
    input  wire   Enable,
    input  wire   SampledStart,
    output reg    StartError
);

always @(posedge CLK or negedge RST) begin
  if(!RST) begin
    StartError <= 'b0;
  end
  else if (Enable) begin
    if (SampledStart == 'b1) begin
      StartError <= 'b1;
    end
    else begin
      StartError <= 'b0;
    end
  end
end

endmodule