module ParityCheck (
    input  wire       CLK,
    input  wire       RST,
    input  wire       Enable,
    input  wire       ParityEn,
    input  wire [7:0] Data,
    input  wire       ParityType,
    input  wire       SampledParity,
    output reg        ParityError
);

reg CalculatedParity;

always @(posedge CLK or negedge RST) begin
  if(!RST) begin
    ParityError <= 'b0;
    CalculatedParity <= 'b0;
  end

  else if (ParityEn & Enable) begin
  //Even
    if (ParityType =='b0) begin
      CalculatedParity <= ^Data;
      ParityError <= ~(CalculatedParity == SampledParity);
    end
  //Odd
    else begin
      CalculatedParity <= ~^Data;
      ParityError <= ~(CalculatedParity == SampledParity);
    end
  end
end  




endmodule