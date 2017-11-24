########################################################################
# Student: Eric Schenck						Date: 11/25/17
# Description: LabFourProblem2.asm - Write a recursive function that computes the smallest integer in 
#				a given array of integers. Also write a main program that calls the Min
#				function on the following data and prints out the result.
#				A = {5,2,-9,10,-23,43,2,1,3,5,10} low = 0 and high = 10
#
######################################################################## 						
#
# Registers Used:
#	$a0: Used for A[] argument & to print the final results
#	$a1: Used for 2nd argument
#	$a2: Used for 3rd argument
#	$t0: Used hold low*4 + address for A[] . And hold Min1 value 
#	$t1: Used to hold and calulate mid 
#	$v0: Used for return variable from Func and also Syscall 
#	$ra: return address 
#	$sp: stack pointer
#
########################################################################
# PseudoCode
# 
# int Min( int[] A , int low , int high ){
#	if( low == high ){			# BASE CASE
# 		return A[low];
#	}
#	int mid = (low + high) / 2;
#	int min1 = Min( A , low , mid );	# RECURSIVE CALL
#	int min2 = Min( A, mid + 1, high );	# RECURSIVE CALL
#	
#	if ( min1 > min2 ){
#		return min2;
#	}else{
#		return min1;
#	}
#	
#    }	
#
#########################################################################
		.data
resultmsg:	.asciiz "\n Results of Program 2 (Min) == "
A:		.word 5, 2, -9, 10, -23, 43, 2, 1, 3, 5, 10

		.text
		.globl main
		
main: 		
		la $a0, A			# loading array address into $a0
		move $a1, $zero			# $a1 = 0 : (low)
		li $a2, 10			# $a2 = 10 : (high)
				
		jal Min				# calling Min( int[] A , int low , int high ) recursive function
		
		move $t0, $v0			# moving return value into $t0 to store temporarily
		
		la $a0, resultmsg 		# loading address of result message into $a0
		li $v0 4			# code to print string
		syscall
			
		move $a0, $t0			# moving result into $a0 for printout
		li $v0, 1			# code to print integer
		syscall	
																																																																		
																		
Exit:		li $v0, 10 			# System code to exit
		syscall				# make system call 

########################################################################
		
		.text

Min:		bne $a1, $a2, Next		# if ( low != high ) goto Next
		move $t0, $a1			# set $t0 = low
		sll $t0, $t0, 2			# $t0 *= 4  (for Byte addressing offset)
		add $t0, $t0, $a0		# $t0 += address of A 
		lw $v0, 0($t0)			# $v0 = A[low]
		j return			
		
Next:		add $t1, $a1 $a2		# $t1 : mid = (low + high)		
 		srl $t1, $t1, 1			# $t1 /= 2 
 		
 		addi $sp, $sp, -12		# allocating stack for 3 elements
 		sw $ra, 8($sp)			# return address stored in stack
 		sw $t1, 4($sp)			# mid stored onto stack 
 		sw $a2, 0($sp)			# high stored onto stack
 						
 						# address for A[] still in $a0 and low still in $a1
 		move $a2, $t1			# moving mid onto last argument register
 		
 		jal Min				# RECURSIVE CALL Min(A[],low,mid)
 		
 		lw $a2, 0($sp)			# loading high into $a2
 		lw $a1, 4($sp)			# loading mid into $a1
 		
 		addi $a1, $a1, 1		# $a1 = mid + 1
 		
 		sw $v0, 4($sp)			# min1 stored in stack
 		
 		jal Min				# RECURSIVE CALL Min(A[],mid+1,high)
 		
 		lw $t0, 4($sp)			# loading min1 into $t0
 		lw $ra, 8($sp)			# loading original regturn address back into $ra
 		addi $sp, $sp, 12		# de-allocating stack since no longer needed
 		
 		ble $t0, $v0, Else		# if ( min1 <= min2 ) goto Else
 		j return			# min2 is already in $v0 so return
 
Else:		move $v0, $t0			# moving min1 into return register
		
return:		jr $ra				# return value in $v0
