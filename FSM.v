module FSM (
    input  wire        CLK,
    input  wire        RST,
    input  wire        SData,
    input  wire        StartError,
    input  wire        ParityError,
    input  wire        ParityEn,
    input  wire        StopError,
    input  wire  [3:0] BitCounter,
    input  wire  [2:0] EdgeCounter,
    output reg         CounterEnable,
    output reg         ParityCheckEn,
    output reg         StartCheckEn,
    output reg         StopCheckEn,
    output reg         DeserializerEn,
    output reg         DataValid,
    output reg         OutData
);

reg [2:0]  PresentState, NextState;

localparam IDLE   = 3'b000,
           Start  = 3'b001,
           Data   = 3'b011,
           Parity = 3'b111,
           Stop   = 3'b101;

//State transition (Sequential Always)
always @(posedge CLK or negedge RST) begin
  if(!RST) begin
    PresentState  <= IDLE;
    CounterEnable <= 1'b0;
    ParityCheckEn <= 1'b0;
    StartCheckEn  <= 1'b0;
    StopCheckEn   <= 1'b0;
    DeserializerEn<= 1'b0;
    DataValid     <= 1'b0;
    OutData       <= 1'b0;
  end
  else begin
    PresentState <= NextState;
  end
end

//Next state logic and output logic (Comb always)
always @(*) begin
    CounterEnable = 1'b0;
    ParityCheckEn = 1'b0;
    StartCheckEn  = 1'b0;
    StopCheckEn   = 1'b0;
    DeserializerEn= 1'b0;
    OutData       = 1'b0;
  case (PresentState)
  IDLE : begin
    if (SData == 1'b0) begin
      NextState = Start;
      CounterEnable = 1'b1;
    end
    else begin
      NextState = IDLE;
      CounterEnable = 1'b0;
    end
  end 

  Start : begin
  if(EdgeCounter == 3'b111) begin
      StartCheckEn = 1'b1;
      CounterEnable = 1'b1;
    end
    else begin
        StartCheckEn = 1'b0;
      end
    if(EdgeCounter == 3'b111 && BitCounter == 4'b0000) begin
      NextState = Data;
    end
    else begin
      NextState = Start;
      CounterEnable = 1'b1;
    end
    end

    Data : begin
    DeserializerEn = (EdgeCounter == 3'b111);
    if(EdgeCounter == 3'b111 && BitCounter == 4'b1000 && ParityEn) begin
        NextState = Parity;
        CounterEnable = 1'b1;
    end
    else if (EdgeCounter == 3'b111 && BitCounter == 4'b1000 && !ParityEn) begin
            NextState = Stop;
            CounterEnable = 1'b1;
    end
    else begin
      NextState = Data;
      CounterEnable = 1'b1;
    end
  end 


  Parity : begin
  OutData = 1'b1;
  if(EdgeCounter == 3'b111) begin
      ParityCheckEn = 1'b1;
      CounterEnable = 1'b1;
    end
    else begin
        ParityCheckEn = 1'b0;
        CounterEnable = 1'b1;
      end
    if(EdgeCounter == 3'b111 && BitCounter == 4'b1001) begin
      NextState = Stop;
      CounterEnable = 1'b1;
    end
    else begin
      NextState = Parity;
      CounterEnable = 1'b1;
    end
    end

    Stop : begin
  if(EdgeCounter == 3'b111) begin
      StopCheckEn = 1'b1;
      CounterEnable = 1'b1;
    end
    else begin
        StopCheckEn = 1'b0;
        CounterEnable = 1'b1;
      end
    if(EdgeCounter == 3'b111 && BitCounter == 4'b1010) begin
    if(ParityEn) begin
      DataValid = ~(StopError || StartError || ParityError);
        end
      else begin
      DataValid = ~(StopError || StartError);
       end
      NextState = IDLE;
      CounterEnable = 1'b1;
    end
    else begin
      NextState = Stop;
      CounterEnable = 1'b1;
    end
    end

    default : begin
      NextState = IDLE;
    end
endcase
end
endmodule