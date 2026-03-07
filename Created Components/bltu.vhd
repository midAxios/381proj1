-- bltu in RISC-V
-- if ( rs1 < rs2){
--	goto branch;
-- }

-- bltu rs1, rs2, branch
--	pc = pc + imm

-- 03/05/26 Ivy Creech

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bltu is
    Port (
        rs1     : in  STD_LOGIC_VECTOR(31 downto 0);	-- first register
        rs2     : in  STD_LOGIC_VECTOR(31 downto 0);	-- second register
        imm     : in  STD_LOGIC_VECTOR(31 downto 0);	-- 7-bit SB-type branch immediate
        pc      : in  STD_LOGIC_VECTOR(31 downto 0);	-- current PC
        pc_next : out STD_LOGIC_VECTOR(31 downto 0)	-- next PC value
    );
end bltu;

architecture Behavioral of bltu is
    signal pc_plus4  : STD_LOGIC_VECTOR(31 downto 0);
    signal pc_branch : STD_LOGIC_VECTOR(31 downto 0);
begin

    -- PC + 4
    pc_plus4 <= std_logic_vector(unsigned(pc) + 4);

    -- Branch target
    pc_branch <= std_logic_vector(signed(pc) + signed(imm));

    process(rs1, rs2, pc_plus4, pc_branch)
    begin
        -- Unsigned comparison for BLTU
        if unsigned(rs1) < unsigned(rs2) then
            pc_next <= pc_branch;
        else
            pc_next <= pc_plus4;
        end if;
    end process;

end Behavioral;