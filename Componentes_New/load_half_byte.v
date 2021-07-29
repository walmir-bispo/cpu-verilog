module load_half_byte (
    input wire   selector,
    input wire [31:0] data_1,
    output wire [31:0] data_out
);

    wire [31:0] byte_;
    wire [31:0] half_;

    assign byte_={24'd0,data_1[7:0]};
    assign half_={16'd0,data_1[15:0]};
 
    assign data_out = (selector) ? half_ : byte_;


endmodule