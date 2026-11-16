# t05_memoria_byte.asm
# Instrucciones: lb, lbu, sb, lw, sw, addi, li, jal, jr, syscall
# Tabla 3: lb/lbu sobre bytes con bit 7 = 1 en varias posiciones de la palabra (d[1:0] = 0,2,3);
#   sb en las cuatro posiciones de una misma palabra (d[1:0] = 0,1,2,3), comprobando con lw que
#   los otros bytes no cambian (sobre palabra en ceros y sobre palabra en unos).
.text
main:
  li $s7,0x2100
  li $s1,0x80FF7F81
  sw $s1,0($s7)
  lb $a0,0($s7)
  jal phs
  lbu $a0,0($s7)
  jal phs
  lb $a0,1($s7)
  jal phs
  lbu $a0,1($s7)
  jal phn
  lb $a0,2($s7)
  jal phs
  lbu $a0,2($s7)
  jal phs
  lb $a0,3($s7)
  jal phs
  lbu $a0,3($s7)
  jal phn
  addi $s6,$s7,8
  lb $a0,-8($s6)
  jal phs
  lb $a0,-5($s6)
  jal phs
  lbu $a0,-6($s6)
  jal phn
  sw $zero,4($s7)
  li $s2,0xFFFFFF12
  li $s3,0x34
  li $s4,0x56
  li $s5,0x78
  sb $s2,4($s7)
  lw $a0,4($s7)
  jal phs
  sb $s3,5($s7)
  lw $a0,4($s7)
  jal phs
  sb $s4,6($s7)
  lw $a0,4($s7)
  jal phs
  sb $s5,7($s7)
  lw $a0,4($s7)
  jal phn
  li $s6,-1
  li $k0,0x5A
  sw $s6,8($s7)
  sb $k0,8($s7)
  lw $a0,8($s7)
  jal phs
  sw $s6,8($s7)
  sb $k0,9($s7)
  lw $a0,8($s7)
  jal phs
  sw $s6,8($s7)
  sb $k0,10($s7)
  lw $a0,8($s7)
  jal phs
  sw $s6,8($s7)
  sb $k0,11($s7)
  lw $a0,8($s7)
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
