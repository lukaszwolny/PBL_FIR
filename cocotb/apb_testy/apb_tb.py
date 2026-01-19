import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from apb_master import APBMaster

import random
from cocotb.triggers import Timer


@cocotb.test()
async def apb_basic_write_test(dut):
    # Clock 100 MHz
    cocotb.start_soon(Clock(dut.PCLK, 10, units="ns").start())

    apb = APBMaster(dut)

    # Reset
    dut.PRESETn.value = 0
    dut.PSELx.value   = 0
    dut.PENABLE.value = 0
    dut.PWRITE.value  = 0
    dut.PADDR.value   = 0
    dut.PWDATA.value  = 0

    for _ in range(5):
        await RisingEdge(dut.PCLK)

    dut.PRESETn.value = 1
    await RisingEdge(dut.PCLK)

    # -----------------------------
    # WRITE
    # -----------------------------

    # losowy adres 6-bitow, PADDR[7:2]
    random_adr = random.randint(0, 63)
    adr = random_adr # przesun na odpowiednie bity w PADDR

    #losowe dane 16-bitow
    random_value = random.randint(0x0000, 0xFFFF)

    await apb.write(adr, random_value)

    # sprawdź sygnały wewnętrzne modułu apb.sv
    
    await Timer(1, "ns") # #czekaj na ustabilizowanie się sygnałów po cyklu zapisu (Opóźnienie 1ns (jak #1 w Verilog))
    assert dut.p_wr.value == 1
    dut._log.info(f"p_address: {dut.p_address.value}, expected: {random_adr}")
    assert dut.p_address.value == adr
    assert dut.p_data.value == random_value

    await RisingEdge(dut.PCLK)

    await Timer(1, "ns")
    assert dut.p_wr.value == 0 #impuls zapisu powinien się wyzerować
    assert dut.p_address.value == adr
    assert dut.p_data.value == random_value

@cocotb.test()
async def apb_basic_read_test(dut):
    # Clock 100 MHz
    cocotb.start_soon(Clock(dut.PCLK, 10, units="ns").start())

    apb = APBMaster(dut)

    # Reset
    dut.PRESETn.value = 0
    dut.PSELx.value   = 0
    dut.PENABLE.value = 0
    dut.PWRITE.value  = 0
    dut.PADDR.value   = 0
    dut.PWDATA.value  = 0

    for _ in range(5):
        await RisingEdge(dut.PCLK)

    # Wygeneruj losową wartość 16-bitową
    random_value = random.randint(0x0000, 0xFFFF)

     # Symulujemy peryferium
    dut.p_data_back.value = random_value

    dut.PRESETn.value = 1
    await RisingEdge(dut.PCLK)

    # -----------------------------
    # READ
    # -----------------------------
   
    data = await apb.read(0x00) #adres dowolny bo i tak ręcznie wpisujemy wartość do p_data_back

    assert (data & 0xFFFF) == random_value, f"Read data {data:#06x} does not match expected {random_value:#06x}"

    # -----------------------------
    # Back-to-back write
    # -----------------------------
    # await apb.write(0x04, 0x1234)
    # await apb.write(0x08, 0x5678)
