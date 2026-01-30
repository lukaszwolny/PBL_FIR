
module shift_tb;

logic clk;
logic rst_n;
logic [15:0] probka_in;
logic [15:0] out;
logic nowa_shift;
logic reset_shift;
logic [4:0] adres;
logic [13:0] ile_probek;

shift_R dut(
    .*
);

initial clk = 1;
always #5 clk=~clk;

initial begin
    $dumpfile("shift_tb.vcd");
    $dumpvars(0, shift_tb);
end
integer i;
initial begin
    ile_probek = 0;
    adres = 0;
    rst_n = 0;
    reset_shift = 0;
    nowa_shift = 0;
    #10;
    ile_probek = 8192; //32
    rst_n = 1;
    reset_shift = 1;
    probka_in = 5;
    #10;
    reset_shift = 0;
    #10;
    //32 probki w ram 0..31
    //32 wsp
    //8192 + 32 - 1. 8223 razy
    for(i = 1;i<=8224;i++) begin
            probka_in = i*2;
            nowa_shift = 1;
            #10;
    end
    for(i = 0;i<=31;i++) begin
        adres = i;
        nowa_shift = 0;
        #10;
    end


    // nowa_shift = 1;
    // #10;
    // nowa_shift = 0;
    // #10;
    // adres = 0;
    // #10;
    // adres = 1;
    // #10;
    // adres = 2;
    // #10;
    // probka_in = 10;
    // nowa_shift = 1;
    // #10;
    // nowa_shift = 0;
    // #10;
    // adres = 0;
    // #10;
    // adres = 1;
    // #10;
    // adres = 2;
    // #10;
    // for(i = 0;i<=31;i++) begin
    //         probka_in = i*2;
    //         nowa_shift = 1;
    //         #10;
    // end
    // for(i = 0;i<=31;i++) begin
    //     adres = i;
    //     nowa_shift = 0;
    //     #10;
    // end


    #500;
    $finish;

end

endmodule