# t08_syscall_decimal.asm
# Instrucciones: syscall (servicios 11 y 10), slt, sub, bne, j, jal, jr, sw, lw, addi, li, move
# Tabla 3: syscall con los servicios 11 (imprimir caracter) y 10 (terminar). Imprime en decimal
#   numeros calculados (solo con el servicio 11) y comprueba que tras el servicio 10 la CPU se detiene
#   (el codigo posterior al syscall 10 imprimiria una X si la CPU no se parase).
.text
main:
  li $a1,1000
  addi $a1,$a1,200
  addi $a1,$a1,30
  addi $a1,$a1,4
  jal pdec
  li $a0,32
  li $v0,11
  syscall
  li $a1,42
  jal pdec
  li $a0,32
  li $v0,11
  syscall
  li $a1,9999
  jal pdec
  li $a0,10
  li $v0,11
  syscall
  li $a1,0
  jal pdec
  li $a0,32
  li $v0,11
  syscall
  li $a1,305
  addi $a1,$a1,-5
  jal pdec
  li $a0,10
  li $v0,11
  syscall
  li $s1,83
  li $s2,77
  move $a0,$s1
  li $v0,11
  syscall
  move $a0,$s2
  syscall
  addi $a0,$s2,-4
  syscall
  addi $a0,$s2,3
  syscall
  addi $a0,$s1,0
  syscall
  li $a0,10
  syscall
  li $v0,10
  syscall
  li $a0,88
  li $v0,11
  syscall
  li $a0,89
  syscall
pdec:
  addi $sp,$sp,-4
  sw $ra,0($sp)
  li $a2,1000
  jal pdig
  li $a2,100
  jal pdig
  li $a2,10
  jal pdig
  li $a2,1
  jal pdig
  lw $ra,0($sp)
  addi $sp,$sp,4
  jr $ra
pdig:
  li $t1,0
pd_lp:
  slt $t2,$a1,$a2
  bne $t2,$zero,pd_ou
  sub $a1,$a1,$a2
  addi $t1,$t1,1
  j pd_lp
pd_ou:
  addi $a0,$t1,48
  li $v0,11
  syscall
  jr $ra
