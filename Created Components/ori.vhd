-- ori in RISC-V

-- rd = rs1 | imm

-- author: Ivy Creech

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ori is

  port(rs1          : in std_logic;	-- first register
       rs2          : in std_logic;	-- second register
       rd           : out std_logic);	-- result

end ori;

architecture behavior of ori is
	signal imm_ext : STD_LOGIC_VECTOR(31 downto 0);
begin 

	-- Sign extend the 12-bit immediate to 32 bits
	imm_ext <= std_logic_vector(resize(signed(imm), 32));

	-- Perform bitwise AND
    	rd <= rs1 OR imm_ext;

end behavior; 