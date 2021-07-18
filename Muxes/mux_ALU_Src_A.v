module mux_ALUSrca (
    input wire [1:0]    selector,
    input wire [31:0]  data_0,
    input wire [31:0]   data_1,
    input wire [31:0]   data_2,
    output wire [31:0] Data_out  
);
    wire [31:0] A1;
    wire [31:0] A2;
    assign A1 = (selector[0]) ? data_1 : data_0;
    assign A2 = (selector[0]) ? 32'd16 : data_2;
    assign Data_out = (selector[1]) A2 : A1;

endmodule