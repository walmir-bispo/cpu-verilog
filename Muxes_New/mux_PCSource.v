module mux_PCSource (selector, data_3, data_5, data_1, data_2, data_4, data_0, data_out);
    input wire [2:0] selector;
    input wire [31:0] data_0; 
    input wire [31:0] data_1; 
    input wire [31:0] data_2;
    input wire [31:0] data_3; 
    input wire [31:0] data_4; 
    input wire [31:0] data_5; 
    output wire [31:0] data_out;
	 
	wire [31:0] temp1;
	assign temp1 = (selector[0]) ? (data_5) : (data_4);
	 
	wire [31:0] temp2;
	assign temp2 = selector[1] ? (selector[0] ? (data_3) : (data_2)) : (selector[0] ? (data_1) : (data_0)); 
	 
	assign data_out = (selector[2]) ? (temp1) : (temp2);
	 

endmodule