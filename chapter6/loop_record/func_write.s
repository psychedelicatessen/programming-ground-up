.include "linux.s"
.include "record-def.s"

# Purpose:	This function writes a record
#		to the given file descriptor
#
# Input:	The file descriptor and a buffer
#
# Output:	This function produces a status code
#
# STACK LOCAL VARIABLES
.equ ST_WRITE_BUFFER, 8
.equ ST_FIELDS, 12
.section .text
.globl write_record
.type write_record, @function

write_record:
pushl %ebp
movl %esp, %ebp

pushl %ebx
movl $WRITE, %eax
movl ST_FIELDS(%ebp), %ebx
movl ST_WRITE_BUFFER(%ebp), %ecx
movl $RECORD_SIZE, %edx
int $LINUX_SYSCALL

# NOTE - %eax has the return value, which we will
#	 give back to our valling program

popl %ebx

movl %ebp, %esp
popl %ebp
ret
