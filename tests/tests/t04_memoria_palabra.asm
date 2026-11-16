# t04_memoria_palabra.asm
# Instrucciones: lw, sw, addi, li, move, jal, jr, syscall
# Tabla 3: lw/sw con desplazamiento positivo y con desplazamiento negativo (y palabras vecinas
#   sin interferencia entre ellas).
.text
main:
  li $s7,0x2100
  li $s1,0x11111111
  li $s2,0x22222222
  li $s3,0x33333333
  li $s4,0x44444444
  li $s5,0x55555555
  li $s6,0x66666666
  sw $s1,0($s7)
  sw $s2,4($s7)
  sw $s3,8($s7)
  sw $s4,-4($s7)
  sw $s5,-8($s7)
  sw $s6,-64($s7)
  sw $s6,200($s7)
  lw $a0,0($s7)
  jal phs
  lw $a0,4($s7)
  jal phs
  lw $a0,8($s7)
  jal phs
  lw $a0,-4($s7)
  jal phn
  lw $a0,-8($s7)
  jal phs
  lw $a0,-64($s7)
  jal phs
  lw $a0,200($s7)
  jal phs
  lw $a0,12($s7)
  jal phn
  addi $k0,$s7,16
  lw $a0,-16($k0)
  jal phs
  lw $a0,-12($k0)
  jal phs
  lw $a0,-8($k0)
  jal phs
  lw $a0,-20($k0)
  jal phn
  addi $k1,$s7,-32
  sw $s1,32($k1)
  sw $s2,36($k1)
  sw $s3,-4($k1)
  lw $a0,0($s7)
  jal phs
  lw $a0,4($s7)
  jal phs
  lw $a0,-36($s7)
  jal phs
  lw $a0,-4($k1)
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
