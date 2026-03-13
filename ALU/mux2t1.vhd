library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2t1 is
    port(
        i_D0 : in STD_LOGIC_VECTOR (31 downto 0);
        i_D1 : in STD_LOGIC_VECTOR (31 downto 0);
        i_S  : in STD_LOGIC;
        o_O  : out STD_LOGIC_VECTOR (31 downto 0)
    );
end mux2t1;

architecture structural of mux2t1 is

    -- Component declarations
    component invg
        port(
            i_A : in  STD_LOGIC;
            o_F : out STD_LOGIC
        );
    end component;

    component and2
        port(
            i_A : in  STD_LOGIC;
            i_B : in  STD_LOGIC;
            o_F : out STD_LOGIC
        );
    end component;

    component or2
        port(
            i_A : in  STD_LOGIC;
            i_B : in  STD_LOGIC;
            o_F : out STD_LOGIC
        );
    end component;

    -- Internal signals
    signal s_Sbar     : STD_LOGIC;
    signal s_and0_out : STD_LOGIC_VECTOR(31 downto 0);
    signal s_and1_out : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- Invert select
    U1: invg
        port map(
            i_A => i_S,
            o_F => s_Sbar
        );

    -- AND for D0 path
    U2: and2
        port map(
            i_A => s_Sbar,
            i_B => i_D0,
            o_F => s_and0_out
        );

    -- AND for D1 path
    U3: and2
        port map(
            i_A => i_S,
            i_B => i_D1,
            o_F => s_and1_out
        );

    -- OR gate for final output
    U4: or2
        port map(
            i_A => s_and0_out,
            i_B => s_and1_out,
            o_F => o_O
        );

end structural;
