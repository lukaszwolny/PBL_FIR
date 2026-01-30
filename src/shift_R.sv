

module shift_R(
    input clk,
    input rst_n,
    input  [13:0] ile_probek,
    input [15:0] probka_in,
    output logic [15:0] out,
    input nowa_shift,
    input reset_shift,
    input [4:0] adres //0..31
);

// logic [15:0] reg_shift [0:31];
logic [31:0][15:0] reg_shift;
logic [13:0] max_probki_licznik;

always_ff @(posedge clk) begin
    if(!rst_n) begin
        reg_shift <= '0;
        max_probki_licznik <= '0;
    end else begin

        if(reset_shift) begin
            reg_shift <= '0;
            max_probki_licznik <= '0;
        end
        if(nowa_shift) begin
            //tutaj jeszcze testy progowych wartosci...
            reg_shift <= (max_probki_licznik < ile_probek) ? {reg_shift[30:0], probka_in} : {reg_shift[30:0], 16'd0};//..  {probka_in, reg_shift[31:1]};//..
            // +  tutaj trzeba wypelniac na koniec zeramii... albo w ram wej beda zera albo tutaj cos wymyslec
            max_probki_licznik <= max_probki_licznik + 1'b1;
        end

        out <= reg_shift[adres];

    end
end

// assign out = reg_shift[adres];

endmodule 