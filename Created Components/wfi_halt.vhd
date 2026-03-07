library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity WFI_HALT is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        halt      : out STD_LOGIC  -- high when CPU is halted
    );
end WFI_HALT;

architecture Behavioral of WFI_HALT is
    signal halted : STD_LOGIC := '0';
begin

    process(clk, reset)
    begin
        if reset = '1' then
            halted <= '0';
        elsif rising_edge(clk) then
            -- Once WFI is executed, halt stays high
            halted <= '1';
        end if;
    end process;

    halt <= halted;

end Behavioral;