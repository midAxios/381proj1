-- slli in RISC-V

-- rd = rs1 << imm

-- 03/05/26 Ivy Creech 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity slli is
    Port (
        rs1  : in  STD_LOGIC_VECTOR(31 downto 0);  -- value to shift
        imm  : in  STD_LOGIC_VECTOR(11 downto 0);  -- 12-bit i_type immediate
        rd   : out STD_LOGIC_VECTOR(31 downto 0)   -- result
    );
end slli;

architecture Behavioral of slli is
begin

    -- Shift left logical by immediate
    rd <= std_logic_vector(shift_left(unsigned(rs1), to_integer(unsigned(imm))));

end Behavioral;