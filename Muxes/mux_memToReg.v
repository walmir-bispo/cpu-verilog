module mux_memToReg(
    input wire [2:0] seletor,
    input wire [31:0] Data_0, 
    input wire Data_1, // flag ula
    input wire [31:0] Data_2, // reg deslocamento
    input wire [31:0] Data_3, // HI
    input wire [31:0] Data_5, // memory data register
    input wire [31:0]Data_6, //aluout
    input wire [31:0] Data_7, //byte/halfword
    output wire [31:0] Data_out
    );

    assign Data_out = seletor[2] ? (seletor[1] ? (seletor[0] ? (Data_7):(Data_6)): seletor[0] ? (Data_5):(9'd227)) :
    (seletor[1] ? (seletor[0] ? (Data_3):(Data_2)):(seletor[0] ? (Data_1):(Data_0)));

    endmodule

    