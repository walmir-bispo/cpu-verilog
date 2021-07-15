module exception_handler (/*clk, */pc_data, ec_control, new_pc, old_pc);
    //input clk;
    input wire [1:0] ec_control;
    input wire [31:0] pc_data;
    output wire [31:0] new_pc;
    output wire [31:0] old_pc;

       /*always @(posedge clk) begin
        case(ec_control)begin
            2'b00: new_pc 32'd253;
            2'b01: new_pc 32'd254;
            2'b10: new_pc 32'd255;
        endcase
    end*/

    assign old_pc = pc_data;
    assign new_pc = ec_control[1] ? (32'd255): (ec_control[0] ? (32'd254):(32'd253) );
    
endmodule 