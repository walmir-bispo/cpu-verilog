module div(input wire[31:0] Input_A,
            input wire [31:0] Input_B,
            input wire reset,
            input wire clk,
            output wire [31:0] LO,
            output wire [31:0] HI,
            output wire exception
			);

  reg[63:0] resto;
  reg[6:0] counter;
  reg[63:0] divisor;
  reg[31:0] quociente;
  reg seletor;
  reg [31:0] auxException = Input_B;
  reg seletorException;
  reg [31:0] auxLO;
  reg [31:0] auxHI;
 

initial begin
    counter = 6'd0;
end


always @(posedge clk)
begin
  if(reset == 1'b1)begin
    resto = 64'd0;
    counter = 32'd0;
    divisor = 64'd0;
    quociente = 32'd0;
    seletor = 1'b0;
	  seletorException = 1'b0;
    end
    if(counter == 0)begin
      divisor[63:32] = Input_B;
      counter = counter + 1'b1;
    end
    if(auxException == 32'd0)begin
      seletorException = 1;
      counter = 6'd33;
    end
    else if(counter <= 6'd33) begin
      resto = divisor - resto;
      if(resto >= 0)begin
      quociente = quociente << 1;
      quociente[0] = 1'b1;
      end
      else begin
        resto = divisor + resto;
        quociente = quociente << 1;
        quociente[0] = 1'b0;
      end
    divisor = divisor >> 1; 
    counter = counter + 1;
      if(counter == 6'd33)begin
        seletor = 1;
      end
    end
  end

assign HI = seletor ? resto[31:0]:0;
assign LO = seletor ? quociente:0;
assign exception = seletorException ? 1:0;

endmodule
