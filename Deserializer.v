module Deserializer (
    input  wire        CLK,
    input  wire        RST,
    input  wire        SampledBit,
    input  wire        Enable,
    input  wire        OutData,
    output reg  [7:0]  PData
);

reg [7:0]  IntPData;

always @(posedge CLK or negedge RST) begin
  if(!RST) begin
    PData <= 'b0;
    IntPData <= 'b0;
  end

  else if (OutData) begin
    PData = IntPData;
  end

  else if (Enable) begin
    IntPData <= {IntPData, SampledBit};
    PData <= PData;
  end
end

endmodule