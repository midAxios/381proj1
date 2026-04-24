library IEEE;
use IEEE.std_logic_1164.all;

entity pc_reg is
  port(
    iCLK    : in  std_logic;
    iRST    : in  std_logic;
    iHold   : in  std_logic;
    iNextPC : in  std_logic_vector(31 downto 0);
    oPC     : out std_logic_vector(31 downto 0));
end entity pc_reg;

architecture rtl of pc_reg is
  constant PC_RESET : std_logic_vector(31 downto 0) := x"00400000";
  signal r_PC : std_logic_vector(31 downto 0) := PC_RESET;
begin
  process(iCLK)
  begin
    if rising_edge(iCLK) then
      if iRST = '1' then
        r_PC <= PC_RESET;
      elsif iHold = '0' then
        r_PC <= iNextPC;
      end if;
    end if;
  end process;

  oPC <= r_PC;
end architecture rtl;
