-- bgeu in RISC-V
-- if ( rs1 >= rs2){
--	goto branch;
-- }

-- bgeu rs1, rs2, branch
--	pc = pc + imm

-- 03/05/26 Ivy Creech

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bgeu is
    Port (
        rs1     : in  STD_LOGIC_VECTOR(31 downto 0); -- first register
        rs2     : in  STD_LOGIC_VECTOR(31 downto 0); -- second register
        imm     : in  STD_LOGIC_VECTOR(31 downto 0); -- branch immediate
        pc      : in  STD_LOGIC_VECTOR(31 downto 0); -- current PC
        pc_next : out STD_LOGIC_VECTOR(31 downto 0); -- next PC
        branch  : out STD_LOGIC                      -- branch signal
    );
end bgeu;

architecture Behavioral of bgeu is
    signal pc_plus4  : STD_LOGIC_VECTOR(31 downto 0);
    signal pc_branch : STD_LOGIC_VECTOR(31 downto 0);
begin

    -- PC + 4
    pc_plus4 <= std_logic_vector(unsigned(pc) + 4);

    -- Branch target
    pc_branch <= std_logic_vector(signed(pc) + signed(imm));

    process(rs1, rs2, pc_plus4, pc_branch)
    begin
        -- Unsigned comparison for BGEU
        if unsigned(rs1) >= unsigned(rs2) then
            pc_next <= pc_branch;
            branch  <= '1';
        else
            pc_next <= pc_plus4;
            branch  <= '0';
        end if;
    end process;

end Behavioral;