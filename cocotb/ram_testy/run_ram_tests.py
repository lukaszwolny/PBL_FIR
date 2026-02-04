import os
from pathlib import Path

from cocotb_test.simulator import run


def main() -> None:
    repo_root = Path(__file__).resolve().parents[2]
    verilog_sources = [str(repo_root / "src" / "ram.sv")]

    waves = os.getenv("WAVES", "0") not in ("0", "", "false", "False")

    run(
        simulator="icarus",
        verilog_sources=verilog_sources,
        toplevel="ram",
        module="test_ram",
        sim_build=str(Path(__file__).with_name("sim_build")),
        iverilog_args=["-g2012"],
        waves=waves,
        extra_env={
            # Keep output readable in CI/terminal
            "COCOTB_LOG_LEVEL": os.getenv("COCOTB_LOG_LEVEL", "INFO"),
        },
    )


if __name__ == "__main__":
    main()
