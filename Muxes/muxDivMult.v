module muxDivMult(
    input wire controlDivMult,
    input wire [31:0] LO,
    input wire [31:0] HI,
    output wire [31:0] Data_out
);
    assign Data_out = controlDivMult ? (LO):(HI);

endmodule