library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity branch_unit is
  port(
    iA      : in  std_logic_vector(31 downto 0);
    iB      : in  std_logic_vector(31 downto 0);
    iFunct3 : in  std_logic_vector(2 downto 0);
    oTake   : out std_logic);
end entity branch_unit;

architecture rtl of branch_unit is
begin
  process(iA, iB, iFunct3)
  begin
    oTake <= '0';
    case iFunct3 is
      when "000" =>
        if iA = iB then
          oTake <= '1';
        end if;
      when "001" =>
        if iA /= iB then
          oTake <= '1';
        end if;
      when "100" =>
        if signed(iA) < signed(iB) then
          oTake <= '1';
        end if;
      when "101" =>
        if signed(iA) >= signed(iB) then
          oTake <= '1';
        end if;
      when "110" =>
        if unsigned(iA) < unsigned(iB) then
          oTake <= '1';
        end if;
      when "111" =>
        if unsigned(iA) >= unsigned(iB) then
          oTake <= '1';
        end if;
      when others =>
        oTake <= '0';
    end case;
  end process;
end architecture rtl;
