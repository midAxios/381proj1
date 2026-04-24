.text
.globl main
main:
  addi sp, x0, 0x700
  addi s0, x0, 0
  addi s1, x0, 5
  jal  ra, call1
  jal  x0, done

call1:
  addi sp, sp, -4
  sw   ra, 0(sp)
  addi s0, s0, 1
  jal  ra, call2
  lw   ra, 0(sp)
  addi sp, sp, 4
  jalr x0, 0(ra)

call2:
  addi sp, sp, -4
  sw   ra, 0(sp)
  addi s0, s0, 1
  jal  ra, call3
  lw   ra, 0(sp)
  addi sp, sp, 4
  jalr x0, 0(ra)

call3:
  addi sp, sp, -4
  sw   ra, 0(sp)
  addi s0, s0, 1
  jal  ra, call4
  lw   ra, 0(sp)
  addi sp, sp, 4
  jalr x0, 0(ra)

call4:
  addi sp, sp, -4
  sw   ra, 0(sp)
  addi s0, s0, 1
  jal  ra, call5
  lw   ra, 0(sp)
  addi sp, sp, 4
  jalr x0, 0(ra)

call5:
  addi s0, s0, 1
  beq  s0, s1, eq_taken
  addi t0, x0, -1
eq_taken:
  bne  s0, x0, ne_taken
  addi t0, x0, -2
ne_taken:
  blt  x0, s0, lt_taken
  addi t0, x0, -3
lt_taken:
  bge  s0, x0, ge_taken
  addi t0, x0, -4
ge_taken:
  bltu x0, s0, ltu_taken
  addi t0, x0, -5
ltu_taken:
  bgeu s0, x0, geu_taken
  addi t0, x0, -6
geu_taken:
  jalr x0, 0(ra)

done:
  wfi
