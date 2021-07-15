module ShiftLeft26_28MaisPcIg32 (
    input wire [25:0] data_0,
    input wire [31:0] data_1_PC,
    output wire [31:0] data_out
);

wire data_0ShiftedLeft;
assign data_out={data_1_PC[31:28],data_0,1'b0,1'b0};
endmodule
