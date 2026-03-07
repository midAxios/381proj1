-- slt in RISC-V
-- rd = (rs1 < rs2) ? 1 : 0

-- author: Ivy Creech
-- slt in RISC-V

-- rd = (rs1 < rs2) ? 1 : 0

-- 03/05/26 Ivy Creech 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity slt is
    Port (
        rs1 : in  STD_LOGIC_VECTOR(31 downto 0);  -- first operand
        rs2 : in  STD_LOGIC_VECTOR(31 downto 0);  -- second operand
        rd  : out STD_LOGIC_VECTOR(31 downto 0)   -- result
    );
end slt;

architecture Behavioral of slt is
begin

    process(rs1, rs2)
    begin
        if signed(rs1) < signed(rs2) then
            rd <= x"00000001";
        else
            rd <= x"00000000";
        end if;
    end process;

end Behavioral;