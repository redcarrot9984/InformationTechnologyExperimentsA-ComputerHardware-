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
        li      $a0, 121			# $a0 <-- 6
	li	$a1, 10
	li      $s1, 0			# $a1 <-- 10
	jal	josan		# call multiply routine
	nop				#   (delay slot)
        sw      $v0, 0xc000($gp)        # mem[0x10004000] <- $v0
        sw      $v1, 0xc004($gp)        # mem[0x10004004] <- $v1
	add	$s0, $v0, $zero
	add	$s1, $v1, $zero
        lw      $ra, 0($sp)             # restore $ra to stack
        nop                             #   (delay slot)
        jr      $ra                     # return from `main'
        nop                             #   (delay slot)
	
josan:
	sub $s2, $a0, $a1
        slti $t0, $s2, 0
        bne $t0, $zero, owari
        nop
        addi $v0, $v0, 1
        addi $a0, $s2, 0
        j    josan
	nop				#   (delay slot)
owari:
	addi $v1,$a0,0
	jr       $ra
	nop	
