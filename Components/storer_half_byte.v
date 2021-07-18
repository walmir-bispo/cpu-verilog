module storer_half_byte (
    input wire   selector,
    input wire [31:0] data_1,
    input wire [31:0] data_2,
    output wire [31:0] data_out
);

    wire [31:0] byte_;
    wire [31:0] half_;

    assign byte_={data_1[31:8],data_2[7:0]};
    assign half_={data_1[31:16],data_2[15:0]};
 
    assign data_out = (selector) ? half_ : byte_;

	 

endmodule