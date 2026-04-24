library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity tb_control_logic is
end entity;

architecture sim of tb_control_logic is
  signal s_opcode   : std_logic_vector(6 downto 0);
  signal s_funct3   : std_logic_vector(2 downto 0);
  signal s_funct7   : std_logic_vector(6 downto 0);
  signal s_inst     : std_logic_vector(31 downto 0);
  signal s_regwrite : std_logic;
  signal s_memwrite : std_logic;
  signal s_alusrc   : std_logic;
  signal s_aluctrl  : std_logic_vector(3 downto 0);
  signal s_immtype  : std_logic_vector(2 downto 0);
  signal s_wbsel    : std_logic_vector(1 downto 0);
  signal s_branch   : std_logic;
  signal s_jump     : std_logic;
  signal s_jalr     : std_logic;
  signal s_halt     : std_logic;

  component control_unit is
    port(
      iOpcode   : in  std_logic_vector(6 downto 0);
      iFunct3   : in  std_logic_vector(2 downto 0);
      iFunct7   : in  std_logic_vector(6 downto 0);
      iInst     : in  std_logic_vector(31 downto 0);
      oRegWrite : out std_logic;
      oMemWrite : out std_logic;
      oALUSrc   : out std_logic;
      oALUCtrl  : out std_logic_vector(3 downto 0);
      oImmType  : out std_logic_vector(2 downto 0);
      oWBSel    : out std_logic_vector(1 downto 0);
      oBranch   : out std_logic;
      oJump     : out std_logic;
      oJalr     : out std_logic;
      oHalt     : out std_logic);
  end component;
begin
  DUT: control_unit
    port map(
      iOpcode   => s_opcode,
      iFunct3   => s_funct3,
      iFunct7   => s_funct7,
      iInst     => s_inst,
      oRegWrite => s_regwrite,
      oMemWrite => s_memwrite,
      oALUSrc   => s_alusrc,
      oALUCtrl  => s_aluctrl,
      oImmType  => s_immtype,
      oWBSel    => s_wbsel,
      oBranch   => s_branch,
      oJump     => s_jump,
      oJalr     => s_jalr,
      oHalt     => s_halt);

  process
  begin
    s_inst <= x"00000033";
    s_opcode <= "0110011";
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    wait for 10 ns;
    assert s_regwrite = '1' and s_aluctrl = ALU_ADD and s_wbsel = WB_ALU report "add decode failed" severity failure;

    s_opcode <= "0000011";
    s_funct3 <= "010";
    s_funct7 <= "0000000";
    wait for 10 ns;
    assert s_regwrite = '1' and s_alusrc = '1' and s_wbsel = WB_MEM report "lw decode failed" severity failure;

    s_inst <= x"10500073";
    s_opcode <= "1110011";
    s_funct3 <= "000";
    s_funct7 <= "0001000";
    wait for 10 ns;
    assert s_halt = '1' report "wfi decode failed" severity failure;
    wait;
  end process;
end architecture;
