module OverSampling (
    input  wire         CLK,
    input  wire         RST,
    input  wire [2:0]   EdgeCounter,
    input  wire         SData,
    output reg          SampledBit
);

reg [2:0] Samples;


always @(posedge CLK or negedge RST) begin
  if(!RST) begin
    SampledBit   <= 'b0;
    Samples      <= 'b0;
  end

  else if (EdgeCounter == 3'b011 || EdgeCounter == 3'b100 || EdgeCounter == 3'b101) begin
    Samples <= {Samples, SData};
  end

  else if(EdgeCounter == 3'b110) begin
    if(Samples[0] && Samples[1] || Samples[0] && Samples[2] || Samples[1] && Samples[2]) begin
      SampledBit =1'b1;
    end
    else begin
      SampledBit = 1'b0;
    end
  end
end


endmodule