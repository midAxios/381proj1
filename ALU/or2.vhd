-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- org2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input OR 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-- 3/05/26 by Ivy Creech :: change names
-------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or2 is

  port(i_A          : in STD_LOGIC_VECTOR(31 downto 0);	-- first register
       i_B          : in STD_LOGIC_VECTOR(31 downto 0);	-- second register
       o_F          : out STD_LOGIC_VECTOR(31 downto 0);	-- result

end or2;

architecture dataflow of or2 is
begin

  o_F <= i_A or i_B;
  
end dataflow;
