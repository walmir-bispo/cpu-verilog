module UnidadeDeControle (
    //Inputs
    input wire clk,
    input wire reset,
    input wire [5:0] funct,// E a parte[5:0] da Instr15_0
    //      exceptions
    input wire divPor0,
    input wire [5:0] OPCode, //Instr31_26
    input wire Flag_Overflow,
    //Outputs
    //      writes
    output wire PC_W,
    output wire Mem_W,
    output wire MDR_W,
    output wire RAA_W,
    output wire IR_W,
    output wire RB_W,
    output wire Reg_AB_W,
    output wire EPC_W,
    output wire HILO_W,
    output wire ALU_Out_Reg_W,
    //      muxsControl
    output wire controlDivMult,
    output wire WriteMemSrc,
    output wire PCWriteCond,
    output wire ShiftIn,
    output wire ShiftAmt,
    output wire [1:0] EC_CTRL,
    output wire [1:0] regDST,
    output wire [1:0] CB,
    output wire [1:0] IorD,
    output wire [1:0] ALUSrcA,
    output wire [2:0] ALUSrcB,
    output wire [2:0] PCSource,
    output wire [2:0] memToReg,
    output wire [2:0] Shift,
    //      Control de blocos
    output wire BHControl,
    output wire [2:0] UlaFunct,
    output wire [1:0] EC //ExceptionControl
);


reg [6:0] estado_atual;
reg [4:0] Counter;
// Parametros para Estados
parameter st_reset =          6'd0;
parameter st_Busca =          6'd1; //busca 1 e 2
parameter st_LoadsAndStores = 6'd2;
parameter st_Loads =          6'd3;
parameter st_LoadByte =       6'd4;
parameter st_LoadHalf =       6'd5; 
parameter st_LoadWord =       6'd6;
parameter st_StoreWord =      6'd7;
//parameter st_StoresBH =       6'd8; //abolido, pois adicionaria mais um ciclo sem necessidade
parameter st_StoreByte =      6'd9;
parameter st_StoreHalf =      6'd10;
parameter st_LogAri_TipoR =   6'd11; //st_LogAri_TipoR_1 e 2
parameter st_Overflow =       6'd12; //Overflow 1 e 2
parameter st_addImediato =    6'd13; //st_addImediato_1 e 2
parameter st_menorQ =         6'd14; //st_menorQ_1 e 2
parameter st_SLT       =       6'd8;
parameter st_Jump =           6'd15;
parameter st_JAL =            6'd16;
parameter st_Div =            6'd17;
parameter st_DivException =  6'd18; //st_DivException_1 e 2
parameter st_Mult =           6'd19; //32 ciclos
parameter st_ReadLO =         6'd20;
parameter st_ReadHI =         6'd21;
parameter st_JumpReg =        6'd22;
parameter st_RTE =            6'd23;
parameter st_RT_Left_shamt =  6'd24;
parameter st_RS_Left_RT =     6'd25;
parameter st_RT_RightA_Shamt =6'd26;
parameter st_RS_RightA_RT =   6'd27;
parameter st_RT_Right_Shamt = 6'd28;
parameter st_BEQ =            6'd29;
parameter st_BNE =            6'd30;
parameter st_BGT =            6'd31;
parameter st_BLE =            6'd32;
parameter st_ADDM =           6'd33; //aDD 1,2 e 3
parameter st_SLLM =           6'd34; //SLLM 1,2,3 e 4
parameter st_LUI =            6'd35; //LUI 1 e 2
parameter st_ExceptionOP =    6'd36; //ExceptionOP 1 e 2

//Parametros para OPCodes
parameter R_ALL=6'd0;
parameter I_ADDI=6'd8;
parameter I_ADDIU=6'd9;
parameter I_BEQ=6'd4;
parameter I_BNE=6'd5;
parameter I_BLE=6'd6;
parameter I_BGT=6'd7;
parameter I_SLLM=6'd1;
parameter I_LB=6'd32;
parameter I_LH=6'd33;
parameter I_LUI=6'd15;
parameter I_LW=6'd35;
parameter I_SB=6'd40;
parameter I_SH=6'd41;
parameter I_SLTI=6'd10;
parameter I_SW=6'd43;
parameter J_J=6'd2;
parameter J_JAL=6'd3;

