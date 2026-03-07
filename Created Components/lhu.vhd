library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lhu is
    Port (
        rs1      : in  STD_LOGIC_VECTOR(31 downto 0);  -- base register
        imm      : in  STD_LOGIC_VECTOR(11 downto 0);  -- 12-bit immediate
        mem_data : in  STD_LOGIC_VECTOR(15 downto 0);  -- halfword from memory
        address  : out STD_LOGIC_VECTOR(31 downto 0);  -- calculated memory address
        rd       : out STD_LOGIC_VECTOR(31 downto 0)   -- loaded halfword (zero-extended)
    );
end lhu;

architecture Behavioral of lhu is
    signal imm_ext : STD_LOGIC_VECTOR(31 downto 0);
begin

    -- Sign-extend the 12-bit immediate for address calculation
    imm_ext <= std_logic_vector(resize(signed(imm), 32));

    -- Calculate memory address
    address <= std_logic_vector(unsigned(rs1) + unsigned(imm_ext));

    -- Zero-extend loaded halfword to 32 bits
    rd <= (31 downto 16 => '0') & mem_data;

end Behavioral;