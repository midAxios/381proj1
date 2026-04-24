library IEEE;
use IEEE.std_logic_1164.all;

package RISCV_types is
  constant DATA_WIDTH : integer := 32;
  constant ADDR_WIDTH : integer := 10;

  constant ALU_ADD  : std_logic_vector(3 downto 0) := "0000";
  constant ALU_SUB  : std_logic_vector(3 downto 0) := "0001";
  constant ALU_AND  : std_logic_vector(3 downto 0) := "0010";
  constant ALU_OR   : std_logic_vector(3 downto 0) := "0011";
  constant ALU_XOR  : std_logic_vector(3 downto 0) := "0100";
  constant ALU_SLL  : std_logic_vector(3 downto 0) := "0101";
  constant ALU_SRL  : std_logic_vector(3 downto 0) := "0110";
  constant ALU_SRA  : std_logic_vector(3 downto 0) := "0111";
  constant ALU_SLT  : std_logic_vector(3 downto 0) := "1000";
  constant ALU_SLTU : std_logic_vector(3 downto 0) := "1001";
  constant ALU_PASS : std_logic_vector(3 downto 0) := "1010";

  constant WB_ALU  : std_logic_vector(1 downto 0) := "00";
  constant WB_MEM  : std_logic_vector(1 downto 0) := "01";
  constant WB_PC4  : std_logic_vector(1 downto 0) := "10";

  constant IMM_I : std_logic_vector(2 downto 0) := "000";
  constant IMM_S : std_logic_vector(2 downto 0) := "001";
  constant IMM_B : std_logic_vector(2 downto 0) := "010";
  constant IMM_U : std_logic_vector(2 downto 0) := "011";
  constant IMM_J : std_logic_vector(2 downto 0) := "100";
end package RISCV_types;

package body RISCV_types is
end package body RISCV_types;
