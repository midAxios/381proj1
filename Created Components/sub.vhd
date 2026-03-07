-- sub in RISC-V

-- rd = rs1 - rs2

-- 03/05/26 Ivy Creech

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sub is
    Port (
        rs1 : in  STD_LOGIC_VECTOR(31 downto 0);  -- first operand
        rs2 : in  STD_LOGIC_VECTOR(31 downto 0);  -- second operand
        rd  : out STD_LOGIC_VECTOR(31 downto 0)   -- result
    );
end sub;

architecture Behavioral of sub is
begin

    -- Perform subtraction
    rd <= std_logic_vector(signed(rs1) - signed(rs2));

end Behavioral;