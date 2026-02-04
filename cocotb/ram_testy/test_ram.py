import os
import random

import cocotb
from cocotb.clock import Clock
from cocotb.regression import TestFactory
from cocotb.triggers import RisingEdge, Timer


def _bits(signal) -> int:
    # cocotb handle has __len__ for packed vectors
    return len(signal)


def _mask(width: int) -> int:
    return (1 << width) - 1


async def ram_random_rw(dut, clk_period_ns: int = 10, n_ops: int = 500, seed: int | None = None):
    """Randomized synchronous RAM write/read test.

    RAM behavior (per ram.sv):
    - On posedge: if wr==1 -> write mem[adres] <= data
    - Else -> data_out <= mem[adres]

    The test first initializes the full memory with known values,
    then performs randomized read/write operations and checks readbacks.
    """

    addr_width = _bits(dut.adres)
    data_width = _bits(dut.data)
    depth = 1 << addr_width

    if seed is None:
        seed_env = os.getenv("SEED")
        if seed_env is not None:
            seed = int(seed_env, 0)
        else:
            seed = random.randrange(0, 2**32)

    n_ops_env = os.getenv("N_OPS")
    if n_ops_env is not None:
        n_ops = int(n_ops_env, 0)

    clk_period_env = os.getenv("CLK_PERIOD_NS")
    if clk_period_env is not None:
        clk_period_ns = int(clk_period_env, 0)

    random.seed(seed)
    dut._log.info(
        f"RAM random R/W: addr_width={addr_width} depth={depth} data_width={data_width} "
        f"clk_period={clk_period_ns}ns n_ops={n_ops} seed={seed}"
    )

    cocotb.start_soon(Clock(dut.clk, clk_period_ns, unit="ns").start())

    dut.wr.value = 0
    dut.adres.value = 0
    dut.data.value = 0

    # Initialize memory to avoid X-propagation reads.
    model = [random.getrandbits(data_width) for _ in range(depth)]
    for address in range(depth):
        dut.wr.value = 1
        dut.adres.value = address
        dut.data.value = model[address]
        await RisingEdge(dut.clk)

    # Random ops: mixed read/write
    dut.wr.value = 0
    for _ in range(n_ops):
        do_write = random.random() < 0.45
        address = random.randrange(depth)

        if do_write:
            value = random.getrandbits(data_width)
            model[address] = value
            dut.wr.value = 1
            dut.adres.value = address
            dut.data.value = value
            await RisingEdge(dut.clk)
        else:
            dut.wr.value = 0
            dut.adres.value = address
            await RisingEdge(dut.clk)
            await Timer(1, unit="ps")
            got = int(dut.data_out.value) & _mask(data_width)
            exp = model[address] & _mask(data_width)
            assert got == exp, (
                f"Read mismatch at address {address}: got 0x{got:0{(data_width + 3)//4}x} "
                f"exp 0x{exp:0{(data_width + 3)//4}x}"
            )

    # Targeted read-after-write sanity
    for _ in range(25):
        address = random.randrange(depth)
        value = random.getrandbits(data_width)
        model[address] = value

        dut.wr.value = 1
        dut.adres.value = address
        dut.data.value = value
        await RisingEdge(dut.clk)

        dut.wr.value = 0
        dut.adres.value = address
        await RisingEdge(dut.clk)
        await Timer(1, unit="ps")
        got = int(dut.data_out.value) & _mask(data_width)
        exp = model[address] & _mask(data_width)
        assert got == exp, f"RAW mismatch at address {address}: got={got} exp={exp}"


# Generate the same randomized test for multiple clock frequencies.
# You can still override with env vars (CLK_PERIOD_NS/SEED/N_OPS) when running a single test.
factory = TestFactory(ram_random_rw)
factory.add_option("clk_period_ns", [5, 10, 17, 25])
factory.add_option("n_ops", [300])
factory.generate_tests()
