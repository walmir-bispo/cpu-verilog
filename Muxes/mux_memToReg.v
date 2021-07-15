module mux_memToReg(
    input wire [31:0] Data_0, 
    input wire Data_1, // flag ula
    input wire [31:0] Data_2, // reg deslocamento
    input wire [31:0] Data_3, // HI
    input wire [31:0] Data_5, // LO
    input wire [31:0] Data_6, // memory data register
    input wire [31:0]Data_7, //aluout
    input wire [31:0] Data_8, //byte/halfword

    output wire Data_out,
    input wire [3:0] seletor
    );

    /*
    1000
    
    0111
    0110
    0101
    0100

    0011
    0010

    0001
    0000
*/
    assign Data_out = seletor[3] ? (Data_8) : 
    seletor[2] ? (seletor[1] ?(seletor[0] ? (Data_7):(Data_6)): seletor[0] ? (Data_5):(Data_4)) // todas as combinações se o seletor[2] = 1
    : seletor[1] ? (seletor[0] ? (Data3):(Data_2)):(seletor[0] ? (Data_1):(Data_0));

    endmodule

    