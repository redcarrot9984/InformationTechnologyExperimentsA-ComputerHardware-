       # data segment
        .data   0x10004000
RESULT: .word   0xffffffff
BASE:   .word   0x10004100    # 加算するデータが格納されている先頭アドレス
        .word   5             # データの個数
        .data   0x10004100
DATA:   .word   1, 2, 3, 4, 5
 
    .text
    .align 2
 
main:
    addi $sp,$sp,-32
    nop
    sw $ra,0($sp)
    nop
    la $t0,BASE
   
    lw $t1,4($t0)
    nop
    
    lw $t2,0($t0)
    nop
    li $t3,0
$LOOP:
    nop
    beq $t1,$zero,$END
    nop
    lw $t4,0($t2)
    nop
    add $t3,$t3,$t4
    addi $t2,$t2,4
    addi $t1,$t1,-1
    j $LOOP
$END:
    la $t0,RESULT
    lw $t1,0($t0)
    nop
    sw $t3,0($t1)
 
    nop
    lw $a0,0($t1)
    nop
    jal print_int
    nop
    
    add $a0,$t3,$zero
    nop
    jal print_int
    nop
    lw $ra,0($sp)
    nop
    addi $sp,$sp,32
    nop
    li  $v0, 99
    syscall
    #jr $ra
    nop
    
 
print_int:
    addi $sp,$sp,-32
    nop
    sw $ra,0($sp)
    nop
    li $v0,1
    nop
    syscall
    lw $ra,0($sp)
    nop
    addi $sp,$sp,32
    nop
    jr $ra
    nop
