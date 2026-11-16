# t01_aritmetica.asm
# Instrucciones: add, sub, and, or, addi, addiu (via li), addu (via move), jal, jr, syscall
# Tabla 3: add/sub con operandos positivos y con negativos; and/or con unos en los
#   16 bits altos; addi con inmediato negativo; addiu/addu mediante li (-2^15..2^15-1) y move.
.text
main:
  li $s1,1200
  li $s2,345
  li $s3,-777
  li $s4,-32768
  li $s5,32767
  add $a0,$s1,$s2
  jal phs
  add $a0,$s1,$s3
  jal phs
  add $a0,$s3,$s4
  jal phs
  add $a0,$s5,$s5
  jal phn
  sub $a0,$s1,$s2
  jal phs
  sub $a0,$s2,$s1
  jal phs
  sub $a0,$s1,$s3
  jal phs
  sub $a0,$s4,$s5
  jal phn
  li $s1,0xFFFF0F0F
  li $s2,0x1234FF00
  li $s3,0x8000FFFF
  and $a0,$s1,$s2
  jal phs
  or $a0,$s1,$s2
  jal phs
  and $a0,$s1,$s3
  jal phs
  or $a0,$s2,$s3
  jal phn
  li $s4,-1
  and $a0,$s1,$s4
  jal phs
  or $a0,$s3,$s4
  jal phs
  li $s5,0
  and $a0,$s1,$s5
  jal phs
  or $a0,$s1,$s5
  jal phn
  li $s1,100
  addi $a0,$s1,-7
  jal phs
  addi $a0,$s1,-100
  jal phs
  addi $a0,$s1,-32768
  jal phs
  addi $a0,$zero,-1
  jal phn
  li $s2,-32768
  li $s3,32767
  li $s4,-1
  li $s5,0
  move $a0,$s2
  jal phs
  move $a0,$s3
  jal phs
  move $a0,$s4
  jal phs
  move $a0,$s5
  jal phn
  li $v0,10
  syscall

# ---------------- subrutinas de impresion ----------------
# ph: imprime $a0 como 8 digitos hexadecimales (usa $s0,$t0,$t1,$t2,$a0,$v0)
ph:
  move $s0,$a0
  li $t0,8
ph_lp:
  srl $t1,$s0,28
  sll $s0,$s0,4
  slti $t2,$t1,10
  bne $t2,$zero,ph_dg
  addi $t1,$t1,55
  j ph_ou
ph_dg:
  addi $t1,$t1,48
ph_ou:
  move $a0,$t1
  li $v0,11
  syscall
  addi $t0,$t0,-1
  bne $t0,$zero,ph_lp
  jr $ra
# phs: ph y un espacio. phn: ph y un salto de linea (no son hoja: guardan $ra)
phs:
  addi $sp,$sp,-4
  sw $ra,0($sp)
  jal ph
  li $a0,32
  li $v0,11
  syscall
  lw $ra,0($sp)
  addi $sp,$sp,4
  jr $ra
phn:
  addi $sp,$sp,-4
  sw $ra,0($sp)
  jal ph
  li $a0,10
  li $v0,11
  syscall
  lw $ra,0($sp)
  addi $sp,$sp,4
  jr $ra
