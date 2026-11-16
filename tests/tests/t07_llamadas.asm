# t07_llamadas.asm
# Instrucciones: jal, jr, sw, lw, add, addi, beq, bne, j, li, move, syscall
# Tabla 3: jal/jr con un procedimiento que llama a otro (no hoja), guardando $ra en la pila y
#   retornando correctamente (anidamiento de 3 niveles y recursion); se imprime $sp al final.
.text
main:
  li $a1,3
  li $a2,4
  jal sumcuad
  move $a0,$v1
  jal phs
  li $a1,5
  jal fact
  move $a0,$v1
  jal phs
  li $a1,6
  jal fact
  move $a0,$v1
  jal phn
  li $a1,2
  jal nivel1
  move $a0,$v1
  jal phs
  move $a0,$sp
  jal phn
  li $v0,10
  syscall
cuad:
  move $v1,$zero
  move $k0,$a1
cuad_l:
  beq $k0,$zero,cuad_f
  add $v1,$v1,$a1
  addi $k0,$k0,-1
  j cuad_l
cuad_f:
  jr $ra
sumcuad:
  addi $sp,$sp,-12
  sw $ra,8($sp)
  sw $a2,4($sp)
  jal cuad
  sw $v1,0($sp)
  lw $a1,4($sp)
  jal cuad
  lw $k1,0($sp)
  add $v1,$v1,$k1
  lw $ra,8($sp)
  addi $sp,$sp,12
  jr $ra
fact:
  addi $sp,$sp,-8
  sw $ra,4($sp)
  sw $a1,0($sp)
  li $v1,1
  beq $a1,$zero,fact_r
  addi $a1,$a1,-1
  jal fact
  lw $a1,0($sp)
  move $k1,$v1
  move $v1,$zero
  move $k0,$a1
fact_m:
  beq $k0,$zero,fact_r
  add $v1,$v1,$k1
  addi $k0,$k0,-1
  j fact_m
fact_r:
  lw $ra,4($sp)
  addi $sp,$sp,8
  jr $ra
nivel1:
  addi $sp,$sp,-4
  sw $ra,0($sp)
  addi $a1,$a1,1
  jal nivel2
  addi $v1,$v1,100
  lw $ra,0($sp)
  addi $sp,$sp,4
  jr $ra
nivel2:
  addi $sp,$sp,-4
  sw $ra,0($sp)
  addi $a1,$a1,1
  jal nivel3
  addi $v1,$v1,10
  lw $ra,0($sp)
  addi $sp,$sp,4
  jr $ra
nivel3:
  add $v1,$a1,$a1
  jr $ra

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
