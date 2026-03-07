-- sra in RISC-V

-- rd = rs1 >> imm

-- author: Ivy Creech

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity srai is
    Port (
        rs1  : in  STD_LOGIC_VECTOR(31 downto 0);  -- value to shift
        imm  : in  STD_LOGIC_VECTOR(11 downto 0);  -- 12-bit I-type immedicate 
        rd   : out STD_LOGIC_VECTOR(31 downto 0)   -- result

	-- imm  : in  STD_LOGIC_VECTOR(4 downto 0);  -- 5-bit shift amount
    );
end srai;

architecture Behavioral of srai is
begin

    -- Arithmetic right shift by immediate
    rd <= std_logic_vector(shift_right(signed(rs1), to_integer(unsigned(imm))));

end Behavioral;