library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity tb_alu_shifter is
end entity tb_alu_shifter;

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

  DUT : alu32
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

    -------------------------------------------------------------------------
    -- ADD
    -------------------------------------------------------------------------
    s_a     <= x"00000005";
    s_b     <= x"00000003";
    s_shamt <= "00000";
    s_ctrl  <= ALU_ADD;
    wait for 10 ns;
    assert s_result = x"00000008"
      report "ADD failed: 5 + 3 should be 8"
      severity failure;

    -------------------------------------------------------------------------
    -- SUB
    -------------------------------------------------------------------------
    s_a    <= x"00000005";
    s_b    <= x"00000003";
    s_ctrl <= ALU_SUB;
    wait for 10 ns;
    assert s_result = x"00000002"
      report "SUB failed: 5 - 3 should be 2"
      severity failure;

    -------------------------------------------------------------------------
    -- SUB that creates zero
    -------------------------------------------------------------------------
    s_a    <= x"00000003";
    s_b    <= x"00000003";
    s_ctrl <= ALU_SUB;
    wait for 10 ns;
    assert s_result = x"00000000"
      report "SUB zero-result failed"
      severity failure;
    assert s_zero = '1'
      report "Zero flag failed: result was zero but oZero was not 1"
      severity failure;

    -------------------------------------------------------------------------
    -- AND
    -------------------------------------------------------------------------
    s_a    <= x"F0F0FF00";
    s_b    <= x"0FF00FF0";
    s_ctrl <= ALU_AND;
    wait for 10 ns;
    assert s_result = x"00F00F00"
      report "AND failed"
      severity failure;

    -------------------------------------------------------------------------
    -- OR
    -------------------------------------------------------------------------
    s_a    <= x"F0F0FF00";
    s_b    <= x"0FF00FF0";
    s_ctrl <= ALU_OR;
    wait for 10 ns;
    assert s_result = x"FFF0FFF0"
      report "OR failed"
      severity failure;

    -------------------------------------------------------------------------
    -- XOR
    -------------------------------------------------------------------------
    s_a    <= x"F0F0FF00";
    s_b    <= x"0FF00FF0";
    s_ctrl <= ALU_XOR;
    wait for 10 ns;
    assert s_result = x"FF00F0F0"
      report "XOR failed"
      severity failure;

    -------------------------------------------------------------------------
    -- NOR
    -------------------------------------------------------------------------
    s_a    <= x"F0F0FF00";
    s_b    <= x"0FF00FF0";
    s_ctrl <= ALU_NOR;
    wait for 10 ns;
    assert s_result = x"000F000F"
      report "NOR failed"
      severity failure;

    -------------------------------------------------------------------------
    -- Signed SLT: -1 < 1 should be true
    -------------------------------------------------------------------------
    s_a    <= x"FFFFFFFF";
    s_b    <= x"00000001";
    s_ctrl <= ALU_SLT;
    wait for 10 ns;
    assert s_result = x"00000001"
      report "Signed SLT failed: -1 < 1 should be true"
      severity failure;

    -------------------------------------------------------------------------
    -- Signed SLT: 7 < -8 should be false
    -------------------------------------------------------------------------
    s_a    <= x"00000007";
    s_b    <= x"FFFFFFF8";
    s_ctrl <= ALU_SLT;
    wait for 10 ns;
    assert s_result = x"00000000"
      report "Signed SLT failed: 7 < -8 should be false"
      severity failure;

    -------------------------------------------------------------------------
    -- Unsigned SLTU: 0xFFFFFFFF < 1 should be false
    -------------------------------------------------------------------------
    s_a    <= x"FFFFFFFF";
    s_b    <= x"00000001";
    s_ctrl <= ALU_SLTU;
    wait for 10 ns;
    assert s_result = x"00000000"
      report "Unsigned SLTU failed: 0xFFFFFFFF < 1 should be false"
      severity failure;

    -------------------------------------------------------------------------
    -- Unsigned SLTU: 1 < 0xFFFFFFFF should be true
    -------------------------------------------------------------------------
    s_a    <= x"00000001";
    s_b    <= x"FFFFFFFF";
    s_ctrl <= ALU_SLTU;
    wait for 10 ns;
    assert s_result = x"00000001"
      report "Unsigned SLTU failed: 1 < 0xFFFFFFFF should be true"
      severity failure;

    -------------------------------------------------------------------------
    -- SLL: 1 << 5 = 32
    -- Shift amount is intentionally placed in iB(4 downto 0).
    -------------------------------------------------------------------------
    s_a    <= x"00000001";
    s_b    <= x"00000005";
    s_ctrl <= ALU_SLL;
    wait for 10 ns;
    assert s_result = x"00000020"
      report "SLL failed: 1 << 5 should be 0x20"
      severity failure;

    -------------------------------------------------------------------------
    -- SLL edge: 1 << 31 = 0x80000000
    -------------------------------------------------------------------------
    s_a    <= x"00000001";
    s_b    <= x"0000001F";
    s_ctrl <= ALU_SLL;
    wait for 10 ns;
    assert s_result = x"80000000"
      report "SLL failed: 1 << 31 should be 0x80000000"
      severity failure;

    -------------------------------------------------------------------------
    -- SRL: 0x80000000 >> 4 = 0x08000000
    -------------------------------------------------------------------------
    s_a    <= x"80000000";
    s_b    <= x"00000004";
    s_ctrl <= ALU_SRL;
    wait for 10 ns;
    assert s_result = x"08000000"
      report "SRL failed"
      severity failure;

    -------------------------------------------------------------------------
    -- SRL edge: 0x80000000 >> 31 = 1
    -------------------------------------------------------------------------
    s_a    <= x"80000000";
    s_b    <= x"0000001F";
    s_ctrl <= ALU_SRL;
    wait for 10 ns;
    assert s_result = x"00000001"
      report "SRL failed: 0x80000000 >> 31 should be 1"
      severity failure;

    -------------------------------------------------------------------------
    -- SRA negative: 0x80000000 >>> 4 = 0xF8000000
    -------------------------------------------------------------------------
    s_a    <= x"80000000";
    s_b    <= x"00000004";
    s_ctrl <= ALU_SRA;
    wait for 10 ns;
    assert s_result = x"F8000000"
      report "SRA failed for negative value"
      severity failure;

    -------------------------------------------------------------------------
    -- SRA positive: 0x70000000 >>> 4 = 0x07000000
    -------------------------------------------------------------------------
    s_a    <= x"70000000";
    s_b    <= x"00000004";
    s_ctrl <= ALU_SRA;
    wait for 10 ns;
    assert s_result = x"07000000"
      report "SRA failed for positive value"
      severity failure;

    -------------------------------------------------------------------------
    -- SRA edge: 0x80000000 >>> 31 = 0xFFFFFFFF
    -------------------------------------------------------------------------
    s_a    <= x"80000000";
    s_b    <= x"0000001F";
    s_ctrl <= ALU_SRA;
    wait for 10 ns;
    assert s_result = x"FFFFFFFF"
      report "SRA failed: sign extension edge case failed"
      severity failure;

    -------------------------------------------------------------------------
    -- PASS, used for LUI-style datapath behavior
    -------------------------------------------------------------------------
    s_a    <= x"12345678";
    s_b    <= x"DEADBEEF";
    s_ctrl <= ALU_PASS;
    wait for 10 ns;
    assert s_result = x"DEADBEEF"
      report "PASS failed"
      severity failure;

    report "All ALU tests passed." severity note;

    wait;
  end process;

end architecture sim;