////////////////////////////////////////////////////////////////////////
//   AXI
//
//  szerokosci max narazie, bez dostosowywania
///////////////////////////////////////////////////////////////////////

module axi#(
    parameter data_out_SIZE = 16, //rozm. danych do RAM wej.
    parameter address_out_SIZE = 13, //rozm. adresu do RAM wej.
    parameter data_in_SIZE = 21, //rozm. danych z RAM wyj.
    parameter address_out2_SIZE = 13 //rozm. adresu do RAM wyj.
)(
    //zegar i reset
    input wire a_clk,
    input wire a_rst_n,

    //Kanal zapisu - adres
    input wire [31:0] awaddr,
    input wire awvalid,
    output logic awready,
    input wire [3:0] awlen,//[7:0]
    input wire [2:0] awsize,
    input wire [1:0] awburst,

    //Kanal zapisu - data
    input wire wvalid,
    output logic wready,
    input wire wlast,
    input wire [63:0] wdata,
    input wire [7:0] wstrb,

    //Kanal zapisu - odpowiedz
    output logic bvalid,
    input wire bready,
    output logic [1:0] bresp,

    //Kanal odczytu - adres
    input wire arvalid,
    output logic arready,
    input wire [31:0] araddr,
    input wire [2:0] arsize,
    input wire [1:0] arburst,
    input wire [3:0] arlen,//[7:0]

    //Kanal odczytu - data
    output logic rvalid,
    input wire rready,
    output logic rlast,
    output logic [63:0] rdata,
    output logic [1:0] rresp,

    //Reszta
    //RAM wej
    output logic [address_out_SIZE-1:0] a_address_wr,
    output logic [data_out_SIZE-1:0] a_data_out,
    output logic a_wr,
    input wire [data_out_SIZE-1:0] probka,
    //RAM wyj
    output logic [address_out2_SIZE-1:0] a_address_rd,
    input wire [data_in_SIZE-1:0] a_data_in
);


//handshake dla kazdego kanalu

//kanaly

//burst

endmodule