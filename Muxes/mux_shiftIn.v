module mux_shiftIn (
    input wire [1:0] selector,
    input wire [31:0] data_0,
    input wire [31:0] data_1,
    input wire [31:0] data_2,
    input wire [31:0] data_3,
    output wire [31:0] data_out
);
    
    wire [31:0] A1;
    wire [31:0] A2;
    
    assign A1 = (selector[0]) ? data_1 : data_0;
    assign A2 = (selector[0]) ? data_3 : data_2; //considerando q selector[1]==1
    assign data_out = (selector[1]) ? A2 : A1;


endmodule