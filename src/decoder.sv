module decoder (
    input  logic [5:0] CDC_A,
    input  logic       CDC_wr,

    output logic       Dekoder_MUX,
    output logic [4:0] address_RAM,
    output logic       wr_RAM,
    output logic [2:0] nr_Rejestru,
    output logic       wr_Rej
);

    always_comb begin 
        Dekoder_MUX = 1'b0;
        address_RAM = 5'd0;
        nr_Rejestru = 3'd0;
        wr_RAM      = 1'b0;
        wr_Rej      = 1'b0;

        if (CDC_A[5] == 1'b0) begin
            // ===== RAM współczynników =====
            Dekoder_MUX = 1'b0;
            address_RAM = CDC_A[4:0];
            wr_RAM      = CDC_wr;
            wr_Rej      = 1'b0;
        end
        else begin
            // ===== Rejestry kontrolne =====
            Dekoder_MUX = 1'b1;
            nr_Rejestru = CDC_A[2:0];
            wr_Rej      = CDC_wr;
            wr_RAM      = 1'b0;
        end
    end

endmodule
