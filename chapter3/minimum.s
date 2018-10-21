# PURPPOSE: This program finds the minimum number of a
#	    set of data items.
#
# VARIABLES: The registers have the following uses:
#
# %edi - Holds the index of the data item being examined
# %ebx - Smallest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used
#	       to terminate the data.

.section .data

data_items:		# These are the data items.
.long 3,67,34,222,45,75,54,34,44,2,22,11,66,255

.section .text

.globl _start

_start:
movl $0, %edi	# move 0 into the index registry
movl data_items(,%edi,4), %eax	# load the first byte of data
movl %eax, %ebx 	# since this is the first item, %eax is the smallest


start_loop:
cmpl $255, %eax 	# check to see if we've hit the end
je loop_exit
incl %edi 	# load next value
movl data_items(,%edi,4), %eax
cmpl %ebx, %eax 	#compare values
jge start_loop 	# jump to beginning if the new one isn't smaller

movl %eax, %ebx 	# move the value as smallest

jmp start_loop 	# loop to the beginning

loop_exit:
# %ebx is the status code for the exit system call
# and it already has the miniimum number

movl $1, %eax 	# 1 is the exit() syscall
int $0x80

# To run this program:
#
# as minimum.s -o minimum.o
# ld minimum.o -o minimum
# ./minimum
# echo $?
#
# Echo should return the value 2 since it is the smallest data item
