library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_file is
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
end entity reg_file;

architecture rtl of reg_file is
  type reg_array_t is array (0 to 31) of std_logic_vector(31 downto 0);
  signal r_regs : reg_array_t := (others => (others => '0'));
begin
  process(iCLK)
  begin
    if rising_edge(iCLK) then
      if iRST = '1' then
        r_regs <= (others => (others => '0'));
      else
        if iRegWrite = '1' and iWriteAddr /= "00000" then
          r_regs(to_integer(unsigned(iWriteAddr))) <= iWriteData;
        end if;
        r_regs(0) <= (others => '0');
      end if;
    end if;
  end process;

  oReadData1 <= (others => '0') when iReadAddr1 = "00000" else r_regs(to_integer(unsigned(iReadAddr1)));
  oReadData2 <= (others => '0') when iReadAddr2 = "00000" else r_regs(to_integer(unsigned(iReadAddr2)));
end architecture rtl;
