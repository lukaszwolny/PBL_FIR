module multiplier (
    input signed [15:0] shift_out,        // IN
    input signed [15:0] wsp_data,           // IN
    output logic [31:0] mnozenie_wynik      // OUT (>16)  [31:0]
);

    always_comb begin
        mnozenie_wynik = (shift_out * wsp_data);  //({16'b0, shift_out} * {16'b0, wsp_data});
    end

endmodule
