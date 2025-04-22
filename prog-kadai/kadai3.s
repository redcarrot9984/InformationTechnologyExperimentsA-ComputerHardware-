#
# (multiply1.s)
#	
        INITIAL_GP = 0x10008000
        INITIAL_SP = 0x7ffffffc
        # system call service number
        stop_service = 99
 
        .text
init:
        # initialize $gp (global pointer) and $sp (stack pointer)
        la      $gp, INITIAL_GP         # $gp <- 0x10008000 (INITIAL_GP)
        la      $sp, INITIAL_SP         # $sp <- 0x7ffffffc (INITIAL_SP)
        jal     main                    # jump to `main'
        nop                             #   (delay slot)
        li      $v0, stop_service       # $v0 <- 99 (stop_service)
        syscall                         # halt
        nop
        # not reach here
stop:                                   # if syscall return 
        j stop                          # infinite loop...
        nop
 
 
        .text   0x00001000
main:
        sw      $ra, 0($sp)             # save $ra to stack
        li      $a0, 6			# $a0 <-- 6
	li	$a1, 10			# $a1 <-- 10
	jal	multiply		# call multiply routine
	nop				#   (delay slot)
        sw      $v0, 0xc000($gp)        # mem[0x10004000] <- $v0
        sw      $v1, 0xc004($gp)        # mem[0x10004004] <- $v1
	    add	$s0, $v0, $zero
	    add	$s1, $v1, $zero
        lw      $ra, 0($sp)             # restore $ra to stack
        nop                             #   (delay slot)
        jr      $ra                     # return from `main'
        nop                             #   (delay slot)
    	
multiply:
        li     $t0, 32        # t0 = 32 (loop counter)
        li     $t1, 0         # v0 = 0
        li     $t2, 0         # v1 = 0
loop:
        sll    $t4, $a1, 31     # t4 = a1 & 1
        srl    $t4, $t4, 31
        andi    $t4, $t4, 1
        beq    $t4, $zero, skip_add
        nop
        addu   $t1, $t1, $a0   # v0 += a0
     
skip_add:
    
        sll    $t3, $t1, 31    # t3 = v0 << 31
        or     $t2, $t2, $t3   # v1 |= (v0 << 31)
     
        srl    $t1, $t1, 1     # v0 >>= 1
     
        addi   $t0, $t0, -1
        beq    $t0, $zero, done
        nop
        srl    $t2, $t2, 1     # v1 >>= 1
        srl    $a1, $a1, 1     # a1 >>= 1
        j      loop
     
done:
    addu    $v0, $t1, $zero   # v0 ← 上位ワード (t1 の内容を v0 にコピー)
    addu    $v1, $t2, $zero   # v1 ← 下位ワード (t2 の内容を v1 にコピー)
    jr      $ra
    nop
    	
    
 
# End of file (multiply1.s)
