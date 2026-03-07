library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity wfi is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        wfi_flag  : out STD_LOGIC  -- signal to indicate CPU should wait
    );
end wfi;

architecture Behavioral of wfi is
begin

    process(clk, reset)
    begin
        if reset = '1' then
            wfi_flag <= '0';
        elsif rising_edge(clk) then
            -- WFI sets wait flag high
            wfi_flag <= '1';
        end if;
    end process;

end Behavioral;