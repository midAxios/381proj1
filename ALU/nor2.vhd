-- NOR gate in VHDL
-- 05/09/26 Ivy Creech :: created

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nor2 is
      Port(
	   i_A	:   in  STD_LOGIC_VECTOR(31 downto 0);	-- first register
	   i_B	:   in  STD_LOGIC_VECTOR(31 downto 0);	-- second register
	   o_F	:   out STD_LOGIC_VECTOR(31 downto 0)	-- result
       );
end nor2;

architecture dataflow of and2 is
begin

	o_F <= i_A nor i_B;

end dataflow; 