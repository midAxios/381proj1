library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity srl32 is
    port(
        iA     : in  std_logic_vector(31 downto 0);
        iShamt : in  std_logic_vector(4 downto 0);
        o_F    : out std_logic_vector(31 downto 0)
    );
end srl32;

architecture structural of srl32 is


-- 2:1 MUX COMPONENT

component mux2t1
    port(
        i_D0 : in  std_logic;
        i_D1 : in  std_logic;
        i_S  : in  std_logic;
        o_O  : out std_logic
    );
end component;


-- STAGE SIGNALS

signal s0 : in  std_logic_vector(31 downto 0);
signal s1 : in  std_logic_vector(31 downto 0);
signal s2 : in  std_logic_vector(31 downto 0);
signal s3 : in  std_logic_vector(31 downto 0); 
signal s4 : in  std_logic_vector(31 downto 0);
signal s5 : in  std_logic_vector(31 downto 0);

begin


-- INPUT

s0 <= iA;


-- SHIFT BY 1

GEN1: for i in 0 to 31 generate
begin

    HIGH: if i = 31 generate
        M: mux2t1 port map(s0(i), '0', iShamt(0), s1(i));
    end generate;

    LOW: if i < 31 generate
        M: mux2t1 port map(s0(i), s0(i+1), iShamt(0), s1(i));
    end generate;

end generate;


-- SHIFT BY 2

GEN2: for i in 0 to 31 generate
begin

    HIGH: if i >= 30 generate
        M: mux2t1 port map(s1(i), '0', iShamt(1), s2(i));
    end generate;

    LOW: if i < 30 generate
        M: mux2t1 port map(s1(i), s1(i+2), iShamt(1), s2(i));
    end generate;

end generate;


-- SHIFT BY 4

GEN4: for i in 0 to 31 generate
begin

    HIGH: if i >= 28 generate
        M: mux2t1 port map(s2(i), '0', iShamt(2), s3(i));
    end generate;

    LOW: if i < 28 generate
        M: mux2t1 port map(s2(i), s2(i+4), iShamt(2), s3(i));
    end generate;

end generate;


-- SHIFT BY 8

GEN8: for i in 0 to 31 generate
begin

    HIGH: if i >= 24 generate
        M: mux2t1 port map(s3(i), '0', iShamt(3), s4(i));
    end generate;

    LOW: if i < 24 generate
        M: mux2t1 port map(s3(i), s3(i+8), iShamt(3), s4(i));
    end generate;

end generate;


-- SHIFT BY 16

GEN16: for i in 0 to 31 generate
begin

    HIGH: if i >= 16 generate
        M: mux2t1 port map(s4(i), '0', iShamt(4), s5(i));
    end generate;

    LOW: if i < 16 generate
        M: mux2t1 port map(s4(i), s4(i+16), iShamt(4), s5(i));
    end generate;

end generate;


-- OUTPUT

o_F <= s5;

end structural;