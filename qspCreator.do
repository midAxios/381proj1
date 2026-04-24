#!/bin/bash

# Run this script from inside the proj folder.
# It checks for VHDL files in ./src, compiles them, then optionally compiles ./test.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m'

if [ ! -d "src" ]; then
    echo -e "${RED}Error: src folder not found.${NC}"
    echo "Run this script from inside your proj folder."
    exit 1
fi

if ! find src -name "*.vhd" | grep -q .; then
    echo -e "${RED}Error: no .vhd files found inside src/.${NC}"
    exit 1
fi

echo -e "${GREEN}Found VHDL source files in src/.${NC}"

if [ -d "work" ]; then
    echo -e "${ORANGE}Removing old Questa work library...${NC}"
    rm -rf work
fi

echo -e "${GREEN}Creating work library...${NC}"
vlib work

echo -e "${GREEN}Compiling source files from src/...${NC}"

# Compile package/type files first if they exist.
if [ -f "src/RISCV_types.vhd" ]; then
    vcom -2008 src/RISCV_types.vhd
fi

# Compile all other source files.
find src -name "*.vhd" ! -name "RISCV_types.vhd" | sort | while read file; do
    echo "Compiling $file"
    vcom -2008 "$file"
done

# Compile testbench files if the folder exists and has .vhd files.
if [ -d "test" ] && find test -name "*.vhd" | grep -q .; then
    echo -e "${GREEN}Compiling testbench files from test/...${NC}"
    find test -name "*.vhd" | sort | while read file; do
        echo "Compiling $file"
        vcom -2008 "$file"
    done
else
    echo -e "${ORANGE}No testbench .vhd files found in test/. Skipping testbench compile.${NC}"
fi

echo -e "${GREEN}Compile finished successfully.${NC}"

if [ -n "$1" ]; then
    echo -e "${GREEN}Starting simulation for: $1${NC}"
    vsim work."$1"
else
    echo -e "${ORANGE}No testbench entity given.${NC}"
    echo "Example:"
    echo "  ./run_questa.sh tb_alu_shifter"
fi