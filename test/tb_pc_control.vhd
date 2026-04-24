library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pc_control is
end entity;

architecture sim of tb_pc_control is
begin
  process
    variable pc : unsigned(31 downto 0);
    variable reset_pc : std_logic_vector(31 downto 0);
    variable target : std_logic_vector(31 downto 0);
    variable odd_addr : std_logic_vector(31 downto 0);
  begin
    reset_pc := x"00400000";
    pc := unsigned(reset_pc);
    assert std_logic_vector(pc + 4) = x"00400004" report "PC+4 failed" severity failure;
    odd_addr := x"00400003";
    target := std_logic_vector(unsigned(odd_addr) + 0);
    target(0) := '0';
    assert target = x"00400002" report "JALR alignment failed" severity failure;
    wait;
  end process;
end architecture;
