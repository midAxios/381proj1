-- jal in RISC-V

-- jal = pc + 4
--	pc = pc + imm

-- 03/05/26 Ivy Creech

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity jal is
    Port (
        pc       : in  STD_LOGIC_VECTOR(31 downto 0); -- current program counter
        imm      : in  STD_LOGIC_VECTOR(31 downto 0); -- 20-bit J-type immediate (already extended to 32-bit)
        rd       : out STD_LOGIC_VECTOR(31 downto 0); -- destination register to store PC+4
        pc_next  : out STD_LOGIC_VECTOR(31 downto 0)  -- next PC value
    );
end jal;

architecture Behavioral of jal is
    signal pc_plus4 : STD_LOGIC_VECTOR(31 downto 0);
begin

    -- Compute PC + 4 for storing in rd
    pc_plus4 <= std_logic_vector(unsigned(pc) + 4);

    -- Assign rd = PC + 4
    rd <= pc_plus4;

    -- Assign next PC = PC + imm
    pc_next <= std_logic_vector(signed(pc) + signed(imm));

end Behavioral;