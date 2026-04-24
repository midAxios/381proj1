library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity tb_alu_shifter is
end entity;

architecture sim of tb_alu_shifter is
  signal s_a      : std_logic_vector(31 downto 0);
  signal s_b      : std_logic_vector(31 downto 0);
  signal s_shamt  : std_logic_vector(4 downto 0);
  signal s_ctrl   : std_logic_vector(3 downto 0);
  signal s_result : std_logic_vector(31 downto 0);
  signal s_zero   : std_logic;

  component alu32 is
    port(
      iA       : in  std_logic_vector(31 downto 0);
      iB       : in  std_logic_vector(31 downto 0);
      iShamt   : in  std_logic_vector(4 downto 0);
      iALUCtrl : in  std_logic_vector(3 downto 0);
      oResult  : out std_logic_vector(31 downto 0);
      oZero    : out std_logic);
  end component;
begin
  DUT: alu32
    port map(
      iA       => s_a,
      iB       => s_b,
      iShamt   => s_shamt,
      iALUCtrl => s_ctrl,
      oResult  => s_result,
      oZero    => s_zero);

  process
  begin
    s_a <= x"00000005";
    s_b <= x"00000003";
    s_shamt <= "00000";
    s_ctrl <= ALU_ADD;
    wait for 10 ns;
    assert s_result = x"00000008" report "ADD failed" severity failure;

    s_a <= x"80000000";
    s_shamt <= "00100";
    s_ctrl <= ALU_SRL;
    wait for 10 ns;
    assert s_result = x"08000000" report "SRL failed" severity failure;

    s_ctrl <= ALU_SRA;
    wait for 10 ns;
    assert s_result = x"F8000000" report "SRA failed" severity failure;

    s_a <= x"00000001";
    s_shamt <= "00101";
    s_ctrl <= ALU_SLL;
    wait for 10 ns;
    assert s_result = x"00000020" report "SLL failed" severity failure;
    wait;
  end process;
end architecture;
