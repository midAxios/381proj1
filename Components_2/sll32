library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sll32 is
    port(
        iA     : in STD_LOGIC_VECTOR(31 downto 0);
        iShamt : in STD_LOGIC_VECTOR(4 downto 0);
        o_F    : out STD_LOGIC_VECTOR(31 downto 0)
    );
end sll32;

architecture structural of sll32 is


-- 2:1 MUX COMPONENT

component mux2t1
    port(
        i_D0 : in  std_logic;
        i_D1 : in  std_logic;
        i_S  : in  std_logic;
        o_O  : out std_logic
    );
end component;


-- INTERNAL STAGE SIGNALS

signal s0 : in  std_logic_vector(31 downto 0);
signal s1 : in  std_logic_vector(31 downto 0);
signal s2 : in  std_logic_vector(31 downto 0);
signal s3 : in  std_logic_vector(31 downto 0); 
signal s4 : in  std_logic_vector(31 downto 0);
signal s5 : in  std_logic_vector(31 downto 0);

begin

-- INPUT STAGE

s0 <= iA;


-- SHIFT BY 1 (stage 0)

GEN_SHIFT1: for i in 0 to 31 generate
begin

    MUX: mux2t1
        port map(
            i_D0 => s0(i),
            i_D1 => ( '0' when i=0 else s0(i-1) ),
            i_S  => iShamt(0),
            o_O  => s1(i)
        );

end generate;


-- SHIFT BY 2

GEN_SHIFT2: for i in 0 to 31 generate
begin

    MUX: mux2t1
        port map(
            i_D0 => s1(i),
            i_D1 => ( '0' when i < 2 else s1(i-2) ),
            i_S  => iShamt(1),
            o_O  => s2(i)
        );

end generate;


-- SHIFT BY 4

GEN_SHIFT4: for i in 0 to 31 generate
begin

    MUX: mux2t1
        port map(
            i_D0 => s2(i),
            i_D1 => ( '0' when i < 4 else s2(i-4) ),
            i_S  => iShamt(2),
            o_O  => s3(i)
        );

end generate;


-- SHIFT BY 8

GEN_SHIFT8: for i in 0 to 31 generate
begin

    MUX: mux2t1
        port map(
            i_D0 => s3(i),
            i_D1 => ( '0' when i < 8 else s3(i-8) ),
            i_S  => iShamt(3),
            o_O  => s4(i)
        );

end generate;


-- SHIFT BY 16

GEN_SHIFT16: for i in 0 to 31 generate
begin

    MUX: mux2t1
        port map(
            i_D0 => s4(i),
            i_D1 => ( '0' when i < 16 else s4(i-16) ),
            i_S  => iShamt(4),
            o_O  => s5(i)
        );

end generate;

-- OUTPUT

o_F <= s5;

end structural;