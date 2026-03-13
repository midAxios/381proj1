-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- xorg2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input XOR 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-- 3/6/26  by Ivy Creech :: change names
-------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor2 is
  port(
	i_A          : in STD_LOGIC_VECTOR(31 downto 0);	-- first register
       	i_B          : in STD_LOGIC_VECTOR(31 downto 0);	-- second register
       	o_F          : out STD_LOGIC_VECTOR(31 downto 0);	-- result

end xor2;

architecture dataflow of xor2 is
begin

  o_F <= i_A xor i_B;
  
end dataflow;