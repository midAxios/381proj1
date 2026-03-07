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
use IEEE.std_logic_1164.all;

entity xor2 is
  port(
	rs1          : in std_logic;	-- first register
       	rs2          : in std_logic;	-- second register
       	rd           : out std_logic);	-- result

end xor2;

architecture dataflow of xor2 is
begin

  rd <= rs1 xor rs2;
  
end dataflow;