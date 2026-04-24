library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.RISCV_types.all;

entity alu32 is
  port(
    iA       : in  std_logic_vector(31 downto 0);
    iB       : in  std_logic_vector(31 downto 0);
    iShamt   : in  std_logic_vector(4 downto 0);
    iALUCtrl : in  std_logic_vector(3 downto 0);
    oResult  : out std_logic_vector(31 downto 0);
    oZero    : out std_logic
  );
end entity alu32;

architecture dataflow of alu32 is

  type t_stage_array is array (0 to 5) of std_logic_vector(31 downto 0);
  type t_shift_array is array (0 to 4) of integer;

  constant C_SHIFT : t_shift_array := (1, 2, 4, 8, 16);

  signal s_shamt : std_logic_vector(4 downto 0);

  signal s_add  : std_logic_vector(31 downto 0);
  signal s_sub  : std_logic_vector(31 downto 0);
  signal s_and  : std_logic_vector(31 downto 0);
  signal s_or   : std_logic_vector(31 downto 0);
  signal s_xor  : std_logic_vector(31 downto 0);
  signal s_nor  : std_logic_vector(31 downto 0);
  signal s_slt  : std_logic_vector(31 downto 0);
  signal s_sltu : std_logic_vector(31 downto 0);
  signal s_pass : std_logic_vector(31 downto 0);

  signal s_srl_stage : t_stage_array;
  signal s_sra_stage : t_stage_array;
  signal s_sll_stage : t_stage_array;

  signal s_srl : std_logic_vector(31 downto 0);
  signal s_sra : std_logic_vector(31 downto 0);
  signal s_sll : std_logic_vector(31 downto 0);

  signal s_left_input : std_logic_vector(31 downto 0);
  signal s_result     : std_logic_vector(31 downto 0);

begin

  s_shamt <= iB(4 downto 0);

  s_add  <= std_logic_vector(unsigned(iA) + unsigned(iB));
  s_sub  <= std_logic_vector(unsigned(iA) - unsigned(iB));
  s_and  <= iA and iB;
  s_or   <= iA or iB;
  s_xor  <= iA xor iB;
  s_nor  <= not (iA or iB);
  s_pass <= iB;

  s_slt <= x"00000001" when signed(iA) < signed(iB) else
           x"00000000";

  s_sltu <= x"00000001" when unsigned(iA) < unsigned(iB) else
            x"00000000";


  s_srl_stage(0) <= iA;

  gen_srl_stage : for st in 0 to 4 generate
    gen_srl_bit : for bitpos in 0 to 31 generate

      gen_srl_in_range : if bitpos + C_SHIFT(st) <= 31 generate
        s_srl_stage(st + 1)(bitpos) <=
          s_srl_stage(st)(bitpos + C_SHIFT(st)) when s_shamt(st) = '1' else
          s_srl_stage(st)(bitpos);
      end generate gen_srl_in_range;

      gen_srl_out_range : if bitpos + C_SHIFT(st) > 31 generate
        s_srl_stage(st + 1)(bitpos) <=
          '0' when s_shamt(st) = '1' else
          s_srl_stage(st)(bitpos);
      end generate gen_srl_out_range;

    end generate gen_srl_bit;
  end generate gen_srl_stage;

  s_srl <= s_srl_stage(5);

  s_sra_stage(0) <= iA;

  gen_sra_stage : for st in 0 to 4 generate
    gen_sra_bit : for bitpos in 0 to 31 generate

      gen_sra_in_range : if bitpos + C_SHIFT(st) <= 31 generate
        s_sra_stage(st + 1)(bitpos) <=
          s_sra_stage(st)(bitpos + C_SHIFT(st)) when s_shamt(st) = '1' else
          s_sra_stage(st)(bitpos);
      end generate gen_sra_in_range;

      gen_sra_out_range : if bitpos + C_SHIFT(st) > 31 generate
        s_sra_stage(st + 1)(bitpos) <=
          s_sra_stage(st)(31) when s_shamt(st) = '1' else
          s_sra_stage(st)(bitpos);
      end generate gen_sra_out_range;

    end generate gen_sra_bit;
  end generate gen_sra_stage;

  s_sra <= s_sra_stage(5);

  gen_reverse_input : for bitpos in 0 to 31 generate
    s_left_input(bitpos) <= iA(31 - bitpos);
  end generate gen_reverse_input;

  s_sll_stage(0) <= s_left_input;

  gen_sll_stage : for st in 0 to 4 generate
    gen_sll_bit : for bitpos in 0 to 31 generate

      gen_sll_in_range : if bitpos + C_SHIFT(st) <= 31 generate
        s_sll_stage(st + 1)(bitpos) <=
          s_sll_stage(st)(bitpos + C_SHIFT(st)) when s_shamt(st) = '1' else
          s_sll_stage(st)(bitpos);
      end generate gen_sll_in_range;

      gen_sll_out_range : if bitpos + C_SHIFT(st) > 31 generate
        s_sll_stage(st + 1)(bitpos) <=
          '0' when s_shamt(st) = '1' else
          s_sll_stage(st)(bitpos);
      end generate gen_sll_out_range;

    end generate gen_sll_bit;
  end generate gen_sll_stage;

  gen_reverse_output : for bitpos in 0 to 31 generate
    s_sll(bitpos) <= s_sll_stage(5)(31 - bitpos);
  end generate gen_reverse_output;

  with iALUCtrl select
    s_result <= s_add  when ALU_ADD,
                s_sub  when ALU_SUB,
                s_and  when ALU_AND,
                s_or   when ALU_OR,
                s_xor  when ALU_XOR,
                s_sll  when ALU_SLL,
                s_srl  when ALU_SRL,
                s_sra  when ALU_SRA,
                s_slt  when ALU_SLT,
                s_sltu when ALU_SLTU,
                s_pass when ALU_PASS,
                s_nor  when ALU_NOR,
                x"00000000" when others;

  oResult <= s_result;

  oZero <= '1' when s_result = x"00000000" else
           '0';

end architecture dataflow;