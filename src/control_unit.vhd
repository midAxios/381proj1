library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity control_unit is
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
end entity control_unit;

architecture rtl of control_unit is
begin
  process(iOpcode, iFunct3, iFunct7, iInst)
  begin
    oRegWrite <= '0';
    oMemWrite <= '0';
    oALUSrc <= '0';
    oALUCtrl <= ALU_ADD;
    oImmType <= IMM_I;
    oWBSel <= WB_ALU;
    oBranch <= '0';
    oJump <= '0';
    oJalr <= '0';
    oHalt <= '0';

    case iOpcode is
      when "0110011" =>
        oRegWrite <= '1';
        case iFunct3 is
          when "000" =>
            if iFunct7(5) = '1' then
              oALUCtrl <= ALU_SUB;
            else
              oALUCtrl <= ALU_ADD;
            end if;
          when "001" => oALUCtrl <= ALU_SLL;
          when "010" => oALUCtrl <= ALU_SLT;
          when "011" => oALUCtrl <= ALU_SLTU;
          when "100" => oALUCtrl <= ALU_XOR;
          when "101" =>
            if iFunct7(5) = '1' then
              oALUCtrl <= ALU_SRA;
            else
              oALUCtrl <= ALU_SRL;
            end if;
          when "110" => oALUCtrl <= ALU_OR;
          when "111" => oALUCtrl <= ALU_AND;
          when others => oALUCtrl <= ALU_ADD;
        end case;

      when "0010011" =>
        oRegWrite <= '1';
        oALUSrc <= '1';
        oImmType <= IMM_I;
        case iFunct3 is
          when "000" => oALUCtrl <= ALU_ADD;
          when "001" => oALUCtrl <= ALU_SLL;
          when "010" => oALUCtrl <= ALU_SLT;
          when "011" => oALUCtrl <= ALU_SLTU;
          when "100" => oALUCtrl <= ALU_XOR;
          when "101" =>
            if iFunct7(5) = '1' then
              oALUCtrl <= ALU_SRA;
            else
              oALUCtrl <= ALU_SRL;
            end if;
          when "110" => oALUCtrl <= ALU_OR;
          when "111" => oALUCtrl <= ALU_AND;
          when others => oALUCtrl <= ALU_ADD;
        end case;

      when "0000011" =>
        oRegWrite <= '1';
        oALUSrc <= '1';
        oALUCtrl <= ALU_ADD;
        oImmType <= IMM_I;
        oWBSel <= WB_MEM;

      when "0100011" =>
        oALUSrc <= '1';
        oALUCtrl <= ALU_ADD;
        oImmType <= IMM_S;
        if iFunct3 = "010" then
          oMemWrite <= '1';
        end if;

      when "1100011" =>
        oBranch <= '1';
        oALUCtrl <= ALU_SUB;
        oImmType <= IMM_B;

      when "1101111" =>
        oRegWrite <= '1';
        oImmType <= IMM_J;
        oWBSel <= WB_PC4;
        oJump <= '1';

      when "1100111" =>
        oRegWrite <= '1';
        oALUSrc <= '1';
        oImmType <= IMM_I;
        oWBSel <= WB_PC4;
        oJump <= '1';
        oJalr <= '1';

      when "0110111" =>
        oRegWrite <= '1';
        oALUSrc <= '1';
        oALUCtrl <= ALU_PASS;
        oImmType <= IMM_U;

      when "0010111" =>
        oRegWrite <= '1';
        oALUSrc <= '1';
        oALUCtrl <= ALU_ADD;
        oImmType <= IMM_U;

      when "1110011" =>
        if iInst = x"10500073" then
          oHalt <= '1';
        end if;

      when others =>
        null;
    end case;
  end process;
end architecture rtl;
