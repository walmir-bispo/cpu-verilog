module div(input wire Data_a,
            input wire Data_b,
            input wire reset,
            input wire clk,
            output reg [31:0] lo,
            output reg [31:0] hi,
            output reg exception);


always @(posedge clk)
begin
  if(reset)
  begin
    lo <= 32'd0;
    hi <= 32'd0;
  end
  if(Data_b == 1'b0)
  begin
    exception <= 0;
    end
    lo <= Data_a/Data_b;
    hi <= Data_a%Data_b;

end

endmodule