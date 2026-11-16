# t03_inmediatos_zero.asm
# Instrucciones: andi, ori, lui, sll, add, lw, sw, slt, li, move, jal, jr, syscall
# Tabla 3: andi/ori con inmediato de bit 15 = 1 (extension con ceros); lui con inmediato de bit 15 = 1;
#   $zero: instrucciones que escriben en $zero y despues se comprueba que sigue valiendo 0.
.text
main:
  li $s1,-1
  li $s2,0x12340000
  li $s3,0x12345678
  li $s7,0x2100
  andi $a0,$s1,0x8001
  jal phs
  andi $a0,$s1,0xFFFF
  jal phs
  andi $a0,$s3,0x8000
  jal phs
  andi $a0,$s3,0xF0F0
  jal phn
  ori $a0,$zero,0x8000
  jal phs
  ori $a0,$s2,0x8001
  jal phs
  ori $a0,$s2,0xF0F0
  jal phs
  ori $a0,$s1,0x8000
  jal phn
  lui $a0,0x8000
  jal phs
  lui $a0,0xFFFF
  jal phs
  lui $a0,0xABCD
  jal phs
  lui $a0,0x8001
  jal phn
  addi $zero,$s3,9
  move $a0,$zero
  jal phs
  ori $zero,$s3,0xFFFF
  move $a0,$zero
  jal phs
  lui $zero,0xFFFF
  move $a0,$zero
  jal phs
  sll $zero,$s3,4
  move $a0,$zero
  jal phn
  add $zero,$s3,$s3
  move $a0,$zero
  jal phs
  sw $s3,0($s7)
  lw $zero,0($s7)
  move $a0,$zero
  jal phs
  slt $zero,$s1,$s3
  move $a0,$zero
  jal phs
  andi $zero,$s3,0x8000
  add $a0,$zero,$s3
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
