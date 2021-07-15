module Mult(
input wire        clk,
input wire        reset,
input wire [31:0] Multiplicando,
input wire [31:0] Multiplicador,
output wire [31:0] LO,
output wire [31:0] HI
);

reg [31:0] Q;
reg [31:0] A;
reg [6:0] contador;
reg [31:0] M;
reg AuxShiftLeftAri;
reg [31:0] regLO;
reg [31:0] regHI;
reg        seletor;
reg QMenos1;
reg [64:0] AQQMenos1;
reg [31:0] auxQ;
reg [31:0] auxM;
reg 		  resetInicial;



 initial begin
  
		  resetInicial=1'b1;
 end
 

always @(posedge clk  ) begin
    
	 

	 
	 
    if (reset==1'b1) begin
		  auxM=Multiplicando;
        auxQ=Multiplicador;
		  M=Multiplicando;
        Q=Multiplicador;
        A=32'd0;
        QMenos1=1'd0;
        contador=7'd32;
        seletor=0;
        
        AQQMenos1={A,Q,QMenos1};
        
        AuxShiftLeftAri=1'b0;
        regLO=32'b0;
        regHI=32'b0;
    end
    
	 
	 
	 else begin
        
		  
		  
		  
		  
        if (auxQ != Multiplicador || auxM != Multiplicando || resetInicial== 1'b1 ) begin //se um dos fatores mudar, reseta os regs e faz a operacao
            resetInicial=1'b0;
				auxM=Multiplicando;
            auxQ=Multiplicador;
            M=Multiplicando;
            Q=Multiplicador;
            A=32'd0;
            QMenos1=1'd0;
            contador=7'd32;
            seletor=0;
            
            AQQMenos1={A,Q,QMenos1};
            
            AuxShiftLeftAri=1'b0;
            regLO=32'b0;
            regHI=32'b0;
            end





        if (Q[0]!=QMenos1) begin
            if (Q[0]==1'b1) begin
                A=A-M;
            end
            else begin
                A=A+M;
            end

        AQQMenos1={A,Q,QMenos1};// já que A foi alterado, entao isso tem que ser redefinido
        end

        
        AuxShiftLeftAri=AQQMenos1[64];
        AQQMenos1=AQQMenos1>>1;     //deslocamento aritmetico a direita de A+Q+Q[-1]
        AQQMenos1[64]=AuxShiftLeftAri;

        A=AQQMenos1[64:33];
        Q=AQQMenos1[32:1];          //levando os resultados para seus respectivos regs
        QMenos1=AQQMenos1[0];



        contador=contador-7'd1;     //decrementando contador

        if (contador==7'd0) begin
            regHI=A;
            regLO=Q;
				seletor=1;
        end
    end
end





assign HI= (seletor) ? regHI: HI;
assign LO= (seletor) ? regLO: LO;

endmodule
