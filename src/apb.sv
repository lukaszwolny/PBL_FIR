module apb (
    // APB3 clock & reset
    input  logic        PCLK,
    input  logic        PRESETn,

    // APB3 address & control
    input  logic [31:0] PADDR,
    input  logic        PSELx,
    input  logic        PENABLE,
    input  logic        PWRITE,
    input  logic [31:0] PWDATA,

    // APB3 response
    output logic        PREADY,
    output logic [31:0] PRDATA,
    output logic        PSLVERR,

    // Internal peripheral interface (jak na rysunku)
    output logic [5:0]  p_address,
    output logic [15:0] p_data,
    output logic        p_wr,
    input  logic [15:0] p_data_back
);

    logic rd_waiting; //sygnał wait-state dla odczytu

    assign PSLVERR = 1'b0; // Brak błędów slave

    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PRDATA    <= 32'b0;
            PREADY    <= 1'b0;
            p_address <= 6'b0;
            p_data    <= 16'b0;
            p_wr      <= 1'b0;

            rd_waiting   <= 1'b1;
        end else begin
            p_wr   <= 1'b0; // domyślnie 0 (impuls)
            PREADY <= 1'b0;

            // SETUP phase – zapamiętaj adres
            if (PSELx && !PENABLE) begin
                p_address <= PADDR[5:0];
                $display("APB: p_address=%d", p_address);
            end

            // WRITE
            if (PSELx && PENABLE && PWRITE) begin
                p_data <= PWDATA[15:0];
                p_wr   <= 1'b1;
                PREADY <= 1'b1;
            end

            // READ (z wait state)
            if (PSELx && PENABLE && !PWRITE && rd_waiting) begin
                PREADY <= 1'b0; //niegotowy
                rd_waiting <= 1'b0;
            end else if (PSELx && PENABLE && !PWRITE && !rd_waiting) begin
                PREADY <= 1'b1; //gotowy
                PRDATA <= {16'b0, p_data_back};
                rd_waiting <= 1'b1;
            end
        end
    end

endmodule
