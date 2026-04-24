library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.RISCV_types.all;

entity imm_gen is
  port(
    iInst    : in  std_logic_vector(31 downto 0);
    iImmType : in  std_logic_vector(2 downto 0);
    oImm     : out std_logic_vector(31 downto 0));
end entity imm_gen;

architecture dataflow of imm_gen is
  signal s_i : std_logic_vector(31 downto 0);
  signal s_s : std_logic_vector(31 downto 0);
  signal s_b : std_logic_vector(31 downto 0);
  signal s_u : std_logic_vector(31 downto 0);
  signal s_j : std_logic_vector(31 downto 0);
begin
  s_i <= std_logic_vector(resize(signed(iInst(31 downto 20)), 32));
  s_s <= std_logic_vector(resize(signed(iInst(31 downto 25) & iInst(11 downto 7)), 32));
  s_b <= std_logic_vector(resize(signed(iInst(31) & iInst(7) & iInst(30 downto 25) & iInst(11 downto 8) & '0'), 32));
  s_u <= iInst(31 downto 12) & x"000";
  s_j <= std_logic_vector(resize(signed(iInst(31) & iInst(19 downto 12) & iInst(20) & iInst(30 downto 21) & '0'), 32));

  with iImmType select
    oImm <= s_s when IMM_S,
            s_b when IMM_B,
            s_u when IMM_U,
            s_j when IMM_J,
            s_i when others;
end architecture dataflow;
