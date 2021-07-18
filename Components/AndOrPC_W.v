module AndOrPC_W (
    input wire data,
    input wire PCWriteCond,
    input wire PCWrite,
    output wire AndOrPC_W_out
);

    wire aux;
    assign aux = data & PCWriteCond;
    assign AndOrPC_W_out = aux | PCWrite;

    
    
endmodule