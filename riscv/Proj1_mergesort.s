.data
array:
  .word 9, 4, 7, 1, 8, 2, 6, 3
scratch:
  .word 0, 0, 0, 0, 0, 0, 0, 0
n:
  .word 8

.text
.globl main
main:
  la   s0, array
  la   s1, scratch
  lw   s2, n

  # Bottom-up merge sort. Width grows 1, 2, 4, ...
  addi s3, x0, 1
width_loop:
  bge  s3, s2, sorted
  addi s4, x0, 0

block_loop:
  bge  s4, s2, copy_back
  add  a0, s0, x0
  add  a1, s1, x0
  add  a2, s4, x0
  add  a3, s3, x0
  add  a4, s2, x0
  jal  ra, merge_block
  slli t0, s3, 1
  add  s4, s4, t0
  jal  x0, block_loop

copy_back:
  addi t0, x0, 0
copy_loop:
  bge  t0, s2, next_width
  slli t1, t0, 2
  add  t2, s1, t1
  lw   t3, 0(t2)
  add  t2, s0, t1
  sw   t3, 0(t2)
  addi t0, t0, 1
  jal  x0, copy_loop

next_width:
  slli s3, s3, 1
  jal  x0, width_loop

# merge_block(base, scratch, left, width, n)
merge_block:
  add  t0, a2, x0          # i = left
  add  t1, a2, a3          # mid = left + width
  add  t2, t1, a3          # right = mid + width
  blt  t1, a4, mid_ok
  add  t1, a4, x0
mid_ok:
  blt  t2, a4, right_ok
  add  t2, a4, x0
right_ok:
  add  t3, t1, x0          # j = mid
  add  t4, a2, x0          # k = left

merge_loop:
  bge  t0, t1, drain_right
  bge  t3, t2, drain_left
  slli t5, t0, 2
  add  t5, a0, t5
  lw   t5, 0(t5)
  slli t6, t3, 2
  add  t6, a0, t6
  lw   t6, 0(t6)
  blt  t6, t5, take_right
take_left:
  slli a5, t4, 2
  add  a5, a1, a5
  sw   t5, 0(a5)
  addi t0, t0, 1
  addi t4, t4, 1
  jal  x0, merge_loop
take_right:
  slli a5, t4, 2
  add  a5, a1, a5
  sw   t6, 0(a5)
  addi t3, t3, 1
  addi t4, t4, 1
  jal  x0, merge_loop

drain_left:
  bge  t0, t1, merge_done
  slli t5, t0, 2
  add  t5, a0, t5
  lw   t5, 0(t5)
  slli a5, t4, 2
  add  a5, a1, a5
  sw   t5, 0(a5)
  addi t0, t0, 1
  addi t4, t4, 1
  jal  x0, drain_left

drain_right:
  bge  t3, t2, merge_done
  slli t6, t3, 2
  add  t6, a0, t6
  lw   t6, 0(t6)
  slli a5, t4, 2
  add  a5, a1, a5
  sw   t6, 0(a5)
  addi t3, t3, 1
  addi t4, t4, 1
  jal  x0, drain_right

merge_done:
  jalr x0, 0(ra)

sorted:
  wfi
