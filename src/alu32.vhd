library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.RISCV_types.all;

entity alu32 is
  port(
    iA       : in  std_logic_vector(31 downto 0);
    iB       : in  std_logic_vector(31 downto 0);
    iShamt   : in  std_logic_vector(4 downto 0);
    iALUCtrl : in  std_logic_vector(3 downto 0);
    oResult  : out std_logic_vector(31 downto 0);
    oZero    : out std_logic);
end entity alu32;

architecture rtl of alu32 is
  signal s_result : std_logic_vector(31 downto 0);
begin
  process(iA, iB, iShamt, iALUCtrl)
  begin
    s_result <= (others => '0');
    case iALUCtrl is
      when ALU_ADD  => s_result <= std_logic_vector(unsigned(iA) + unsigned(iB));
      when ALU_SUB  => s_result <= std_logic_vector(unsigned(iA) - unsigned(iB));
      when ALU_AND  => s_result <= iA and iB;
      when ALU_OR   => s_result <= iA or iB;
      when ALU_XOR  => s_result <= iA xor iB;
      when ALU_SLL  => s_result <= std_logic_vector(shift_left(unsigned(iA), to_integer(unsigned(iShamt))));
      when ALU_SRL  => s_result <= std_logic_vector(shift_right(unsigned(iA), to_integer(unsigned(iShamt))));
      when ALU_SRA  => s_result <= std_logic_vector(shift_right(signed(iA), to_integer(unsigned(iShamt))));
      when ALU_SLT  =>
        if signed(iA) < signed(iB) then
          s_result <= x"00000001";
        end if;
      when ALU_SLTU =>
        if unsigned(iA) < unsigned(iB) then
          s_result <= x"00000001";
        end if;
      when ALU_PASS => s_result <= iB;
      when others   => s_result <= (others => '0');
    end case;
  end process;

  oResult <= s_result;
  oZero <= '1' when s_result = x"00000000" else '0';
end architecture rtl;
