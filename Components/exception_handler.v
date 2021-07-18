module exception_handler (pc_data, ec_control, new_pc, old_pc);
   
    input wire [1:0] ec_control;
    input wire [31:0] pc_data;
    output wire [31:0] new_pc;
    output wire [31:0] old_pc;

    assign old_pc = pc_data;
    assign new_pc = ec_control[1] ? (32'd255): (ec_control[0] ? (32'd254):(32'd253) );
    
endmodule 
