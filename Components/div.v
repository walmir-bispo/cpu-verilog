module div(input wire[31:0] Data_a,
            input wire [31:0] Data_b,
            input wire reset,
            input wire clk,
            output wire [31:0] lo,
            output wire [31:0] hi,
            output reg exception);

  reg [31:0] auxLO;
  reg [31:0] auxHI;

always @(posedge clk)
begin
  if(reset)
  begin
    auxLO <= 32'd0;
    auxHI <= 32'd0;
  end
  if(Data_b == 32'd0)
  begin
    exception <= 1;
    end
    auxLO <= Data_a/Data_b;
    auxHI <= Data_a%Data_b;

end
  assign lo = auxLO;
  assign hi = auxHI;

endmodule