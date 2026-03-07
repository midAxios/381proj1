-- Add in RISC-V
-- rd = rs1 + rs2

-- 03/05/26 Ivy Creech

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity add is
    Port (
        rs1   : in  STD_LOGIC_VECTOR(31 downto 0);	-- first register
        rs2   : in  STD_LOGIC_VECTOR(31 downto 0);	-- second register
        rd    : out STD_LOGIC_VECTOR(31 downto 0)	-- result
    );
end add;

architecture Behavioral of add is
begin

    rd <= std_logic_vector(unsigned(rs1) + unsigned(rs2));

end Behavioral;