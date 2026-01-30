/*
iverilog -g2012 -o fir_main_tb.vvp ../fir_main.sv ../ram.sv ../shift_R.sv ../multiplier.sv ../licznik.sv ../licznik_petli.sv ../fsm.sv ../adder.sv ../acc.sv fir_main_tb.sv
*/
module fir_main_tb;

logic clk;
logic rst_n;
logic [5:0] f_ile_wsp;
logic [13:0] f_ile_probek;
logic [15:0] f_wsp_data;
logic f_start;
logic [15:0] f_probka;
logic [4:0] f_adress_fir;
logic f_fsm_mux_cdc;
logic f_pracuje;
logic f_done;
logic [12:0] f_a_probki_fir;
logic f_fsm_mux_wej;
logic f_fsm_mux_wyj;
logic [15:0] f_fir_probka_wynik;
// logic [20:0] f_fir_probka_wynik;
logic f_fsm_wyj_wr;
logic [14:0] f_ile_razy; 

logic [15:0] CDC_data;
logic [2:0]  nr_Rejestru;
logic wr_Rej;
logic [15:0] Rej_out;
// logic Start;
// logic [5:0]  Ile_wsp;
// logic [13:0] Ile_probek;
// logic DONE;
// logic Pracuje;
// logic [14:0] ile_razy

//rej ster
ctrl_registers u_ctrl_registers (
    .clk_b(clk),
    .rst_n(rst_n),
    .CDC_data(CDC_data),
    .nr_Rejestru(nr_Rejestru),
    .wr_Rej(wr_Rej),
    .Rej_out(Rej_out),
    .Start(f_start),
    .Pracuje(f_pracuje),
    .DONE(f_done),
    .Ile_wsp(f_ile_wsp),
    .Ile_probek(f_ile_probek),
    .ile_razy(f_ile_razy)
);


//fir
FIR_main u_fir(
    .clk(clk),
    .rst_n(rst_n),
    .f_ile_wsp(f_ile_wsp),//f_ile_wsp
    .f_ile_probek(f_ile_probek),//f_ile_probek
    .f_ile_razy(f_ile_razy),//f_ile_razy
    .f_wsp_data(f_wsp_data),
    .f_start(f_start),//f_start
    .f_probka(f_probka),
    .f_adress_fir(f_adress_fir),
    .f_fsm_mux_cdc(f_fsm_mux_cdc),
    .f_pracuje(f_pracuje),
    .f_done(f_done),
    .f_a_probki_fir(f_a_probki_fir),
    .f_fsm_mux_wej(f_fsm_mux_wej),
    .f_fsm_mux_wyj(f_fsm_mux_wyj),
    .f_fir_probka_wynik(f_fir_probka_wynik),
    .f_fsm_wyj_wr(f_fsm_wyj_wr)
);

