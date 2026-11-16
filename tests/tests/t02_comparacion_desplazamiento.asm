# t02_comparacion_desplazamiento.asm
# Instrucciones: slt, slti, sll, srl, li, move, jal, jr, syscall
# Tabla 3: slt/slti con resultado 1 y con resultado 0, y casos con operando negativo en los que la
#   comparacion con signo y sin signo dan resultados distintos; sll/srl con shamt=0 y shamt!=0;
#   srl sobre un valor negativo (entran ceros).
.text
main:
  li $s1,-1
  li $s2,1
  li $s3,-5
  li $s4,7
  slt $a0,$s1,$s2
  jal phs
  slt $a0,$s2,$s1
  jal phs
  slt $a0,$s3,$s4
  jal phs
  slt $a0,$s4,$s3
  jal phn
  slt $a0,$s2,$s2
  jal phs
  slt $a0,$s3,$s1
  jal phs
  slt $a0,$s1,$s3
  jal phs
  slt $a0,$zero,$s2
  jal phn
  slti $a0,$s1,1
  jal phs
  slti $a0,$s2,-1
  jal phs
  slti $a0,$s4,8
  jal phs
  slti $a0,$s4,7
  jal phn
  slti $a0,$s3,-5
  jal phs
  slti $a0,$s3,-4
  jal phs
  slti $a0,$zero,0
  jal phs
  slti $a0,$s1,0
  jal phn
  li $s5,0x80000001
  li $s6,0x12345678
  sll $a0,$s5,0
  jal phs
  sll $a0,$s5,1
  jal phs
  sll $a0,$s6,4
  jal phs
  sll $a0,$s5,31
  jal phn
  sll $a0,$s4,16
  jal phs
  sll $a0,$s6,8
  jal phs
  sll $a0,$s2,31
  jal phs
  sll $a0,$s6,0
  jal phn
  srl $a0,$s5,0
  jal phs
  srl $a0,$s5,1
  jal phs
  srl $a0,$s6,4
  jal phs
  srl $a0,$s5,31
  jal phn
  srl $a0,$s1,4
  jal phs
  srl $a0,$s1,16
  jal phs
  srl $a0,$s3,8
  jal phs
  srl $a0,$s1,31
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
