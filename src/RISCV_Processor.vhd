library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.RISCV_types.all;

entity RISCV_Processor is
  generic(N : integer := DATA_WIDTH);
  port(
    iCLK      : in  std_logic;
    iRST      : in  std_logic;
    iInstLd   : in  std_logic;
    iInstAddr : in  std_logic_vector(N-1 downto 0);
    iInstExt  : in  std_logic_vector(N-1 downto 0);
    oALUOut   : out std_logic_vector(N-1 downto 0));
end entity RISCV_Processor;

architecture structure of RISCV_Processor is
  signal s_DMemWr   : std_logic;
  signal s_DMemAddr : std_logic_vector(N-1 downto 0);
  signal s_DMemData : std_logic_vector(N-1 downto 0);
  signal s_DMemOut  : std_logic_vector(N-1 downto 0);

  signal s_RegWr     : std_logic;
  signal s_RegWrAddr : std_logic_vector(4 downto 0);
  signal s_RegWrData : std_logic_vector(N-1 downto 0);

  signal s_IMemAddr : std_logic_vector(N-1 downto 0);
  signal s_PC       : std_logic_vector(N-1 downto 0);
  signal s_Inst     : std_logic_vector(N-1 downto 0);
  signal s_Halt     : std_logic;
  signal s_Ovfl     : std_logic;

  signal s_PCPlus4      : std_logic_vector(31 downto 0);
  signal s_NextPC       : std_logic_vector(31 downto 0);
  signal s_Imm          : std_logic_vector(31 downto 0);
  signal s_ReadData1    : std_logic_vector(31 downto 0);
  signal s_ReadData2    : std_logic_vector(31 downto 0);
  signal s_ALUInA       : std_logic_vector(31 downto 0);
  signal s_ALUInB       : std_logic_vector(31 downto 0);
  signal s_ALUOut       : std_logic_vector(31 downto 0);
  signal s_LoadData     : std_logic_vector(31 downto 0);
  signal s_BranchTaken  : std_logic;
  signal s_ALUZero      : std_logic;
  signal s_BranchTarget : std_logic_vector(31 downto 0);
  signal s_JalrTarget   : std_logic_vector(31 downto 0);

  signal s_ALUSrc  : std_logic;
  signal s_ALUCtrl : std_logic_vector(3 downto 0);
  signal s_ImmType : std_logic_vector(2 downto 0);
  signal s_WBSel   : std_logic_vector(1 downto 0);
  signal s_Branch  : std_logic;
  signal s_Jump    : std_logic;
  signal s_Jalr    : std_logic;

  component mem is
    generic(
      ADDR_WIDTH : integer := 10;
      DATA_WIDTH : integer := 32);
    port(
      clk  : in  std_logic;
      addr : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
      data : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      we   : in  std_logic := '1';
      q    : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;

  component pc_reg is
    port(
      iCLK    : in  std_logic;
      iRST    : in  std_logic;
      iHold   : in  std_logic;
      iNextPC : in  std_logic_vector(31 downto 0);
      oPC     : out std_logic_vector(31 downto 0));
  end component;

  component reg_file is
    port(
      iCLK       : in  std_logic;
      iRST       : in  std_logic;
      iRegWrite  : in  std_logic;
      iReadAddr1 : in  std_logic_vector(4 downto 0);
      iReadAddr2 : in  std_logic_vector(4 downto 0);
      iWriteAddr : in  std_logic_vector(4 downto 0);
      iWriteData : in  std_logic_vector(31 downto 0);
      oReadData1 : out std_logic_vector(31 downto 0);
      oReadData2 : out std_logic_vector(31 downto 0));
  end component;

  component imm_gen is
    port(
      iInst    : in  std_logic_vector(31 downto 0);
      iImmType : in  std_logic_vector(2 downto 0);
      oImm     : out std_logic_vector(31 downto 0));
  end component;

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

  component alu32 is
    port(
      iA       : in  std_logic_vector(31 downto 0);
      iB       : in  std_logic_vector(31 downto 0);
      iShamt   : in  std_logic_vector(4 downto 0);
      iALUCtrl : in  std_logic_vector(3 downto 0);
      oResult  : out std_logic_vector(31 downto 0);
      oZero    : out std_logic);
  end component;

  component branch_unit is
    port(
      iA      : in  std_logic_vector(31 downto 0);
      iB      : in  std_logic_vector(31 downto 0);
      iFunct3 : in  std_logic_vector(2 downto 0);
      oTake   : out std_logic);
  end component;

  component load_unit is
    port(
      iMemData : in  std_logic_vector(31 downto 0);
      iAddr    : in  std_logic_vector(1 downto 0);
      iFunct3  : in  std_logic_vector(2 downto 0);
      oData    : out std_logic_vector(31 downto 0));
  end component;

begin
  s_Ovfl <= '0';
  s_RegWrAddr <= s_Inst(11 downto 7);
  s_ALUInA <= s_PC when s_Inst(6 downto 0) = "0010111" else s_ReadData1;
  s_ALUInB <= s_Imm when s_ALUSrc = '1' else s_ReadData2;
  s_DMemAddr <= s_ALUOut;
  s_DMemData <= s_ReadData2;
  s_PCPlus4 <= std_logic_vector(unsigned(s_PC) + 4);
  s_BranchTarget <= std_logic_vector(unsigned(s_PC) + unsigned(s_Imm));
  s_JalrTarget <= std_logic_vector(unsigned(s_ReadData1) + unsigned(s_Imm));

  with iInstLd select
    s_IMemAddr <= s_PC when '0',
                  iInstAddr when others;

  with s_WBSel select
    s_RegWrData <= s_LoadData when WB_MEM,
                   s_PCPlus4 when WB_PC4,
                   s_ALUOut when others;

  process(s_PCPlus4, s_BranchTarget, s_JalrTarget, s_Branch, s_BranchTaken, s_Jump, s_Jalr)
    variable v_jalr_target : std_logic_vector(31 downto 0);
  begin
    v_jalr_target := s_JalrTarget;
    v_jalr_target(0) := '0';
    s_NextPC <= s_PCPlus4;

    if s_Branch = '1' and s_BranchTaken = '1' then
      s_NextPC <= s_BranchTarget;
    end if;

    if s_Jump = '1' then
      if s_Jalr = '1' then
        s_NextPC <= v_jalr_target;
      else
        s_NextPC <= s_BranchTarget;
      end if;
    end if;
  end process;

  PC: pc_reg
    port map(
      iCLK    => iCLK,
      iRST    => iRST,
      iHold   => s_Halt,
      iNextPC => s_NextPC,
      oPC     => s_PC);

  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH, DATA_WIDTH => N)
    port map(
      clk  => iCLK,
      addr => s_IMemAddr(11 downto 2),
      data => iInstExt,
      we   => iInstLd,
      q    => s_Inst);

  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH, DATA_WIDTH => N)
    port map(
      clk  => iCLK,
      addr => s_DMemAddr(11 downto 2),
      data => s_DMemData,
      we   => s_DMemWr,
      q    => s_DMemOut);

  Control: control_unit
    port map(
      iOpcode   => s_Inst(6 downto 0),
      iFunct3   => s_Inst(14 downto 12),
      iFunct7   => s_Inst(31 downto 25),
      iInst     => s_Inst,
      oRegWrite => s_RegWr,
      oMemWrite => s_DMemWr,
      oALUSrc   => s_ALUSrc,
      oALUCtrl  => s_ALUCtrl,
      oImmType  => s_ImmType,
      oWBSel    => s_WBSel,
      oBranch   => s_Branch,
      oJump     => s_Jump,
      oJalr     => s_Jalr,
      oHalt     => s_Halt);

  RegFile: reg_file
    port map(
      iCLK       => iCLK,
      iRST       => iRST,
      iRegWrite  => s_RegWr,
      iReadAddr1 => s_Inst(19 downto 15),
      iReadAddr2 => s_Inst(24 downto 20),
      iWriteAddr => s_RegWrAddr,
      iWriteData => s_RegWrData,
      oReadData1 => s_ReadData1,
      oReadData2 => s_ReadData2);

  ImmGen: imm_gen
    port map(
      iInst    => s_Inst,
      iImmType => s_ImmType,
      oImm     => s_Imm);

  ALU: alu32
    port map(
      iA       => s_ALUInA,
      iB       => s_ALUInB,
      iShamt   => s_Inst(24 downto 20),
      iALUCtrl => s_ALUCtrl,
      oResult  => s_ALUOut,
      oZero    => s_ALUZero);

  Branch: branch_unit
    port map(
      iA      => s_ReadData1,
      iB      => s_ReadData2,
      iFunct3 => s_Inst(14 downto 12),
      oTake   => s_BranchTaken);

  LoadFmt: load_unit
    port map(
      iMemData => s_DMemOut,
      iAddr    => s_DMemAddr(1 downto 0),
      iFunct3  => s_Inst(14 downto 12),
      oData    => s_LoadData);

  oALUOut <= s_ALUOut;
end architecture structure;
