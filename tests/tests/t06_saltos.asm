# t06_saltos.asm
# Instrucciones: beq, bne, j, add, addi, li, move, jal, jr, syscall
# Tabla 3: beq y bne tomados y no tomados; saltos hacia atras (bucles con bne, beq y j); j al
#   menos una vez (hacia adelante y hacia atras).
.text
main:
  li $s1,10
  li $s2,10
  li $s3,20
  li $a1,0
  beq $s1,$s2,b1
  addi $a1,$a1,1
b1:
  beq $s1,$s3,b2
  addi $a1,$a1,2
b2:
  bne $s1,$s3,b3
  addi $a1,$a1,4
b3:
  bne $s1,$s2,b4
  addi $a1,$a1,8
b4:
  move $a0,$a1
  jal phs
  li $a2,0
  li $a3,10
lp1:
  add $a2,$a2,$a3
  addi $a3,$a3,-1
  bne $a3,$zero,lp1
  move $a0,$a2
  jal phs
  li $k0,5
  li $k1,0
lp2:
  beq $k0,$zero,lp2e
  addi $k1,$k1,3
  addi $k0,$k0,-1
  j lp2
lp2e:
  move $a0,$k1
  jal phn
  li $v1,1
  j fw
  li $v1,99
fw:
  move $a0,$v1
  jal phs
  li $s4,-1
  li $s5,-1
  li $s6,0
  beq $s4,$s5,n1
  addi $s6,$s6,1
n1:
  bne $s4,$s5,n2
  addi $s6,$s6,2
n2:
  beq $s4,$zero,n3
  addi $s6,$s6,4
n3:
  bne $s4,$zero,n4
  addi $s6,$s6,8
n4:
  move $a0,$s6
  jal phs
  li $a1,0
  li $a2,3
lp3:
  addi $a1,$a1,1
  addi $a2,$a2,-1
  beq $a2,$zero,lp3e
  j lp3
lp3e:
  move $a0,$a1
  jal phn
  li $a3,0
  li $k0,4
lp4:
  add $a3,$a3,$k0
  addi $k0,$k0,-1
  bne $k0,$zero,lp4
  move $a0,$a3
  jal phs
  li $a3,0
  li $k0,0
  bne $k0,$zero,lp4
  move $a0,$a3
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
