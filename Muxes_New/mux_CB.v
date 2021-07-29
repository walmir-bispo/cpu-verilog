module mux_CB (
    input wire [1:0] selector,
    input wire  data_0,  
    input wire  data_1, 
    input wire  data_2,
    input wire  data_3,  
    output wire  data_out
);

    //data_0---| 
    //data_1---|---|
                 //|----data_out
    //data_2---|---|
    //data_3---|


    assign A1 = (selector[0]) ? data_1 : data_0; //considerando q selector[1]==1
    assign A2 = (selector[0]) ? data_3 : data_2; //considerando q selector[1]==1
    assign data_out = (selector[1]) ? A2 : A1; //verificando se a saida é A2, que escolhe a saida verificando
                                                // o seletor[0] para seletor[1]=1, ou A1, que faz a mesma vereficação
                                                // mas considera que seletor[1]=0
endmodule