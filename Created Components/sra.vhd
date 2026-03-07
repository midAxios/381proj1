-- sra in RISC-V

-- rd = rs1 >> rs2

-- author: Ivy Creech


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sra2 is
    Port (
        rs1 : in  STD_LOGIC_VECTOR(31 downto 0);  -- value to shift
        rs2 : in  STD_LOGIC_VECTOR(31 downto 0);  -- shift amount
        rd  : out STD_LOGIC_VECTOR(31 downto 0)   -- result
    );
end sra2;

architecture Behavioral of sra2 is
begin

    -- Arithmetic right shift
    rd <= std_logic_vector(
            shift_right(signed(rs1),
            to_integer(unsigned(rs2(4 downto 0))))
         );

end Behavioral;