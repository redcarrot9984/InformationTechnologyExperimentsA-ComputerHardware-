 
	INITIAL_GP = 0x10008000		# initial value of global pointer
	INITIAL_SP = 0x7ffffffc		# initial value of stack pointer
	# system call service number
	stop_service = 99
 
	.text
init:
	# initialize $gp (global pointer) and $sp (stack pointer)
	la	$gp, INITIAL_GP		# (下の2行に置き換えられる)
	la	$sp, INITIAL_SP		# (下の2行に置き換えられる)
	jal	main			# jump to `main'
	nop				# (delay slot)
	li	$v0, stop_service	# $v0 <-- 99 (stop_service)
	syscall				# stop
	nop
	# not reach here
stop:					# if syscall return
	j 	stop			# infinite loop...
	nop				# (delay slot)
 
	.text 	0x00001000
main:
	addi	$sp, $sp, -4		# スタックに保存領域(1ワード)を確保
	sw	$ra, 0($sp)		# $raの値をスタックに保存しておく
	la	$a0, DEST		# DEST のアドレスを $a0 に設定
	la	$a1, SRC		# SRC のアドレスを $a1 に設定
	li	$a2, 10			# $a3 <-- 10  (n)
	jal	memcopy			# サブルーチン 'memcopy' を呼び出す
	nop				# (delay slot)
					# sum_n の処理結果は $v0 に格納
	ori	$v1, $v0, 0		# $v1 <-- $v0
	lw	$ra, 0($sp)		# $raの値をスタックから復元
	nop				# (delay slot)
	addi	$sp, $sp, 4		# スタックの保存領域(1ワード)を開放
	jr	$ra			# return
	nop				# (delay slot)
 
	#
	# int *memcopy(int *dest, int *src, int n)
	#   アドレス src から始まる n ワードのデータをアドレス dest
	#   から始まる領域にコピーする
	#   引数 dest: $a0, src: $a1, n: $a2
	#   返値 $v0 ... destの値をそのまま返す
	.text	0x00002000
    .align  2
memcopy:
    ori     $s0, $a0, 0
$LOOP:
    beq    $a2, $zero, $EXIT    #if (n == 0)$EXIT
    nop
    lw  $t0, 0($a1)             #$t0 = *src
    nop
    sw  $t0, 0($a0)             #*dest = $t0
    addi    $a1, $a1, 4         #src++
    addi    $a0, $a0, 4         #dest++
    addi    $a2, $a2, -1        #n--
    j   $LOOP
    nop
$EXIT:
    ori     $v0, $s0, 0 #$v0 = $a0|0
        
	jr	$ra			# リターン
	nop				# (delay slot)
 
	.data	0x10004000
SRC:
    .word	0, 1, 2, 3, 4, 5, 6, 7, 8
	.word	9, 10, 11, 12, 13, 14, 15
	.word	16, 17, 18, 19
 
	.data   0x10005000
DEST:
    .word   0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	.word   0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	.word   0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	.word   0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	.word   0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	.word   0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	.word   0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	.word   0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
 
# End of file (memcopy1.s)
