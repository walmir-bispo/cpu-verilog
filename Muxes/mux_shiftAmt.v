module mux_shiftAmt (
    input wire [1:0] selector,
    input wire [31:0] data_0, //reg b
    input wire [15:0] data_1, //intrucao shamt
    input wire [31:0] data_2, //memory data registee
    output wire [4:0] data_out
);
    
    wire [31:0] A1;
    wire [31:0] A2;
    
    assign A1 = (selector[0]) ? data_1[10:6] : data_0[4:0];
    assign A2 = (selector[0]) ? 5'd16 : data_2[4:0]; //considerando q selector[1]==1
    assign data_out = (selector[1]) ? A2 : A1;


endmodule