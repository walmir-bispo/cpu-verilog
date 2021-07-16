module CPU (
    input wire clk,
    input wire reset
);

// Fios de controle
    wire PC_W;
    wire Mem_W;
    wire MDR_W;
    wire RAA_W;
    wire IR_W;
    wire RB_W;
    wire [2:0] ALUControl;
    wire Reg_AB_W;

// Fios de dados
    wire [31:0] PC_In;
    wire [31:0] PC_Out;
    wire [31:0] MuxIorD_Out;
    wire [31:0] MuxWriteMemSrc_Out;
    wire [31:0] Mem_Out;
    wire [31:0] MDR_Out;
    wire [31:0] RAA_Out;
    wire [5:0] Instr31_26;
    wire [4:0] Instr25_21;
    wire [4:0] Instr20_16;
    wire [15:0] Instr15_0;
    wire [4:0] MuxRegDst_Out;
    wire [31:0] MuxMemToReg_Out;
    wire [31:0] RegReadData1A;
    wire [31:0] RegReadData2B;
    wire [31:0] MuxALUSrcA_Out;
    wire [31:0] MuxALUSrcB_Out;
    wire [31:0] ALU_Out_Fio;
    wire Flag_Overflow;
    wire Flag_Negativo;
    wire Flag_Zero;
    wire Flag_Igual;
    wire Flag_Maior;
    wire Flag_Menor;
    wire [31:0] Reg_A_Out;
    wire [31:0] Reg_B_Out;



    Registrador PC(
        clk,
        reset,
        PC_W,
        PC_In,
        PC_Out
    );

    //intanciamento do muxIorD, fio de saida já registrado
    //intanciamento do MuxWriteMemSrc, fio de saida já registrado

    Memoria Mem (
        MuxIorD_Out,
        clk,
        Mem_W,
        MuxWriteMemSrc_Out,//valor a ser escrito
        Mem_Out 
    );


    Registrador MDR(  //MemoryDataRegister
        clk,
        reset,
        MDR_W,
        Mem_Out,
        MDR_Out
    );


    Registrador RAA(  //Registrador Auxiliar ADDM
        clk,
        reset,
        RAA_W,
        Mem_Out,
        RAA_Out
    );


    Instr_Reg IR(
        clk,
        reset,
        IR_W,
        Mem_out,
        Instr31_26, //OpCode
        Instr25_21, //RS
        Instr20_16, //RT
        Instr15_0   //Offset ou Imediato
    );

    //intanciamento do MuxRegDst, fio de saida já registrado
    //intanciamento do MuxMemToReg, fio de saida já registrado


    Banco_Reg BancoDeReg(
        clk,
        reset,
        RB_W,
        Instr25_21,
        Instr20_16,
        MuxRegDst_Out,
        MuxMemToReg_Out,
        RegReadData1A,
        RegReadData2B
    );
    // no nosso esquema a gente tinha os registradores auxiliares A e B, mas lembro que o prof falou que 
    // eles são invisíveis ao programador, então acho que não precisamos colocar eles


    Registrador Reg_A(
        clk,
        reset,
        Reg_AB_W,
        RegReadData1A,
        Reg_A_Out
    );

    Registrador Reg_B(
        clk,
        reset,
        Reg_AB_W,
        RegReadData2B,
        Reg_B_Out
    );

    //intanciamento do MuxALUSrcA, fio de saida já registrado
    //intanciamento do MuxALUSrcB, fio de saida já registrado

    ula32 ULA(
        MuxALUSrcA_Out,
        MuxALUSrcB_Out,
        ALUControl,
        ALU_Out_Fio,
        Flag_Overflow,
        Flag_Negativo,
        Flag_Zero,
        Flag_Igual,
        Flag_Maior,
        Flag_Menor
    );


    Registrador ALU_Out_Reg(
        clk,
        reset,
        ALU_Out_Reg_W,
        ALU_Out_Fio,
        ALU_Out_Reg_Out
    ); 

endmodule
