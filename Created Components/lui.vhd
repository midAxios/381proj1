-- lui in RISC-V

-- rd = mem_data, rs1 + imm 

-- 03/05/26 Ivy Creech


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lui is
    Port (
        imm : in  STD_LOGIC_VECTOR(19 downto 0);  -- 20-bit U-type immediate
        rd  : out STD_LOGIC_VECTOR(31 downto 0)   -- result
    );
end lui;

architecture Behavioral of lui is
begin

    -- Load upper immediate (shift left 12 bits)
    rd <= imm & "000000000000";

end Behavioral;