//ramy
ram #(
    .ADDR_WIDTH(5),
    .DATA_WIDTH(16)
) wsp_ram (
    .clk(clk),
    .wr(1'b0),//wr_mem
    .adres(f_adress_fir),//adres
    .data(16'd0),
    .data_out(f_wsp_data)
);
ram #(
    .ADDR_WIDTH(13),
    .DATA_WIDTH(16)
) probk_ram (
    .clk(clk),
    .wr(1'b0),//wr_mem
    .adres(f_a_probki_fir),//adres
    .data(16'd0),
    .data_out(f_probka)
);
logic [15:0] meh;
ram #(
    .ADDR_WIDTH(13),
    .DATA_WIDTH(16)
) probk_ram_wyn (
    .clk(clk),
    .wr(f_fsm_wyj_wr),//wr_mem
    .adres(f_a_probki_fir),//adres
    .data(f_fir_probka_wynik),
    // .data(f_fir_probka_wynik[15:0]),
    .data_out(meh)
);


initial clk = 1;
always #5 clk = ~clk;

initial begin
    $dumpfile("fir_main_tb.vcd");
    $dumpvars(0, fir_main_tb);
end


initial begin

    //wsp
    //testyyy
    // wsp_ram.pamiec_RAM[0] = 16'hA000;
    // wsp_ram.pamiec_RAM[1] = 16'hB000;
    // wsp_ram.pamiec_RAM[2] = 16'hC000;
    // wsp_ram.pamiec_RAM[0] = 16'h000A;
    // wsp_ram.pamiec_RAM[1] = 16'h000B;
    // wsp_ram.pamiec_RAM[2] = 16'h000C;

    // wsp_ram.pamiec_RAM[0] = 16'b1100000000000000;
    // wsp_ram.pamiec_RAM[1] = 16'b0100000000000000;
    // wsp_ram.pamiec_RAM[2] = 16'b1100000000000000;

    //--- ----------------------------
    // wsp_ram.pamiec_RAM[0] = 16'b0100000000000000;  //16384  0100000000000000
    // wsp_ram.pamiec_RAM[1] = 16'b0100000000000000;
    // wsp_ram.pamiec_RAM[2] = 16'b0100000000000000;

    // wsp_ram.pamiec_RAM[3] = 16'b1111111111111111;
    //--- ----------------------------------

    //probki

    // probk_ram.pamiec_RAM[0] = 16'b0000000000000001;
    // probk_ram.pamiec_RAM[1] = 16'b0000000000000010;
    // probk_ram.pamiec_RAM[2] = 16'b0000000000000011;
    // probk_ram.pamiec_RAM[3] = 16'b0000000000000100;

    // probk_ram.pamiec_RAM[0] = 16'b0010000000000000;
    // probk_ram.pamiec_RAM[1] = 16'b0010000000000000;
    // probk_ram.pamiec_RAM[2] = 16'b0010000000000000;
    // probk_ram.pamiec_RAM[3] = 16'b0010000000000000;
    //--- ------------------------------
    // probk_ram.pamiec_RAM[0] = 16'b0010000000000000;
    // probk_ram.pamiec_RAM[1] = 16'b0010000000000000;
    // probk_ram.pamiec_RAM[2] = 16'b0010000000000000;
    // probk_ram.pamiec_RAM[3] = 16'b0010000000000000;

    // probk_ram.pamiec_RAM[4] = 16'b1111111111111111;
    //-----------------------------------

    //1.
    //dodatnie - dziala
    // f_ile_wsp = 3; //ile wsp
    // wsp_ram.pamiec_RAM[0] = 16'b0100000000000000;  //16384]   #1/2
    // wsp_ram.pamiec_RAM[1] = 16'b0100000000000000;
    // wsp_ram.pamiec_RAM[2] = 16'b0100000000000000;
    // f_ile_probek = 3; // ile probek
    // probk_ram.pamiec_RAM[0] = 16'b0010000000000000;   //8192]  # 1/4
    // probk_ram.pamiec_RAM[1] = 16'b0010000000000000;     //8192]  # 1/4
    // probk_ram.pamiec_RAM[2] = 16'b0010000000000000;    // 8192]  # 1/4
    // probk_ram.pamiec_RAM[3] = 16'b0010000000000000;     //-4000   −0.1220703

    // wsp_ram.pamiec_RAM[3] = 16'b1111111111111111;
    // probk_ram.pamiec_RAM[4] = 16'b1111111111111111;


    //2.
    //1 wsp = -1  
    // f_ile_wsp = 1; //ile wsp
    // wsp_ram.pamiec_RAM[0] = 16'b1000_0000_0000_0000;  //-32768    −1.000000
    // wsp_ram.pamiec_RAM[1] = 16'b0000000000000000;
    // wsp_ram.pamiec_RAM[2] = 16'b0000000000000000;
    // f_ile_probek = 4; // ile probek
    // probk_ram.pamiec_RAM[0] = 16'b0000_0011_1110_1000;   //1000   +0.0305176
    // probk_ram.pamiec_RAM[1] = 16'b1111_1000_0011_0000;     //-2000   −0.0610352
    // probk_ram.pamiec_RAM[2] = 16'b0000_1011_1011_1000;    // 3000   +0.0915527
    // probk_ram.pamiec_RAM[3] = 16'b1111_0000_0110_0000;     //-4000   −0.1220703

    // wsp_ram.pamiec_RAM[3] = 16'b1111111111111111;
    // probk_ram.pamiec_RAM[4] = 16'b1111111111111111;

    //3.
    // f_ile_wsp = 1; //ile wsp
    // wsp_ram.pamiec_RAM[0] = 16'b1000_0000_0000_0000;  //-32768    −1.000000
    // wsp_ram.pamiec_RAM[1] = 16'b0000000000000000;
    // wsp_ram.pamiec_RAM[2] = 16'b0000000000000000;
    // f_ile_probek = 3; // ile probek
    // probk_ram.pamiec_RAM[0] = 16'b0010000000000000;  //8192]  # 1/4
    // probk_ram.pamiec_RAM[1] = 16'b0010000000000000;     //8192]  # 1/4
    // probk_ram.pamiec_RAM[2] = 16'b0010000000000000;    //8192]  # 1/4
    // probk_ram.pamiec_RAM[3] = 16'b0010000000000000;    //8192]  # 1/4

    // wsp_ram.pamiec_RAM[3] = 16'b1111111111111111;
    // probk_ram.pamiec_RAM[4] = 16'b1111111111111111;


    //4.
    // f_ile_wsp = 2; //ile wsp
    // wsp_ram.pamiec_RAM[0] = 16'b0000000000000000;  //0   
    // wsp_ram.pamiec_RAM[1] = 16'b1000_0000_0000_0000;  //-32768
    // wsp_ram.pamiec_RAM[2] = 16'b0000000000000000;
    // f_ile_probek = 4; // ile probek
    // f_ile_razy = f_ile_wsp + f_ile_probek - 1;
    // probk_ram.pamiec_RAM[0] = 16'b0000_0011_1110_1000;  //1000
    // probk_ram.pamiec_RAM[1] = 16'b0000_0111_1101_0000;     //2000
    // probk_ram.pamiec_RAM[2] = 16'b0000_1011_1011_1000;    //3000
    // probk_ram.pamiec_RAM[3] = 16'b0000_1111_1010_0000;    //4000

    // wsp_ram.pamiec_RAM[3] = 16'b1111111111111111;
    // probk_ram.pamiec_RAM[4] = 16'hxxxx;

//5. usrednianie
    // f_ile_wsp = 2; //ile wsp
    // wsp_ram.pamiec_RAM[0] = 16'b0100_0000_0000_0000;  //16384  
    // wsp_ram.pamiec_RAM[1] = 16'b0100_0000_0000_0000;  //16384
    // wsp_ram.pamiec_RAM[2] = 16'b0000000000000000;
    // f_ile_probek = 4; // ile probek
    // f_ile_razy = f_ile_wsp + f_ile_probek - 1;
    // probk_ram.pamiec_RAM[0] = 16'b1111_1100_0001_1000;  //-1000
    // probk_ram.pamiec_RAM[1] = 16'b1111_1000_0011_0000;     //-2000
    // probk_ram.pamiec_RAM[2] = 16'b1111_0100_0100_1000;    //-3000
    // probk_ram.pamiec_RAM[3] = 16'b1111_0000_0110_0000;    //-4000

    // wsp_ram.pamiec_RAM[3] = 16'b1111111111111111;
    // probk_ram.pamiec_RAM[4] = 16'hxxxx;

//5 rozniczka
    // f_ile_wsp = 2; //ile wsp
    wsp_ram.pamiec_RAM[0] = 16'b0111_1111_1111_1111;  //32767
    wsp_ram.pamiec_RAM[1] = 16'b1000_0000_0000_0000;  //-32768
    wsp_ram.pamiec_RAM[2] = 16'b0000000000000000;
    // f_ile_probek = 5; // ile probek
    // f_ile_razy = f_ile_wsp + f_ile_probek - 1;
    probk_ram.pamiec_RAM[0] = 16'b0000_0011_1110_1000;  //1000
    probk_ram.pamiec_RAM[1] = 16'b0000_0111_1101_0000;     //2000
    probk_ram.pamiec_RAM[2] = 16'b0000_1011_1011_1000;    //3000
    probk_ram.pamiec_RAM[3] = 16'b0000_0111_1101_0000;   //2000
    probk_ram.pamiec_RAM[4] = 16'b0000_0011_1110_1000;   //1000

    wsp_ram.pamiec_RAM[3] = 16'b1111111111111111;
    probk_ram.pamiec_RAM[5] = 16'hxxxx;


//======================================================
    
    // f_ile_probek = 3; // ile probek
    rst_n = 0;
    // f_start = 0;
    CDC_data = 0;
    nr_Rejestru = 0;
    wr_Rej = 0;
    #10;
    rst_n = 1;
    #40;
    //ile wsp
    CDC_data = 2;
    nr_Rejestru = 3;
    wr_Rej = 1;
    #10;
    wr_Rej = 0;
    #10;
    //ile_probek
    CDC_data = 5;
    nr_Rejestru = 4;
    wr_Rej = 1;
    #10;
    wr_Rej = 0;
    #10;
    //start
    CDC_data = 1;
    nr_Rejestru = 0;
    wr_Rej = 1;
    #10;
    wr_Rej = 0;
    #10;


    #500;
    //ponowny start..
    CDC_data = 1;
    nr_Rejestru = 0;
    wr_Rej = 1;
    #10;
    wr_Rej = 0;
    #10;
// logic [15:0] CDC_data;
// logic [2:0]  nr_Rejestru;
// logic wr_Rej;

    // f_start = 1;
    // #10;
    // f_start = 1;

    #10;

    #500;
    $finish;
end

endmodule