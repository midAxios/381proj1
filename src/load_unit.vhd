library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity load_unit is
  port(
    iMemData : in  std_logic_vector(31 downto 0);
    iAddr    : in  std_logic_vector(1 downto 0);
    iFunct3  : in  std_logic_vector(2 downto 0);
    oData    : out std_logic_vector(31 downto 0));
end entity load_unit;

architecture rtl of load_unit is
begin
  process(iMemData, iAddr, iFunct3)
    variable v_byte : std_logic_vector(7 downto 0);
    variable v_half : std_logic_vector(15 downto 0);
  begin
    case iAddr is
      when "00" => v_byte := iMemData(7 downto 0);
      when "01" => v_byte := iMemData(15 downto 8);
      when "10" => v_byte := iMemData(23 downto 16);
      when others => v_byte := iMemData(31 downto 24);
    end case;

    if iAddr(1) = '0' then
      v_half := iMemData(15 downto 0);
    else
      v_half := iMemData(31 downto 16);
    end if;

    case iFunct3 is
      when "000" => oData <= std_logic_vector(resize(signed(v_byte), 32));
      when "001" => oData <= std_logic_vector(resize(signed(v_half), 32));
      when "010" => oData <= iMemData;
      when "100" => oData <= x"000000" & v_byte;
      when "101" => oData <= x"0000" & v_half;
      when others => oData <= (others => '0');
    end case;
  end process;
end architecture rtl;
