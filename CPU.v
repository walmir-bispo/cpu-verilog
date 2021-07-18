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
    wire [1:0] regDST;
    wire HILO_W;
    wire ShiftIn;
    wire ShiftAmt;
    wire [1:0] EC_CTRL;
    wire [2:0] Shift;
    wire EPC_W;
    wire [1:0] CB;
    wire [2:0] ALUSrcB;
    wire BHControl;
    wire [1:0] IorD;
    wire WriteMemSrc;
    

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
    wire not_Flag_Igual;
    assign not_Flag_Igual = ~Flag_Igual;

    wire Flag_Maior;
    wire not_Flag_Maior;
    assign not_Flag_Maior = ~Flag_Maior;

    wire Flag_Menor;
    wire [31:0] Reg_A_Out;
    wire [31:0] Reg_B_Out;
    wire [31:0] LOMult;
    wire [31:0] HIMult;
    wire [31:0] MuxDivMultHI_Out;
    wire [31:0] HI_Out;
    wire [31:0] MuxDivMultLO_Out;
    wire [31:0] LO_Out;
    wire [31:0] signExtend_out;
    wire [31:0] shiftLeft32_out;
    wire [31:0] mux_shiftIn_Out;
    wire [4:0] mux_shiftAmt_Out;
    wire [31:0] RegDesloc_Out;
    wire [31:0] EPC_Out;
    wire [31:0] address_routine;
    wire [31:0] address_atual_pc;
    wire [25:0] AuxiliarDesvioIncond;
    assign AuxiliarDesvioIncond={Instr15_0,Instr20_16,Instr25_21};
    wire [31:0] ShiftLeft26_28MaisPcIg32_out;
    wire mux_branch_out;
    wire [31:0] storer_half_byte_Out;
    wire [31:0] load_half_byte_Out;
    wire [31:0] div_OutLO;
    wire [31:0] div_OutHI;
    wire divPor0;
    
    Registrador PC(
        clk,
        reset,
        PC_W,
        PC_In,
        PC_Out
    );

    
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

    mux_RegDst MUX_reg_DST(  
        regDST,
        Instr20_16,
        Instr15_0[15:11],
        MuxRegDst_Out
    ); 

    
    Mult Multiplicador(
        clk,
        reset,
        Reg_A_Out,
        Reg_B_Out,
        LOMult,
        HIMult
    );

    
    //intanciamento do MuxDivMultLO, fio de saida já registrado

    Registrador HI(
        clk,
        reset,
        HILO_W,
        MuxDivMultHI_Out,
        HI_Out
    );


    Registrador LO(
        clk,
        reset,
        HILO_W,
        MuxDivMultLO_Out,
        LO_Out
    );

    sign_extend signExtend(
        Instr15_0,
        signExtend_out
    );

    shiftLeft32 shift_left_2(
        signExtend_out, 
        shiftLeft32_out
    );

    mux_shiftIn MuxShiftIn(
        ShiftIn,
        Reg_A_Out,
        Reg_B_Out,
        signExtend_out, //imediato
        mux_shiftIn_Out;
    );

    mux_shiftAmt MuxShiftAmt(
        ShiftAmt,
        Reg_B_Out,
        Instr15_0,
        MDR_Out
        mux_shiftAmt_Out
    );


    RegDesloc RegDeDeslocamento(
        clk,
        reset,
        Shift, //indica qual shift realizar
        mux_shiftAmt_Out, //quantos shifts realizar
        mux_shiftIn_Out,
        RegDesloc_Out
    );

    exception_handler tratador_exception(
        EC_CTRL,
        PC_Out,
        address_routine,
        address_atual_pc
    );


    Registrador EPC(
        clk,
        reset,
        EPC_W,
        address_atual_pc,
        EPC_Out
    );

    ShiftLeft26_28MaisPcIg32 ShiftLeft26Para28MaisPcIg32(
        AuxiliarDesvioIncond,
        PC_Out,
        ShiftLeft26_28MaisPcIg32_out
    );

    mux_CB MUX_branch (
        CB,
        Flag_Igual, 
        not_Flag_Igual, 
        Flag_Maior,
        not_Flag_Maior,  
        mux_branch_out
    );

    mux_alu_src_b MUX_aluSrc_B(
        ALUSrcB,
        Reg_B_Out,
        signExtend_out,
        MDR_Out,
        shiftLeft32_out,
        MuxALUSrcB_Out
    );

    storer_half_byte storeByteHalf(
        BHControl,
        MDR_Out,
        Reg_B_Out,
        storer_half_byte_Out
    );


    load_half_byte LoadByteHalf(
        BHControl,
        MDR_Out,
        load_half_byte_Out
    );


    div divisor(
        Reg_A_Out,
        Reg_B_Out,
        reset,
        clk,
        div_OutLO,
        div_OutHI,
        divPor0
    );

    
   mux_div_mult_Hi muxDivMultHi(
       divOrMult,
       div_OutHI,
       HIMult,
       MuxDivMultHI_Out;
   );



    mux_div_mult_Lo muxDivMultLo(
       divOrMult,
       div_OutLO,
       LOMult,
       MuxDivMultLO_Out;
   );



    mux_IorD MuxIOrD(
      PC_Out,
      ALU_Out_Reg_Out,
      address_routine,// fiquei na duvida se o endereço da rotina tem que vir pra o PC
      MuxIorD_Out,
      IorD
    );



    mux_writememorysrc MuxWriteMem(
      WriteMemSrc,
      storer_half_byte_Out,
      Reg_B_Out,
      MuxWriteMemSrc_Out
    );



    mux_ALUSrca MuxALUSrcA(
        ALUSrcA,
        PC_Out,
        RAA_Out,
        Reg_A_Out,
        MuxALUSrcA_Out
    );






endmodule
