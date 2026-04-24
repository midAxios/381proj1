.data
base_words:
  .word 0x12345678
  .word 0xFFFFFF80
  .word 0x0000007F
store_slot:
  .word 0x00000000

.text
.globl main
main:
  addi x1, x0, 5
  addi x2, x0, -3
  add  x3, x1, x2
  sub  x4, x1, x2
  and  x5, x1, x2
  or   x6, x1, x2
  xor  x7, x1, x2
  andi x8, x6, 0x0f
  ori  x9, x0, 0x55
  xori x10, x9, 0x0f
  slt  x11, x2, x1
  slti x12, x2, 0
  sltiu x13, x1, 10
  slli x14, x1, 2
  sll  x15, x1, x1
  srli x16, x14, 1
  srl  x17, x14, x1
  srai x18, x2, 1
  sra  x19, x2, x1
  lui  x20, 0x12345
  auipc x21, 0

  la   x22, base_words
  lw   x23, 0(x22)
  lb   x24, 4(x22)
  lbu  x25, 4(x22)
  lh   x26, 0(x22)
  lhu  x27, 0(x22)
  la   x28, store_slot
  sw   x23, 0(x28)
  wfi
