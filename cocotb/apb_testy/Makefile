# Makefile dla testów cocotb APB

# Ścieżki
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# Katalogi
PWD=$(shell pwd)
SRC_DIR = $(PWD)/../../src

# Pliki SystemVerilog z katalogu src
VERILOG_SOURCES = $(SRC_DIR)/APB_main.sv
# Dodaj inne pliki jeśli potrzebne:
VERILOG_SOURCES += $(SRC_DIR)/apb.sv
VERILOG_SOURCES += $(SRC_DIR)/cdc.sv
VERILOG_SOURCES += $(SRC_DIR)/decoder.sv
VERILOG_SOURCES += $(SRC_DIR)/ram.sv
VERILOG_SOURCES += $(SRC_DIR)/rejestry_ster.sv
# VERILOG_SOURCES += $(SRC_DIR)/axi.sv

# Nazwa modułu top-level w SystemVerilog
TOPLEVEL = APB_main

# Nazwa modułu testowego Python (bez .py)
MODULE = apb_tb2

# Opcje kompilatora - flaga -g2012 dla SystemVerilog 2012
COMPILE_ARGS = -g2012
#COMPILE_ARGS += -timescale 1ns/1ps

# Opcje symulatora
SIM_ARGS = 

# Zmienne środowiska dla cocotb (VCD trace)
export COCOTB_TRACE ?= 1

# Opcje cocotb
COCOTB_RESULTS_FILE = results.xml
COCOTB_REDUCED_LOG_FMT = 1

# Include cocotb makefile
include $(shell cocotb-config --makefiles)/Makefile.sim

# Dodatkowe targety
.PHONY: clean_all wave

# Wyczyść wszystko włącznie z plikami waveform
clean_all: clean
	rm -f *.vcd *.fst *.ghw

# Otwórz waveform w GTKWave (jeśli istnieje)
wave:
	@if [ -f dump.vcd ]; then \
		gtkwave dump.vcd; \
	elif [ -f dump.fst ]; then \
		gtkwave dump.fst; \
	else \
		echo "Brak pliku waveform. Uruchom najpierw symulację."; \
	fi