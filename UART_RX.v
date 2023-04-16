module UART_RX (
    input  wire         RX_IN,
    input  wire         CLK,
    input  wire         RST,
    input  wire         ParityEn,
    input  wire         ParityType,
    output wire [7:0]   PData,
    output wire         DataValid
);

wire        CounterEnableTop, StopCheckEnTop, StopErrorTop;
wire        SampledBitTop;
wire        StartCheckEnTop, StartErrorTop;
wire        ParityCheckEnTop, ParityErrorTop;
wire        DeserializerEnTop, OutDataTop;
wire [2:0]  EdgeCounterTop;
wire [3:0]  BitCounterTop;



FSM                      FSMTop
(.CLK                    (CLK),
 .RST                    (RST),
 .DataValid              (DataValid),
 .SData                  (RX_IN),
 .StartError             (StartErrorTop),
 .ParityError            (ParityErrorTop),
 .ParityEn               (ParityEn),
 .StopError              (StopErrorTop),
 .BitCounter             (BitCounterTop),
 .EdgeCounter            (EdgeCounterTop),
 .CounterEnable          (CounterEnableTop),
 .ParityCheckEn          (ParityCheckEnTop),
 .StartCheckEn           (StartCheckEnTop),
 .StopCheckEn            (StopCheckEnTop),
 .DeserializerEn         (DeserializerEnTop),
 .OutData                (OutDataTop)
);

ParityCheck              ParityCheckTop
(.CLK                    (CLK),
 .RST                    (RST),
 .Enable                 (ParityCheckEnTop),
 .ParityEn               (ParityEn),
 .Data                   (PData),
 .ParityType             (ParityType),
 .SampledParity          (SampledBitTop),
 .ParityError            (ParityErrorTop)
);

StopCheck                StopCheckTop
(.CLK                    (CLK),
 .RST                    (RST),
 .Enable                 (StopCheckEnTop),
 .SampledStop            (SampledBitTop),
 .StopError              (StopErrorTop)
);


Deserializer             DeserializerTop
(.CLK                    (CLK),
 .RST                    (RST),
 .SampledBit             (SampledBitTop),
 .Enable                 (DeserializerEnTop),
 .OutData                (OutDataTop),
 .PData                  (PData)
);

StartCheck               StartCheckTop
(.CLK                    (CLK),
 .RST                    (RST),
 .Enable                 (StartCheckEnTop),
 .SampledStart           (SampledBitTop),
 .StartError             (StartErrorTop)
);


OverSampling             OverSamplingTop
(.CLK                    (CLK),
 .RST                    (RST),
 .EdgeCounter            (EdgeCounterTop),
 .SData                  (RX_IN),
 .SampledBit             (SampledBitTop)
);




EdgeBitCounter           CounterTop
(.Enable                 (CounterEnableTop),
 .ParityEn               (ParityEn),
 .CLK                    (CLK),
 .RST                    (RST),
 .BitCounter             (BitCounterTop),
 .EdgeCounter            (EdgeCounterTop)
);

endmodule