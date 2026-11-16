# t09_ordenacion.asm
# Instrucciones: todas las de S-MIPS en un programa integrador (burbuja sobre un vector en memoria)
#   add, sub, and, or, slt, slti, sll, srl, addi, andi, ori, lui, lw, sw, lb, lbu, sb, beq, bne, j, jal, jr, syscall
# Tabla 3: lw/sw con desplazamientos, beq/bne hacia atras, j, jal/jr no hoja, srl sobre valor negativo,
#   lb/lbu y sb sobre bytes con bit 7 = 1; imprime el vector ordenado y una suma de verificacion.
.text
main:
  li $s7,0x2100
  li $s1,40
  li $s2,-7
  li $s3,0x7FF0
  li $s4,-32768
  li $s5,15
  li $s6,-1
  li $k0,0
  li $k1,1000
  sw $s1,0($s7)
  sw $s2,4($s7)
  sw $s3,8($s7)
  sw $s4,12($s7)
  sw $s5,16($s7)
  sw $s6,20($s7)
  sw $k0,24($s7)
  sw $k1,28($s7)
  li $a3,8
o_ext:
  addi $a3,$a3,-1
  beq $a3,$zero,o_fin
  move $a2,$zero
  move $v1,$s7
o_int:
  lw $t3,0($v1)
  lw $t4,4($v1)
  slt $t5,$t4,$t3
  beq $t5,$zero,o_noswap
  sw $t4,0($v1)
  sw $t3,4($v1)
o_noswap:
  addi $v1,$v1,4
  addi $a2,$a2,1
  bne $a2,$a3,o_int
  j o_ext
o_fin:
  li $a3,0
  move $a2,$s7
o_pr:
  lw $a0,0($a2)
  jal phs
  addi $a2,$a2,4
  addi $a3,$a3,1
  slti $t3,$a3,8
  beq $t3,$zero,o_ok
  andi $t4,$a3,3
  bne $t4,$zero,o_pr
  li $a0,10
  li $v0,11
  syscall
  j o_pr
o_ok:
  li $a0,10
  li $v0,11
  syscall
  li $s1,0
  li $a3,8
  move $a2,$s7
o_sum:
  lw $t3,0($a2)
  srl $t4,$s1,3
  sll $t5,$s1,5
  or $t4,$t4,$t5
  add $s1,$t4,$t3
  addi $a2,$a2,4
  addi $a3,$a3,-1
  bne $a3,$zero,o_sum
  move $a0,$s1
  jal phs
  lb $a0,3($s7)
  jal phs
  lbu $a0,3($s7)
  jal phs
  li $t3,0xA5
  sb $t3,0($s7)
  lw $a0,0($s7)
  lui $t4,0x8000
  and $a0,$a0,$t4
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
