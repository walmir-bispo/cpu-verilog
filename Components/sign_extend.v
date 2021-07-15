module sign_extend (data, data_extend);
    input wire [15:0] data;
    output wire [31:0] data_extend;
	
	assign data_extend = {{16{data[15]}},data};
     

endmodule