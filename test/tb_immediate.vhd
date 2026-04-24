library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity tb_immediate is
end entity;

architecture sim of tb_immediate is
  signal s_inst : std_logic_vector(31 downto 0);
  signal s_type : std_logic_vector(2 downto 0);
  signal s_imm  : std_logic_vector(31 downto 0);

  component imm_gen is
    port(
      iInst    : in  std_logic_vector(31 downto 0);
      iImmType : in  std_logic_vector(2 downto 0);
      oImm     : out std_logic_vector(31 downto 0));
  end component;
begin
  DUT: imm_gen
    port map(
      iInst    => s_inst,
      iImmType => s_type,
      oImm     => s_imm);

  process
  begin
    s_inst <= x"FFF00093";
    s_type <= IMM_I;
    wait for 10 ns;
    assert s_imm = x"FFFFFFFF" report "I immediate sign extension failed" severity failure;

    s_inst <= x"FE000CE3";
    s_type <= IMM_B;
    wait for 10 ns;
    assert s_imm(0) = '0' and s_imm(31) = '1' report "B immediate sign/shift failed" severity failure;

    s_inst <= x"123450B7";
    s_type <= IMM_U;
    wait for 10 ns;
    assert s_imm = x"12345000" report "U immediate failed" severity failure;
    wait;
  end process;
end architecture;
