module mux_IorD(Data_1, Data_2, Data_3, seletor);
input wire [31:0] Data_0;
input wire [31:0] Data_1;
input wire [31:0] Data_2;
output wire [31:0] Data_out;
input wire [1:0] seletor;


wire [31:0] AUX;

assign AUX = (seletor[0]) ? Data_0 : Data_1;
assign Data_out = (seletor[1]) ?  Data_2 : AUX;


endmodule