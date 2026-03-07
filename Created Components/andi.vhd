-- andi in RISC-V
-- rd = rs1 & imm

-- 03/05/26 Ivy Creech


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity andi is
      Port(
	   rs1	:   in  STD_LOGIC_VECTOR(31 downto 0);	-- first register
	   imm	:   in  STD_LOGIC_VECTOR(31 downto 0);	-- 12-bit I-type immediate
	   rd	:   out STD_LOGIC_VECTOR(31 downto 0)	-- result
       );
end andi;

architecture behavior of andi is
	signal imm_ext : STD_LOGIC_VECTOR(31 downto 0);
begin 

	-- Sign extend the 12-bit immediate to 32 bits
	imm_ext <= std_logic_vector(resize(signed(imm), 32));

	-- Perform bitwise AND
    	rd <= rs1 AND imm_ext;

end behavior; 