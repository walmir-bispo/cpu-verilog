module mux_alu_src_b (selector, data_3, data_2, data_4, data_0, data_out);
    input wire [2:0] selector;
    input wire [31:0] data_0;
    //input wire [31:0] data_1; -- constante 4 --
    input wire [31:0] data_2;
    input wire [31:0] data_3;
    input wire [31:0] data_4;
    output wire [31:0] data_out;

	wire [31:0] temp;
	assign temp = selector[1] ? ( selector[0] ? (data_3) : (data_2) ) : ( selector[0] ? (32'd4) : (data_0) ); 
	
	assign data_out = (selector[2]) ? (data_4) : (temp);
	 
 
endmodule