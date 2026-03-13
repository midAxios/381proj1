library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity barrel_shifter32 is
    port(
        iA         : in  std_logic_vector(31 downto 0);
        iShamt     : in  std_logic_vector(4 downto 0);
        iShiftCtrl : in  std_logic_vector(1 downto 0); -- 00=SLL, 01=SRL, 10=SRA
        o_F         : out std_logic_vector(31 downto 0)
    );
end barrel_shifter32;

architecture structural of barrel_shifter32 is

component mux2t1
    port(
        i_D0 : in  std_logic;
        i_D1 : in  std_logic;
        i_S  : in  std_logic;
        o_O  : out std_logic
    );
end component;

signal s0 : in  std_logic_vector(31 downto 0);
signal s1 : in  std_logic_vector(31 downto 0);
signal s2 : in  std_logic_vector(31 downto 0);
signal s3 : in  std_logic_vector(31 downto 0); 
signal s4 : in  std_logic_vector(31 downto 0);
signal s5 : in  std_logic_vector(31 downto 0);
signal fill_bit_stage : std_logic_vector(31 downto 0);

begin

s0 <= iA;

-- Decide fill bit for top positions based on shift type
fill_bit_stage <= (others =>
    '0') when iShiftCtrl = "00" else  -- SLL (fill 0)
    (others =>
    '0') when iShiftCtrl = "01" else  -- SRL (fill 0)
    (others =>
    iA(31));                           -- SRA (fill sign bit)


-- SHIFT BY 1

GEN1: for i in 0 to 31 generate
begin
    MUX1: mux2t1
        port map(
            i_D0 => s0(i),
            i_D1 => ( i-1 < 0 ? '0' : s0(i-1) ) when iShiftCtrl = "00" else -- SLL
                   ( i+1 > 31 ? fill_bit_stage(i) : s0(i+1) ), -- SRL/SRA
            i_S  => iShamt(0),
            o_O  => s1(i)
        );
end generate;


-- SHIFT BY 2

GEN2: for i in 0 to 31 generate
begin
    MUX2: mux2t1
        port map(
            i_D0 => s1(i),
            i_D1 => (iShiftCtrl = "00" and i>=2) ? s1(i-2) : 
                    (iShiftCtrl /= "00" and i<=29) ? s1(i+2) : fill_bit_stage(i),
            i_S  => iShamt(1),
            o_O  => s2(i)
        );
end generate;


-- SHIFT BY 4

GEN4: for i in 0 to 31 generate
begin
    MUX4: mux2t1
        port map(
            i_D0 => s2(i),
            i_D1 => (iShiftCtrl = "00" and i>=4) ? s2(i-4) : 
                    (iShiftCtrl /= "00" and i<=27) ? s2(i+4) : fill_bit_stage(i),
            i_S  => iShamt(2),
            o_O  => s3(i)
        );
end generate;


-- SHIFT BY 8

GEN8: for i in 0 to 31 generate
begin
    MUX8: mux2t1
        port map(
            i_D0 => s3(i),
            i_D1 => (iShiftCtrl = "00" and i>=8) ? s3(i-8) : 
                    (iShiftCtrl /= "00" and i<=23) ? s3(i+8) : fill_bit_stage(i),
            i_S  => iShamt(3),
            o_O  => s4(i)
        );
end generate;


-- SHIFT BY 16

GEN16: for i in 0 to 31 generate
begin
    MUX16: mux2t1
        port map(
            i_D0 => s4(i),
            i_D1 => (iShiftCtrl = "00" and i>=16) ? s4(i-16) : 
                    (iShiftCtrl /= "00" and i<=15) ? s4(i+16) : fill_bit_stage(i),
            i_S  => iShamt(4),
            o_O  => s5(i)
        );
end generate;

o_F <= s5;

end structural;