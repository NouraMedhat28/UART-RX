module EdgeBitCounter (
    input  wire       Enable,
    input  wire       ParityEn,
    input  wire       CLK,
    input  wire       RST,
    output reg  [3:0] BitCounter,
    output reg  [4:0] EdgeCounter
);
reg [3:0] NoOfBits;

//Number of bits to be counted
always @(*) begin
  if(ParityEn) begin
    NoOfBits = 4'b1010;
  end
  else begin
    NoOfBits = 4'b1001;
  end
end

//Counters Logic
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        EdgeCounter <= 'b0;
        BitCounter  <= 'b0;
    end
    else if (Enable) begin
        if (BitCounter != NoOfBits) begin
          if (EdgeCounter == 3'b111) begin
            EdgeCounter <= 'b0;
            BitCounter <= BitCounter + 1;
          end

          else begin
            EdgeCounter <= EdgeCounter + 1;
            BitCounter  <= BitCounter;
          end
        end

        else begin
          if (EdgeCounter == 3'b111) begin
            EdgeCounter <= 'b0;
            BitCounter <=  'b0;
          end

          else begin
            EdgeCounter <= EdgeCounter + 1;
            BitCounter  <= BitCounter;
          end
        end
    end
end

endmodule