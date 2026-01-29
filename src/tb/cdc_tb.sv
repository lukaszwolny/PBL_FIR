`timescale 1ns/1ps

module tb_cdc_module;

    // ==============================
    // Zegary i reset
    // ==============================
    reg clk_a;
    reg clk_b;
    reg rst_n;

    // ==============================
    // Sygnały domeny A
    // ==============================
    reg  [5:0]  p_address;
    reg  [15:0] p_data;
    reg         p_wr;
    wire [15:0] p_data_back;

    // ==============================
    // Sygnały domeny B
    // ==============================
    wire [5:0]  CDC_A;
    wire [15:0] CDC_data;
    wire        CDC_wr;
    reg  [15:0] data_back;

    // ==============================
    // DUT
    // ==============================
    cdc_module dut (
        .clk_a(clk_a),
        .clk_b(clk_b),
        .rst_n(rst_n),

        .p_address(p_address),
        .p_data(p_data),
        .p_wr(p_wr),
        .p_data_back(p_data_back),

        .CDC_A(CDC_A),
        .CDC_data(CDC_data),
        .CDC_wr(CDC_wr),
        .data_back(data_back)
    );

    // ==============================
    // Zegary
    // ==============================
    initial clk_a = 0;
    always #10 clk_a = ~clk_a;   // 100 MHz

    initial clk_b = 0;
    always #7 clk_b = ~clk_b;   // ~71 MHz

    // ==============================
    // Prosta pamięć (domena B)
    // ==============================
    reg [15:0] mem [0:63];

    always @(posedge clk_b) begin
        if (CDC_wr) begin
            mem[CDC_A] <= CDC_data;
            $display("[%0t] DOMENA B: ZAPIS mem[%0d] = 0x%04h", $time, CDC_A, CDC_data);
        end
        // zawsze aktualizuj data_back dla odczytu
        data_back <= mem[CDC_A];
    end

    // ==============================
    // Zmienne testowe
    // ==============================
    reg [15:0] test_data [0:4];
    reg [5:0]  test_addr [0:4];
    integer j;

    initial begin
        // Inicjalizacja danych testowych
        test_addr[0] = 6'd1;   test_data[0] = 16'h1111;
        test_addr[1] = 6'd5;   test_data[1] = 16'hABCD;
        test_addr[2] = 6'd10;  test_data[2] = 16'h1234;
        test_addr[3] = 6'd32;  test_data[3] = 16'hDEAD;
        test_addr[4] = 6'd63;  test_data[4] = 16'hBEEF;
    end

    // ==============================
    // Task zapisu
    // ==============================
    task write_data;
        input [5:0] addr;
        input [15:0] data;
        integer i;
        begin
            @(posedge clk_a);
            p_address <= addr;
            p_data    <= data;
            p_wr      <= 1'b1;

            @(posedge clk_a);
            p_wr      <= 1'b0;

            // Poczekaj na synchronizację (3-4 cykli clk_b = ~2 cykli clk_a)
            #100;
            $display("[%0t] DOMENA A: ZAPIS addr=%0d data=0x%04h", $time, addr, data);
        end
    endtask

    // ==============================
    // Task odczytu
    // ==============================
    task read_data;
        input [5:0] addr;
        integer i;
        begin
            @(posedge clk_a);
            p_address <= addr;
            p_wr      <= 1'b0;

            // Poczekaj na synchronizację CDC:
            // clk_b (2 flopy dla addr) + data_back (2 flopy do clk_a) + margines
            // ~70-80ns bezpiecznie (8-10 cykli clk_a)
            repeat(10) @(posedge clk_a);
            $display("[%0t] DOMENA A: ODCZYT addr=%0d data_back=0x%04h", $time, addr, p_data_back);
        end
    endtask

    // ==============================
    // Test główny
    // ==============================
    initial begin
        // Inicjalizacja
        clk_a = 0;
        clk_b = 0;
        rst_n = 0;
        p_address = 0;
        p_data = 0;
        p_wr = 0;
        data_back = 0;

        #50;
        rst_n = 1;
        $display("[%0t] ===== RESET RELEASED =====", $time);

        #50;
        $display("[%0t] ===== TEST ZAPISU =====", $time);
        // Zapisz wszystkie dane testowe
        for (j=0; j<5; j=j+1) begin
            write_data(test_addr[j], test_data[j]);
            #50;
        end

        #100;
        $display("[%0t] ===== TEST ODCZYTU =====", $time);
        // Odczytaj wszystkie dane testowe
        for (j=0; j<5; j=j+1) begin
            read_data(test_addr[j]);
            #50;
        end

        #100;
        $display("[%0t] ===== ALL TESTS PASSED =====", $time);
        $finish;
    end

    initial begin
        $dumpfile("cdc_tb.vcd");
        $dumpvars(0, tb_cdc_module);
    end

endmodule
