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
      oZero    : out std_logic
    );
  end component;

begin

  DUT: alu32
    port map(
      iA       => s_a,
      iB       => s_b,
      iShamt   => s_shamt,
      iALUCtrl => s_ctrl,
      oResult  => s_result,
      oZero    => s_zero
    );

  process
  begin

    s_shamt <= "00000";

    -- ADD
    s_a <= x"00000005";
    s_b <= x"00000003";
    s_ctrl <= ALU_ADD;
    wait for 10 ns;
    assert s_result = x"00000008" report "ADD failed" severity failure;

    -- SUB
    s_a <= x"00000005";
    s_b <= x"00000003";
    s_ctrl <= ALU_SUB;
    wait for 10 ns;
    assert s_result = x"00000002" report "SUB failed" severity failure;

    -- ZERO flag
    s_a <= x"00000003";
    s_b <= x"00000003";
    s_ctrl <= ALU_SUB;
    wait for 10 ns;
    assert s_result = x"00000000" report "SUB zero failed" severity failure;
    assert s_zero = '1' report "ZERO flag failed" severity failure;

    -- AND
    s_a <= x"F0F0FF00";
    s_b <= x"0FF00FF0";
    s_ctrl <= ALU_AND;
    wait for 10 ns;
    assert s_result = x"00F00F00" report "AND failed" severity failure;

    -- OR
    s_a <= x"F0F0FF00";
    s_b <= x"0FF00FF0";
    s_ctrl <= ALU_OR;
    wait for 10 ns;
    assert s_result = x"FFF0FFF0" report "OR failed" severity failure;

    -- XOR
    s_a <= x"F0F0FF00";
    s_b <= x"0FF00FF0";
    s_ctrl <= ALU_XOR;
    wait for 10 ns;
    assert s_result = x"FF00F0F0" report "XOR failed" severity failure;

    -- NOR
    s_a <= x"F0F0FF00";
    s_b <= x"0FF00FF0";
    s_ctrl <= ALU_NOR;
    wait for 10 ns;
    assert s_result = x"000F000F" report "NOR failed" severity failure;

    -- SLT signed: -1 < 1
    s_a <= x"FFFFFFFF";
    s_b <= x"00000001";
    s_ctrl <= ALU_SLT;
    wait for 10 ns;
    assert s_result = x"00000001" report "SLT signed failed" severity failure;

    -- SLTU unsigned: 0xFFFFFFFF < 1 should be false
    s_a <= x"FFFFFFFF";
    s_b <= x"00000001";
    s_ctrl <= ALU_SLTU;
    wait for 10 ns;
    assert s_result = x"00000000" report "SLTU unsigned failed" severity failure;

    -- SLL, shift amount goes in iB[4:0]
    s_a <= x"00000001";
    s_b <= x"00000005";
    s_ctrl <= ALU_SLL;
    wait for 10 ns;
    assert s_result = x"00000020" report "SLL failed" severity failure;

    -- SLL edge
    s_a <= x"00000001";
    s_b <= x"0000001F";
    s_ctrl <= ALU_SLL;
    wait for 10 ns;
    assert s_result = x"80000000" report "SLL edge failed" severity failure;

    -- SRL
    s_a <= x"80000000";
    s_b <= x"00000004";
    s_ctrl <= ALU_SRL;
    wait for 10 ns;
    assert s_result = x"08000000" report "SRL failed" severity failure;

    -- SRL edge
    s_a <= x"80000000";
    s_b <= x"0000001F";
    s_ctrl <= ALU_SRL;
    wait for 10 ns;
    assert s_result = x"00000001" report "SRL edge failed" severity failure;

    -- SRA negative
    s_a <= x"80000000";
    s_b <= x"00000004";
    s_ctrl <= ALU_SRA;
    wait for 10 ns;
    assert s_result = x"F8000000" report "SRA negative failed" severity failure;

    -- SRA positive
    s_a <= x"70000000";
    s_b <= x"00000004";
    s_ctrl <= ALU_SRA;
    wait for 10 ns;
    assert s_result = x"07000000" report "SRA positive failed" severity failure;

    -- PASS, useful for LUI behavior
    s_a <= x"12345678";
    s_b <= x"DEADBEEF";
    s_ctrl <= ALU_PASS;
    wait for 10 ns;
    assert s_result = x"DEADBEEF" report "PASS failed" severity failure;

    report "All ALU tests passed." severity note;
    wait;

  end process;

end architecture sim;