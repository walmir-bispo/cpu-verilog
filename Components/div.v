module div(input wire[31:0] Dividendo,
            input wire [31:0] Divisor,
            input wire reset,
            input wire clk,
            output wire [31:0] LO,
            output wire [31:0] HI,
            output wire exception
			);

  reg[63:0] Resto;
  reg[5:0] Counter;
  reg[31:0] auxDividendo;
  reg[63:0] auxDivisor;
  reg[31:0] auxException;
  reg[31:0] auxQuociente;
  reg seletor;
  reg seletorException;
  reg [31:0] auxLO;
  reg [31:0] auxHI;
 

initial begin
  auxDividendo = Dividendo;
  auxDivisor[63:31] = Divisor;
  auxException = Divisor;
  Resto = Dividendo;
end

always @(posedge clk or Dividendo or Divisor or reset)
begin
  if(reset == 1'b1)begin
    Resto = 64'd0;
    Counter = 6'd0;
    auxDividendo = 32'd0;
    auxDivisor = 64'd0;
    auxQuociente = 32'd0;
    seletor = 1'b0;
	 seletorException = 1'b0;
	 auxException = 32'd0;
    end
	 else begin 
	 Resto = auxDivisor - Resto;
	end
  
    if(Resto >= 0)begin 
        auxQuociente = auxQuociente<<1;
        auxQuociente[0] = 1'b1;

        auxDivisor = auxDivisor>>1;
        Counter = Counter + 1'b1;
    end
    else begin 
        Resto = auxDivisor + Resto;
        auxQuociente = auxQuociente<<1;
        auxQuociente[0] = 1'b0;
    
        
        Counter = Counter + 1'b1;
    end 
	 
	 auxDivisor = auxDivisor>>1;

    if(Counter == 6'b0100001)begin
		auxHI =  Resto[31:0];
		auxLO =  auxQuociente[31:0];
		seletor = 1;
  if(auxException == 32'd0)begin
		seletorException = 1;
  end
end
end

assign HI = (seletor) ? auxHI:HI;
assign LO = (seletor) ? auxLO:LO;
assign exception = seletorException ? 1:0;





endmodule