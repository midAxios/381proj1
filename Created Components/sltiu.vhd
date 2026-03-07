-- sltiu in RISC-V
-- rd = (rs1 < imm) ? 1 : 0

-- author: Ivy Creech

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sltiu is
    Port (
        rs1 : in  STD_LOGIC_VECTOR(31 downto 0);  -- first operand
        imm : in  STD_LOGIC_VECTOR(31 downto 0);  -- second operand
        rd  : out STD_LOGIC_VECTOR(31 downto 0)   -- result
    );
end sltiu;

architecture Behavioral of sltiu is
	signal imm_ext : STD_LOGIC_VECTOR(31 downto 0);
begin

	-- Sign extend immediate
    	imm_ext <= std_logic_vector(resize(signed(imm), 32));

    process(rs1, imm_ext)
    begin
        if unsigned(rs1) < unsigned(imm_ext) then
            rd <= x"00000001";
        else
            rd <= x"00000000";
        end if;
    end process;

end Behavioral;