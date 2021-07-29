module mux_RegDst(selector, data_3, data_0, data_out);
    input wire [1:0] selector;
    input wire [4:0] data_0;
    //input wire [31:0] data_1; -- 31 --
    //input wire [31:0] data_2; -- 29 -- 
    input wire [4:0] data_3;
    output wire [4:0] data_out;

	assign data_out = selector[1] ? ( selector[0] ? (data_3) : (5'd29) ) : ( selector[0] ? (5'd31) : (data_0) ); 

endmodule