//Parametros para campo Func (Tipo R)
parameter R_ADD=6'd32;
parameter R_AND=6'd36;
parameter R_DIV=6'd26;
parameter R_MULT=6'd24;
parameter R_JR=6'd8;
parameter R_MFHI=6'd16;
parameter R_MFLO=6'd18;
parameter R_SLL=6'd0;
parameter R_SLLV=6'd4;
parameter R_SLT=6'd42;
parameter R_SRA=6'd3;
parameter R_SRAV=6'd7;
parameter R_SRL=6'd2;
parameter R_SUB=6'd34;
parameter R_BREAK=6'd13;
parameter R_RTE=6'd19;
parameter R_ADDM=6'd5;

 initial begin
    estado_atual = st_reset;
 end
 
 //Excecao de OPCode inexistente deve ser tratada no Case, vai ser ultimo case, caso nenhuma das condicoes anteriores tenha entrado

always @(posedge clk) begin
    if (reset==1'd1) begin
        
        //writes
        PC_W  =   1'd0;
        Mem_W =   1'd0;
        MDR_W =   1'd0;
        RAA_W =   1'd0;
        IR_W =    1'd0;
        RB_W =    1'd1;
        Reg_AB_W= 1'd0;
        EPC_W=    1'd0;
        HILO_W =  1'd0;
        ALU_Out_Reg_W=1'd0;
        //Muxs
        memToReg= 3'd4;
         //RegsInterno
        Counter=32'd0;
        estado_atual =st_Busca;
      
    end
    else if (estado_atual==st_DivException || (divPor0==1'd1 && estado_atual==Div)) begin
        
        if (divPor0==1'd1 && estado_atual==Div) begin// se está entrando no primeiro ciclo dessa excecao
           Counter=1'd0; 
        end


        if (Counter==32'd0) begin
            //writes
            PC_W  =   1'd0;
            Mem_W =   1'd0;
            MDR_W =   1'd0;
            RAA_W =   1'd0;
            IR_W =    1'd0;
            RB_W =    1'd0;
            Reg_AB_W= 1'd0;
            EPC_W=    1'd1;
            HILO_W =  1'd0;
            ALU_Out_Reg_W=1'd0;
            
            //Muxs
            IorD =     2'd2;
            //Controle de Operadores
            EC =       2'd2;
            //RegInterno
            Counter=Counter+32'd1; 
            //Estado_atual
            estado_atual=st_DivException;
        end
        else if (Counter==32'd1) begin
             //writes
            PC_W  =   1'd0;
            Mem_W =   1'd0;
            MDR_W =   1'd0;
            RAA_W =   1'd0;
            IR_W =    1'd0;
            RB_W =    1'd0;
            Reg_AB_W= 1'd0;
            EPC_W=    1'd0;
            HILO_W =  1'd0;
            ALU_Out_Reg_W=1'd0;

            //Muxs
            PCSource=3'd5;
            //Controle de Operadores
            BHControl=1'd0;
            //RegInterno
            Counter=32'd0; 
            //Estado_atual
            estado_atual=st_Busca;

        end
        
    end
    else if (estado_atual==st_Overflow || (Flag_Overflow==1'd1 && (estado_atual==st_LogAri_TipoR || estado_atual==st_addImediato))) begin
        if (Flag_Overflow==1'd1 && (estado_atual==st_LogAri_TipoR || estado_atual==st_addImediato))  begin// se está entrando no primeiro ciclo dessa excecao
           Counter=1'd0; 
        end

        if (Counter=1'd0) begin
             //writes
            PC_W  =   1'd0;
            Mem_W =   1'd0;
            MDR_W =   1'd0;
            RAA_W =   1'd0;
            IR_W =    1'd0;
            RB_W =    1'd0;
            Reg_AB_W= 1'd0;
            EPC_W=    1'd1;
            HILO_W =  1'd0;
            ALU_Out_Reg_W=1'd0;
            
            //Muxs
            IorD =     2'd2;
            //Controle de Operadores
            EC =       2'd1;
            //RegInterno
            Counter=Counter+32'd1; 
            //Estado_atual
            estado_atual=st_Overflow;
        end
        else if (Counter=1'd1) begin
             //writes
            PC_W  =   1'd0;
            Mem_W =   1'd0;
            MDR_W =   1'd0;
            RAA_W =   1'd0;
            IR_W =    1'd0;
            RB_W =    1'd0;
            Reg_AB_W= 1'd0;
            EPC_W=    1'd0;
            HILO_W =  1'd0;
            ALU_Out_Reg_W=1'd0;

            //Muxs
            PCSource=3'd5;
            //Controle de Operadores
            BHControl=1'd0;
            //RegInterno
            Counter=32'd0; 
            //Estado_atual
            estado_atual=st_Busca;
        end
    end
    else begin
        case (estado_atual)         //nenhum estado atual foi atualizado
            
            st_Busca:begin
                
                if (Counter==32'd0) begin
                    //writes
                    PC_W  =   1'd1; ///
                    Mem_W =   1'd0;
                    MDR_W =   1'd0;
                    RAA_W =   1'd0;
                    IR_W =    1'd1; ///
                    RB_W =    1'd0;
                    Reg_AB_W= 1'd0;
                    EPC_W=    1'd0;
                    HILO_W =  1'd0;
                    ALU_Out_Reg_W=1'd0; 
                    //muxs
                    ALUSrcA=2'd0;
                    ALUSrcB=3'd1;
                    IorD=2'd0;
                    // Controle de operadores
                    UlaFunct=3'd1; //soma 
                    Counter= Counter+ 32'd1;
                end
                else if (Counter==32'd1) begin
                    //writes
                    PC_W  =   1'd0; 
                    Mem_W =   1'd0;
                    MDR_W =   1'd0;
                    RAA_W =   1'd0;
                    IR_W =    1'd0; 
                    RB_W =    1'd0;
                    Reg_AB_W= 1'd0;
                    EPC_W=    1'd0;
                    HILO_W =  1'd0;
                    ALU_Out_Reg_W=1'd0;  

                    //muxs
                    ALUSrcA=2'd0;
                    ALUSrcB=3'd1;
                    IorD=2'd0;
                    // Controle de operadores
                    UlaFunct=3'd1; //soma 
                    Counter=32'd0;

                    case (OPCode)// verificar a existencia dos estados
                        
                        R_ALL:begin
                            case (funct)
                                R_ADD :begin
                                    estado_atual =st_LogAri_TipoR;
                                end 

                                R_AND :begin
                                    estado_atual =st_LogAri_TipoR;
                                end 

                                R_DIV :begin
                                    estado_atual =st_Div;
                                end 

                                R_MULT :begin
                                    estado_atual =st_Mult;
                                end 

                                R_JR :begin
                                   estado_atual =st_JumpReg; 
                                end 

                                R_MFHI :begin
                                    estado_atual = st_ReadHI;
                                end 

                                R_MFLO :begin
                                    estado_atual = st_ReadLO;
                                end 

                                R_SLL :begin
                                    estado_atual = st_RT_Left_shamt; 
                                end 

                                R_SLLV :begin
                                    estado_atual = st_RS_Left_RT;
                                end 

                                R_SLT :begin
                                     estado_atual = st_SLT;
                                end 

                                R_SRA :begin
                                    estado_atual = st_RT_RightA_Shamt;
                                end 

                                R_SRAV :begin
                                    estado_atual = st_RS_RightA_RT;
                                end 

                                R_SRL :begin
                                    estado_atual = st_RT_Right_Shamt;
                                end 

                                R_SUB :begin
                                    estado_atual =st_LogAri_TipoR;
                                end 

                                /*R_BREAK :begin
                                    
                                end*/ 

                                R_RTE :begin
                                    estado_atual= st_RTE;
                                end 

                                R_ADDM :begin
                                    estado_atual= st_ADDM;
                                end 


                                
                                default: 
                            endcase
                        end

                        I_ADDI:begin
                            estado_atual=st_addImediato;
                        end 
                        I_ADDI:begin
                            estado_atual=st_ADDImediato; //nao tem o estado ADDIU
                        end

                        I_BEQ :begin
                            estado_atual=st_BEQ;
                        end

                        I_BNE :begin
                            estado_atual=st_BNE;
                        end

                        I_BLE :begin
                            estado_atual=st_BLE;
                        end

                        I_BGT :begin
                            estado_atual=st_BGT;
                        end

                        I_SLLM :begin
                            estado_atual=st_SLLM;
                        end

                        I_LB :begin
                            estado_atual=st_LoadsAndStores;
                        end

                        I_LH :begin
                            estado_atual=st_LoadsAndStores;
                        end

                        I_LW :begin
                            estado_atual=st_LoadsAndStores;
                        end

                        I_LUI :begin
                            estado_atual=st_LUI;
                        end

                        I_SB :begin
                            estado_atual=st_LoadsAndStores;
                        end

                        I_SH :begin
                            estado_atual=st_LoadsAndStores;
                        end

                        I_SW :begin
                            estado_atual=st_LoadsAndStores;
                        end

                        I_SLTI :begin
                            estado_atual=st_menorQ;
                        end

                        J_J :begin
                            estado_atual=st_Jump;
                        end

                        J_JAL :begin
                            estado_atual=st_JAL;
                        end
                        

                        default: begin//OPCodeInexistente
                            estado_atual=st_ExceptionOP;
                        end 
                    endcase


                end
                
                 
            end
            
            st_LoadsAndStores:begin
                  //writes
                PC_W  =   1'd0;
                Mem_W =   1'd0;
                MDR_W =   1'd0;
                RAA_W =   1'd0;
                IR_W =    1'd0;
                RB_W =    1'd0;
                Reg_AB_W= 1'd0;
                EPC_W=    1'd0;
                HILO_W =  1'd0;
                ALU_Out_Reg_W=1'd1; ///
                //muxs
                ALUSrcA=2'd1;
                ALUSrcB=3'd2;
                //RegInterno
                Counter=32'd0; 
                // Controle de operadores
                UlaFunct=3'd1; //soma
                // Mundando para o prox estado
                case (estado_atual)
                    I_LB :begin
                            estado_atual=st_LoadsAndStores;
                    end

                    I_LH :begin
                            estado_atual=st_LoadsAndStores;
                     end

                    I_LW :begin
                            estado_atual=st_LoadsAndStores;
                    end

                    I_SB :begin
                            estado_atual=st_LoadsAndStores;
                    end

                    I_SH :begin
                            estado_atual=st_LoadsAndStores;
                    end

                    I_SW :begin
                            estado_atual=st_LoadsAndStores;
                    end 
                    default: 
                endcase

            end
           
           st_Loads:begin
                 //writes
                PC_W  =   1'd0;
                Mem_W =   1'd0;
                MDR_W =   1'd0;
                RAA_W =   1'd0;
                IR_W =    1'd0;
                RB_W =    1'd0;
                Reg_AB_W= 1'd0;
                EPC_W=    1'd0;
                HILO_W =  1'd0;
                ALU_Out_Reg_W=1'd0;

                //muxs
                IorD = 2'd1;

                //RegInterno
                Counter=32'd0; 

                case (param)
                    I_LB :begin
                            estado_atual=st_LoadsAndStores;
                    end

                    I_LH :begin
                            estado_atual=st_LoadsAndStores;
                     end

                    I_LW :begin
                            estado_atual=st_LoadsAndStores;
                    end 
                    default: 
                endcase

           end

           st_LoadByte:begin
                //writes
                PC_W  =   1'd0;
                Mem_W =   1'd0;
                MDR_W =   1'd0;
                RAA_W =   1'd0;
                IR_W =    1'd0;
                RB_W =    1'd1;///
                Reg_AB_W= 1'd0;
                EPC_W=    1'd0;
                HILO_W =  1'd0;
                ALU_Out_Reg_W=1'd0;

                //muxs
                memToReg=3'd7;
                regDST=2'd3;

                //RegInterno
                Counter=32'd0; 
            
                //controle de operadores
                BHControl=1'd0;
                //mudando para o prox estado
                estado_atual=st_Busca;
           end

            st_LoadHalf:begin
                //writes
                PC_W  =   1'd0;
                Mem_W =   1'd0;
                MDR_W =   1'd0;
                RAA_W =   1'd0;
                IR_W =    1'd0;
                RB_W =    1'd1;///
                Reg_AB_W= 1'd0;
                EPC_W=    1'd0;
                HILO_W =  1'd0;
                ALU_Out_Reg_W=1'd0;

                //muxs
                memToReg=3'd7;
                regDST=2'd3;
                
                //RegInterno
                Counter=32'd0; 
                
                //controle de operadores
                BHControl=1'd1;
                //mudando para o prox estado
                estado_atual=st_Busca;
           end

           st_LoadWord:begin
                //writes
                PC_W  =   1'd0;
                Mem_W =   1'd0;
                MDR_W =   1'd0;
                RAA_W =   1'd0;
                IR_W =    1'd0;
                RB_W =    1'd1;///
                Reg_AB_W= 1'd0;
                EPC_W=    1'd0;
                HILO_W =  1'd0;
                ALU_Out_Reg_W=1'd0;

                //muxs
                memToReg=3'd5;
                regDST=2'd3;

                //RegInterno
                Counter=32'd0; 
                //mudando para o prox estado
                estado_atual=st_Busca;
                
                
           end

           st_StoreWord:begin
                //writes
                PC_W  =   1'd0;
                Mem_W =   1'd1;///
                MDR_W =   1'd0;
                RAA_W =   1'd0;
                IR_W =    1'd0;
                RB_W =    1'd0;
                Reg_AB_W= 1'd0;
                EPC_W=    1'd0;
                HILO_W =  1'd0;
                ALU_Out_Reg_W=1'd0;

                //muxs
                IorD = 2'd1;
                WriteMemSrc=1'd1;

                //RegInterno
                Counter=32'd0; 
                //mudando para o prox estado
                estado_atual=st_Busca;
                
                
           end
           st_StoreByte:begin
                //writes
                PC_W  =   1'd0;
                Mem_W =   1'd1;///
                MDR_W =   1'd0;
                RAA_W =   1'd0;
                IR_W =    1'd0;
                RB_W =    1'd0;
                Reg_AB_W= 1'd0;
                EPC_W=    1'd0;
                HILO_W =  1'd0;
                ALU_Out_Reg_W=1'd0;

                //muxs
                IorD = 2'd1;
                WriteMemSrc=1'd0;

                //RegInterno
                Counter=32'd0; 

                //controle de blocos
                BHControl=1'd0;
                //mudando para o prox estado
                estado_atual=st_Busca;
                
           end

           st_StoreHalf:begin
                //writes
                PC_W  =   1'd0;
                Mem_W =   1'd1;///
                MDR_W =   1'd0;
                RAA_W =   1'd0;
                IR_W =    1'd0;
                RB_W =    1'd0;
                Reg_AB_W= 1'd0;
                EPC_W=    1'd0;
                HILO_W =  1'd0;
                ALU_Out_Reg_W=1'd0;

                //muxs
                IorD = 2'd1;
                WriteMemSrc=1'd0;
                
                //RegInterno
                Counter=32'd0; 

                //controle de blocos
                BHControl=1'd1;
                //mudando para o prox estado
                estado_atual=st_Busca;
                
           end
            
            st_LogAri_TipoR :begin
                
                if (Counter==32'd0) begin
                    //writes
                    PC_W  =   1'd0;
                    Mem_W =   1'd0;
                    MDR_W =   1'd0;
                    RAA_W =   1'd0;
                    IR_W =    1'd0;
                    RB_W =    1'd0;
                    Reg_AB_W= 1'd0;
                    EPC_W=    1'd0;
                    HILO_W =  1'd0;
                    ALU_Out_Reg_W=1'd0;
                    
                    //muxs
                    ALUSrcA=2'd2;
                    ALUSrcB=3'd0;

                    case (funct)
                        R_ADD :begin
                           UlaFunct=3'd1; //soma
                        end 

                        R_AND :begin
                            UlaFunct=3'd3; //and
                        end  

                        R_SUB :begin
                            UlaFunct=3'd2; //subtrai
                        end
                        default: 
                    endcase

                    //trantando do prox estado

                    if (Flag_Overflow==1'd1) begin
                        estado_atual=st_Overflow;
                        //contador esta em zero
                    end
                    else begin
                        //estado atual continua msm
                        Counter=Counter+ 32'd1;
                    end

                end
                else if (Counter==32'd1) begin
                    //writes
                    PC_W  =   1'd0;
                    Mem_W =   1'd0;
                    MDR_W =   1'd0;
                    RAA_W =   1'd0;
                    IR_W =    1'd0;
                    RB_W =    1'd1;///
                    Reg_AB_W= 1'd0;
                    EPC_W=    1'd0;
                    HILO_W =  1'd0;
                    ALU_Out_Reg_W=1'd0;
                    //muxs
                    RegDst= 2'd3;
                    MemToReg= 4'd6;

                    //prox estado
                    estado_atual=st_Busca;
                    Counter=32'd0;
                end
                
                

            end
           
            st_ADDImediato:begin
                
                if (Counter==32'd0) begin
                    //writes
                    PC_W  =   1'd0;
                    Mem_W =   1'd0;
                    MDR_W =   1'd0;
                    RAA_W =   1'd0;
                    IR_W =    1'd0;
                    RB_W =    1'd0;
                    Reg_AB_W= 1'd0;
                    EPC_W=    1'd0;
                    HILO_W =  1'd0;
                    ALU_Out_Reg_W=1'd0;   
                    //muxs 
                    ALUSrcA=2'd2;
                    ALUSrcB=3'd2;
                    //operadores
                    UlaFunct=3'd1;
                    
                    if (Flag_Overflow==1'd1 && OPCode!= I_ADDIU) begin
                        estado_atual=st_Overflow;
                        //contador esta em zero
                    end
                    else begin
                        //estado atual continua o msm
                        Counter=Counter+ 32'd1;
                    end

                

                end

                else if (Counter==32'd1) begin
                    //writes
                    PC_W  =   1'd0;
                    Mem_W =   1'd0;
                    MDR_W =   1'd0;
                    RAA_W =   1'd0;
                    IR_W =    1'd0;
                    RB_W =    1'd1;///
                    Reg_AB_W= 1'd0;
                    EPC_W=    1'd0;
                    HILO_W =  1'd0;
                    ALU_Out_Reg_W=1'd0; 
                    //mux
                    RegDst=2'd0;
                    MemToReg=4'd6;
                    //prox estado
                    estado_atual=st_Busca;
                    Counter=32'd0;'

                end



            end

            default: 
        endcase
    end
end



endmodule
/*
 //      muxsControl
        controlDivMult;
        WriteMemSrc;
        PCWriteCond;
        ShiftIn;
        ShiftAmt;
        BHControl;
        EC_CTRL;
        regDST;
        CB;
        IorD;
        ALUSrcB;
        PCSource;
        memToReg;
        Shift;
        //      Control de blocos
        ALUControl;
        QualException;*/