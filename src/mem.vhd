library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mem is
  generic(
    ADDR_WIDTH : integer := 10;
    DATA_WIDTH : integer := 32);
  port(
    clk  : in  std_logic;
    addr : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    data : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    we   : in  std_logic := '1';
    q    : out std_logic_vector(DATA_WIDTH-1 downto 0));
end entity mem;

architecture rtl of mem is
  subtype word_t is std_logic_vector(DATA_WIDTH-1 downto 0);
  type memory_t is array (0 to (2**ADDR_WIDTH)-1) of word_t;
  signal ram : memory_t := (others => (others => '0'));
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        ram(to_integer(unsigned(addr))) <= data;
      end if;
    end if;
  end process;

  q <= ram(to_integer(unsigned(addr)));
end architecture rtl;
