import sys
import os
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0,PROJECT_ROOT)

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import random

from modelFIR.model_fir import fir_hw_model

##################################################################
# make SIM=icarus WAVES=1 TESTCASE=top_test_1

##################################################################

def to_signed_16bit(obj):
    raw = int(obj.value) 
    if raw > 32767:
        return raw - 65536
    return raw

@cocotb.test()
async def top_test_1(dut):
    # TEST 1
    # 
    # 1.zapis probek AXI
    # 1.1. odczyt probek AXI
    # 2. zapis wsp APB
    # 3. zapis do rej ster APB (bez start)
    # 3.1. odczyt wsp + rej APB
    # 4. zapis start APB
    # 5. FIR liczy
    # 6. odczyt DONE APB
    # 7. odczyt probek wyn AXI
    # 8. porowanie z modelemFIR.
#==============================================================================

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())




    # assert y == wyn, f"Odczytany wynik {wyn} != oczekiwana {y}"
    pass

@cocotb.test()
async def top_test_2(dut):
    # TEST 2
    # 
    # To samo co w TEST 1 ale dwa razy... czyli jak raz sie zrobi to zmiana wsp/probek i odpalenie.
#==============================================================================

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())




    # assert y == wyn, f"Odczytany wynik {wyn} != oczekiwana {y}"
    pass